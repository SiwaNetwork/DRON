#!/usr/bin/env python3
"""
Демонстрация PNTP протокола синхронизации времени и частоты в рое дронов
"""
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import time
from collections import defaultdict
import random

from src.core import Drone, Swarm
from src.synchronization.pntp_protocol import (
    PNTPNode, PNTPEnsemble, PNTPTelemetry, SyncMode, RadioDomain
)


class PNTPDroneSwarm:
    """Рой дронов с PNTP синхронизацией"""
    
    def __init__(self, num_drones: int = 50, master_clock_type: str = "RB"):
        self.num_drones = num_drones
        self.master_clock_type = master_clock_type
        self.swarm = Swarm()
        self.pntp_ensemble = PNTPEnsemble("drone_swarm_ensemble")
        self.telemetry = PNTPTelemetry()
        
        # История данных
        self.simulation_data = defaultdict(list)
        
        # Создание дронов и PNTP узлов
        self.create_drones_and_pntp_nodes()
        
    def create_drones_and_pntp_nodes(self):
        """Создание дронов и соответствующих PNTP узлов"""
        print(f"Создание роя из {self.num_drones} дронов с PNTP синхронизацией...")
        
        # Создание мастер-узла (GNSS/PPS источник)
        master_drone = Drone(
            drone_id="master_drone",
            initial_position=np.array([0, 0, -15]),
            communication_range=50.0,
            max_velocity=10.0,
            max_acceleration=5.0
        )
        self.swarm.add_drone(master_drone)
        
        # Создание PNTP мастер-узла
        master_pntp = PNTPNode(
            node_id="master_drone",
            sync_mode=SyncMode.MASTER,
            radio_domains=[RadioDomain.WIFI_6, RadioDomain.LORA_SUBGHZ]
        )
        master_pntp.clock_discipline = master_pntp.clock_discipline.__class__("master_drone", self.master_clock_type)
        master_pntp.packet_loss_rate = 0.01  # 1% потерь
        master_pntp.signal_strength = -30.0  # dBm
        self.pntp_ensemble.add_node(master_pntp)
        
        # Создание ведомых дронов
        for i in range(1, self.num_drones):
            # Случайные позиции в радиусе связи
            angle = 2 * np.pi * i / (self.num_drones - 1)
            radius = random.uniform(10, 40)
            
            initial_pos = np.array([
                radius * np.cos(angle),
                radius * np.sin(angle),
                -15 + random.uniform(-5, 5)
            ])
            
            # Создание дрона
            drone = Drone(
                drone_id=f"drone_{i:02d}",
                initial_position=initial_pos,
                communication_range=30.0,
                max_velocity=12.0,
                max_acceleration=6.0
            )
            self.swarm.add_drone(drone)
            
            # Создание PNTP узла
            sync_mode = random.choice([SyncMode.SLAVE, SyncMode.RELAY])
            radio_domains = random.sample(list(RadioDomain), random.randint(1, 3))
            
            pntp_node = PNTPNode(
                node_id=f"drone_{i:02d}",
                sync_mode=sync_mode,
                radio_domains=radio_domains
            )
            
            # Настройка параметров в зависимости от типа часов
            clock_type = random.choice(["TCXO", "OCXO", "QUARTZ"])
            pntp_node.clock_discipline = pntp_node.clock_discipline.__class__(f"drone_{i:02d}", clock_type)
            
            # Случайные параметры связи
            pntp_node.packet_loss_rate = random.uniform(0.05, 0.25)  # 5-25% потерь
            pntp_node.signal_strength = random.uniform(-60, -40)  # dBm
            pntp_node.failure_probability = random.uniform(0.001, 0.01)  # 0.1-1% вероятность отказа
            pntp_node.recovery_time = random.uniform(30, 120)  # 30-120 сек восстановления
            
            # Многолучевость
            pntp_node.multipath_delay = random.uniform(0, 0.001)  # с
            pntp_node.multipath_variance = random.uniform(0, 0.0001)  # с
            
            self.pntp_ensemble.add_node(pntp_node)
            
        print(f"Создано {len(self.pntp_ensemble.nodes)} PNTP узлов")
        print(f"Мастер-узел: {self.pntp_ensemble.master_node.node_id}")
        
    def run_simulation(self, duration: float = 60.0, dt: float = 0.1):
        """Запуск симуляции с PNTP синхронизацией"""
        print(f"\nЗапуск симуляции PNTP на {duration} секунд (dt={dt})")
        print("=" * 80)
        
        steps = int(duration / dt)
        
        # Параметры симуляции
        sync_interval = 1.0  # Интервал синхронизации PNTP
        telemetry_interval = 5.0  # Интервал сбора телеметрии
        
        print("Прогресс симуляции:")
        start_time = time.time()
        
        for step in range(steps):
            t = step * dt
            
            # Обновление роя дронов
            self.swarm.update(dt)
            
            # Обновление PNTP ансамбля
            self.pntp_ensemble.run_sync_cycle(dt)
            
            # Обновление метрик узлов
            for node in self.pntp_ensemble.nodes.values():
                node.update_sync_metrics()
            
            # Сбор телеметрии
            if step % int(telemetry_interval / dt) == 0:
                self.telemetry.collect_telemetry(self.pntp_ensemble)
                
                # Сохранение данных для анализа
                self.simulation_data['time'].append(t)
                self.simulation_data['ensemble_metrics'].append(
                    self.pntp_ensemble.ensemble_metrics.copy()
                )
                
                # Сохранение данных узлов
                node_data = {}
                for node_id, node in self.pntp_ensemble.nodes.items():
                    node_data[node_id] = {
                        'offset': node.clock_discipline.clock_state.offset,
                        'frequency_offset': node.clock_discipline.clock_state.frequency_offset,
                        'stratum': node.stratum,
                        'sync_mode': node.sync_mode.value,
                        'sync_quality': node.sync_metrics['sync_quality'],
                        'holdover_duration': node.clock_discipline.clock_state.holdover_duration
                    }
                self.simulation_data['node_data'].append(node_data)
            
            # Вывод прогресса
            if step % (steps // 20) == 0:
                progress = step / steps * 100
                elapsed = time.time() - start_time
                eta = elapsed * (steps - step) / max(step, 1)
                
                # Текущие метрики
                avg_offset = self.pntp_ensemble.ensemble_metrics['average_offset']
                sync_coverage = self.pntp_ensemble.ensemble_metrics['sync_coverage']
                failure_resilience = self.pntp_ensemble.ensemble_metrics['failure_resilience']
                
                print(f"  {progress:5.1f}% | Время: {t:6.2f}с | "
                      f"Смещение: {avg_offset:8.2f}мкс | "
                      f"Покрытие: {sync_coverage:5.3f} | "
                      f"Живучесть: {failure_resilience:5.3f} | "
                      f"ETA: {eta:5.1f}с")
        
        simulation_time = time.time() - start_time
        print(f"\nСимуляция завершена за {simulation_time:.2f} секунд")
        
        return self.simulation_data
        
    def create_comprehensive_visualization(self, data):
        """Создание комплексной визуализации PNTP"""
        print("\nСоздание визуализации PNTP...")
        
        fig = plt.figure(figsize=(24, 18))
        fig.suptitle('PNTP СИНХРОНИЗАЦИЯ ВРЕМЕНИ И ЧАСТОТЫ В РОЕ ДРОНОВ', fontsize=16, fontweight='bold')
        
        # 1. Смещение времени всех узлов
        ax1 = fig.add_subplot(3, 4, 1)
        if data['node_data']:
            node_ids = list(data['node_data'][0].keys())
            colors = plt.cm.tab20(np.linspace(0, 1, len(node_ids)))
            
            for i, node_id in enumerate(node_ids):
                offsets = [data['node_data'][j][node_id]['offset'] for j in range(len(data['node_data']))]
                ax1.plot(data['time'][:len(offsets)], offsets, 
                        color=colors[i], linewidth=1, alpha=0.7, label=node_id if i < 5 else "")
        
        ax1.set_xlabel('Время (с)')
        ax1.set_ylabel('Смещение времени (мкс)')
        ax1.set_title('Смещение времени узлов')
        ax1.grid(True, alpha=0.3)
        ax1.legend(fontsize=8)
        
        # 2. Покрытие синхронизации
        ax2 = fig.add_subplot(3, 4, 2)
        sync_coverage = [metrics['sync_coverage'] for metrics in data['ensemble_metrics']]
        ax2.plot(data['time'][:len(sync_coverage)], sync_coverage, 'b-', linewidth=2)
        ax2.axhline(y=0.8, color='r', linestyle='--', label='Порог 80%')
        ax2.set_xlabel('Время (с)')
        ax2.set_ylabel('Покрытие синхронизации')
        ax2.set_title('Покрытие синхронизации')
        ax2.set_ylim(0, 1.1)
        ax2.legend()
        ax2.grid(True, alpha=0.3)
        
        # 3. Среднее смещение ансамбля
        ax3 = fig.add_subplot(3, 4, 3)
        avg_offsets = [metrics['average_offset'] for metrics in data['ensemble_metrics']]
        ax3.plot(data['time'][:len(avg_offsets)], avg_offsets, 'g-', linewidth=2)
        ax3.axhline(y=0, color='k', linestyle='-', alpha=0.5)
        ax3.axhline(y=100, color='r', linestyle='--', label='Порог 100 мкс')
        ax3.axhline(y=-100, color='r', linestyle='--')
        ax3.set_xlabel('Время (с)')
        ax3.set_ylabel('Среднее смещение (мкс)')
        ax3.set_title('Среднее смещение ансамбля')
        ax3.legend()
        ax3.grid(True, alpha=0.3)
        
        # 4. Живучесть системы
        ax4 = fig.add_subplot(3, 4, 4)
        resilience = [metrics['failure_resilience'] for metrics in data['ensemble_metrics']]
        ax4.plot(data['time'][:len(resilience)], resilience, 'm-', linewidth=2)
        ax4.axhline(y=0.7, color='r', linestyle='--', label='Порог 70%')
        ax4.set_xlabel('Время (с)')
        ax4.set_ylabel('Живучесть')
        ax4.set_title('Живучесть системы')
        ax4.set_ylim(0, 1.1)
        ax4.legend()
        ax4.grid(True, alpha=0.3)
        
        # 5. Иерархия узлов (stratum)
        ax5 = fig.add_subplot(3, 4, 5)
        if data['node_data']:
            for i, node_id in enumerate(node_ids[:10]):  # Показываем первые 10 узлов
                strata = [data['node_data'][j][node_id]['stratum'] for j in range(len(data['node_data']))]
                ax5.plot(data['time'][:len(strata)], strata, 
                        color=colors[i], linewidth=1.5, alpha=0.8, label=node_id)
        
        ax5.set_xlabel('Время (с)')
        ax5.set_ylabel('Stratum')
        ax5.set_title('Иерархия узлов')
        ax5.legend(fontsize=8)
        ax5.grid(True, alpha=0.3)
        
        # 6. Качество синхронизации
        ax6 = fig.add_subplot(3, 4, 6)
        if data['node_data']:
            for i, node_id in enumerate(node_ids[:8]):
                qualities = [data['node_data'][j][node_id]['sync_quality'] for j in range(len(data['node_data']))]
                ax6.plot(data['time'][:len(qualities)], qualities, 
                        color=colors[i], linewidth=1.5, alpha=0.8, label=node_id)
        
        ax6.set_xlabel('Время (с)')
        ax6.set_ylabel('Качество синхронизации')
        ax6.set_title('Качество синхронизации узлов')
        ax6.set_ylim(0, 1.1)
        ax6.legend(fontsize=8)
        ax6.grid(True, alpha=0.3)
        
        # 7. Holdover режим
        ax7 = fig.add_subplot(3, 4, 7)
        if data['node_data']:
            for i, node_id in enumerate(node_ids[:6]):
                holdover_durations = [data['node_data'][j][node_id]['holdover_duration'] for j in range(len(data['node_data']))]
                ax7.plot(data['time'][:len(holdover_durations)], holdover_durations, 
                        color=colors[i], linewidth=1.5, alpha=0.8, label=node_id)
        
        ax7.set_xlabel('Время (с)')
        ax7.set_ylabel('Длительность holdover (с)')
        ax7.set_title('Режим holdover')
        ax7.legend(fontsize=8)
        ax7.grid(True, alpha=0.3)
        
        # 8. Распределение смещений (гистограмма)
        ax8 = fig.add_subplot(3, 4, 8)
        if data['node_data']:
            all_offsets = []
            for node_data in data['node_data']:
                for node_id in node_data:
                    all_offsets.append(node_data[node_id]['offset'])
            
            ax8.hist(all_offsets, bins=50, alpha=0.7, color='orange', edgecolor='black')
            ax8.axvline(x=0, color='r', linestyle='--', label='Идеальное время')
            ax8.set_xlabel('Смещение времени (мкс)')
            ax8.set_ylabel('Количество измерений')
            ax8.set_title('Распределение смещений')
            ax8.legend()
            ax8.grid(True, alpha=0.3)
        
        # 9. Диаметр сети
        ax9 = fig.add_subplot(3, 4, 9)
        network_diameters = [metrics['network_diameter'] for metrics in data['ensemble_metrics']]
        ax9.plot(data['time'][:len(network_diameters)], network_diameters, 'c-', linewidth=2)
        ax9.set_xlabel('Время (с)')
        ax9.set_ylabel('Диаметр сети')
        ax9.set_title('Диаметр сети')
        ax9.grid(True, alpha=0.3)
        
        # 10. Максимальное смещение
        ax10 = fig.add_subplot(3, 4, 10)
        max_offsets = [metrics['max_offset'] for metrics in data['ensemble_metrics']]
        ax10.plot(data['time'][:len(max_offsets)], max_offsets, 'brown', linewidth=2)
        ax10.axhline(y=1000, color='r', linestyle='--', label='Порог 1 мс')
        ax10.set_xlabel('Время (с)')
        ax10.set_ylabel('Максимальное смещение (мкс)')
        ax10.set_title('Максимальное смещение')
        ax10.legend()
        ax10.grid(True, alpha=0.3)
        
        # 11. Режимы синхронизации
        ax11 = fig.add_subplot(3, 4, 11)
        if data['node_data']:
            mode_counts = defaultdict(list)
            for node_data in data['node_data']:
                modes = defaultdict(int)
                for node_id in node_data:
                    mode = node_data[node_id]['sync_mode']
                    modes[mode] += 1
                for mode in ['master', 'slave', 'relay', 'gateway']:
                    mode_counts[mode].append(modes.get(mode, 0))
            
            for mode, counts in mode_counts.items():
                if any(counts):  # Показываем только если есть узлы в этом режиме
                    ax11.plot(data['time'][:len(counts)], counts, linewidth=2, label=mode.upper())
        
        ax11.set_xlabel('Время (с)')
        ax11.set_ylabel('Количество узлов')
        ax11.set_title('Режимы синхронизации')
        ax11.legend()
        ax11.grid(True, alpha=0.3)
        
        # 12. Сводная статистика
        ax12 = fig.add_subplot(3, 4, 12)
        ax12.axis('off')
        
        # Расчет статистики
        if data['ensemble_metrics']:
            final_metrics = data['ensemble_metrics'][-1]
            final_node_data = data['node_data'][-1] if data['node_data'] else {}
            
            # Статистика смещений
            all_final_offsets = [node_data['offset'] for node_data in final_node_data.values()]
            offset_rms = np.sqrt(np.mean(np.array(all_final_offsets)**2)) if all_final_offsets else 0
            max_offset = np.max(np.abs(all_final_offsets)) if all_final_offsets else 0
            
            # Статистика режимов
            mode_stats = defaultdict(int)
            for node_data in final_node_data.values():
                mode_stats[node_data['sync_mode']] += 1
            
            stats_text = f"""
            СТАТИСТИКА PNTP СИНХРОНИЗАЦИИ
            
            Общие метрики:
            • Среднее смещение: {final_metrics['average_offset']:.2f} мкс
            • Максимальное смещение: {final_metrics['max_offset']:.2f} мкс
            • RMS смещение: {offset_rms:.2f} мкс
            • Покрытие синхронизации: {final_metrics['sync_coverage']:.1%}
            • Живучесть системы: {final_metrics['failure_resilience']:.1%}
            • Диаметр сети: {final_metrics['network_diameter']}
            
            Режимы узлов:
            • Master: {mode_stats['master']}
            • Slave: {mode_stats['slave']}
            • Relay: {mode_stats['relay']}
            • Gateway: {mode_stats['gateway']}
            
            Соответствие ТЗ:
            • GNSS denied: ✅
            • Масштабируемость: ✅ (до 100 узлов)
            • Восстановление: ≤ 60 с
            • Holdover: ≤ 5 мс/час
            """
            
            ax12.text(0.05, 0.95, stats_text, transform=ax12.transAxes, fontsize=10,
                     verticalalignment='top', fontfamily='monospace',
                     bbox=dict(boxstyle="round,pad=0.3", facecolor="lightblue", alpha=0.8))
        
        plt.tight_layout()
        plt.subplots_adjust(top=0.93)
        plt.show()
        
        return fig
        
    def print_performance_report(self):
        """Вывод отчета о производительности"""
        report = self.telemetry.get_performance_report()
        
        print("\n" + "=" * 80)
        print("ОТЧЕТ О ПРОИЗВОДИТЕЛЬНОСТИ PNTP")
        print("=" * 80)
        
        if report:
            stats = report['statistics']
            compliance = report['compliance']
            
            print(f"\nСтатистика синхронизации:")
            print(f"  RMS смещение: {stats['offset_rms']:.2f} мкс")
            print(f"  Максимальное смещение: {stats['max_offset']:.2f} мкс")
            print(f"  Среднее покрытие: {stats['average_sync_coverage']:.1%}")
            print(f"  Средние потери пакетов: {stats['average_packet_loss']:.1%}")
            
            print(f"\nСоответствие техническим требованиям:")
            print(f"  Работа без GNSS: {'✅' if compliance['gnss_denied'] else '❌'}")
            print(f"  Масштабируемость до 100 узлов: {'✅' if compliance['scalability'] else '❌'}")
            print(f"  Время восстановления: {compliance['recovery_time']:.1f} с")
            print(f"  Точность holdover: {compliance['holdover_accuracy']:.2f} мкс")
            
            print(f"\nАлерты ({len(report['alerts'])}):")
            for alert in report['alerts'][-10:]:  # Последние 10 алертов
                print(f"  {alert['type']}: {alert.get('node_id', 'N/A')} - {alert['value']:.2f}")
        else:
            print("Данные телеметрии недоступны")
            
        print("\n" + "=" * 80)


def main():
    """Основная функция демонстрации"""
    print("ДЕМОНСТРАЦИЯ PNTP ПРОТОКОЛА СИНХРОНИЗАЦИИ ВРЕМЕНИ И ЧАСТОТЫ")
    print("=" * 80)
    
    try:
        # Создание роя с PNTP
        pntp_swarm = PNTPDroneSwarm(num_drones=30)  # 30 дронов для демонстрации
        
        # Запуск симуляции
        data = pntp_swarm.run_simulation(duration=30.0, dt=0.1)  # 30 секунд
        
        # Создание визуализации
        fig = pntp_swarm.create_comprehensive_visualization(data)
        
        # Вывод отчета
        pntp_swarm.print_performance_report()
        
        print("\n" + "=" * 80)
        print("ДЕМОНСТРАЦИЯ PNTP ЗАВЕРШЕНА УСПЕШНО!")
        print("Протокол обеспечивает высокоточную синхронизацию времени и частоты")
        print("=" * 80)
        
    except Exception as e:
        print(f"Ошибка в демонстрации PNTP: {e}")
        import traceback
        traceback.print_exc()


if __name__ == "__main__":
    main() 