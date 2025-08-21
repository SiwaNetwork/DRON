#!/usr/bin/env python3
"""
Продвинутая демонстрация роевой системы синхронизации с графиками
"""
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import time

from src.core import Drone, Swarm
from src.algorithms.consensus import AverageConsensus
from src.algorithms.synchronization import PhaseSync


class SwarmConsensusWrapper:
    """Обертка для работы алгоритма консенсуса с роем"""
    
    def __init__(self, swarm: Swarm, consensus_algorithm: AverageConsensus):
        self.swarm = swarm
        self.algorithm = consensus_algorithm
        self.values = {}
        
        # Инициализация случайных значений для каждого дрона
        for drone_id in swarm.drones:
            self.values[drone_id] = np.random.uniform(0, 100)
    
    def update(self, dt: float):
        """Обновление консенсуса"""
        new_values = {}
        
        for drone_id, drone in self.swarm.drones.items():
            # Получение соседей в радиусе связи
            neighbor_values = {}
            current_pos = drone.state.position
            
            for other_id, other_drone in self.swarm.drones.items():
                if other_id != drone_id:
                    other_pos = other_drone.state.position
                    distance = np.linalg.norm(current_pos - other_pos)
                    
                    if distance <= drone.communication_range:
                        neighbor_values[other_id] = self.values[other_id]
            
            # Обновление значения через алгоритм консенсуса
            current_value = self.values[drone_id]
            new_value = self.algorithm.update(drone_id, current_value, neighbor_values)
            new_values[drone_id] = new_value
        
        # Применение новых значений
        self.values.update(new_values)
    
    def get_value(self, drone_id: str) -> float:
        """Получение значения дрона"""
        return self.values.get(drone_id, 0.0)


class SwarmPhaseSyncWrapper:
    """Обертка для работы фазовой синхронизации с роем"""
    
    def __init__(self, swarm: Swarm, natural_frequency: float = 1.0, coupling_strength: float = 0.5):
        self.swarm = swarm
        self.phase_sync = PhaseSync(natural_frequency=natural_frequency, coupling_strength=coupling_strength)
        
        # Инициализация осцилляторов для каждого дрона
        for drone_id in swarm.drones:
            self.phase_sync.initialize_oscillator(drone_id)
    
    def update(self, dt: float):
        """Обновление фазовой синхронизации"""
        for drone_id, drone in self.swarm.drones.items():
            # Получение соседей в радиусе связи
            neighbor_phases = {}
            current_pos = drone.state.position
            
            for other_id, other_drone in self.swarm.drones.items():
                if other_id != drone_id:
                    other_pos = other_drone.state.position
                    distance = np.linalg.norm(current_pos - other_pos)
                    
                    if distance <= drone.communication_range:
                        neighbor_phases[other_id] = self.phase_sync.phases[other_id]
            
            # Обновление фазы через алгоритм Курамото
            self.phase_sync.kuramoto_update(drone_id, neighbor_phases, dt)
    
    def get_phase(self, drone_id: str) -> float:
        """Получение фазы дрона"""
        return self.phase_sync.phases.get(drone_id, 0.0)
    
    def get_order_parameter(self):
        """Получение параметра порядка"""
        return self.phase_sync.get_order_parameter()


def run_comprehensive_simulation():
    """Комплексное моделирование роевой системы"""
    print("=" * 80)
    print("КОМПЛЕКСНОЕ МОДЕЛИРОВАНИЕ РОЕВОЙ СИСТЕМЫ СИНХРОНИЗАЦИИ")
    print("=" * 80)
    
    # Создание роя
    swarm = Swarm()
    num_drones = 6
    
    # Создание дронов в разных позициях
    initial_positions = [
        np.array([0, 0, -15]),      # Центр
        np.array([10, 5, -12]),     # Справа впереди
        np.array([-8, 3, -18]),     # Слева
        np.array([5, -10, -14]),    # Сзади справа
        np.array([-5, -8, -16]),    # Сзади слева
        np.array([0, 15, -10])      # Впереди
    ]
    
    for i in range(num_drones):
        drone = Drone(
            drone_id=f"drone_{i}",
            initial_position=initial_positions[i],
            communication_range=30.0
        )
        swarm.add_drone(drone)
    
    print(f"Создан рой из {num_drones} дронов")
    print(f"Лидер роя: {swarm.leader_id}")
    
    # Параметры симуляции
    dt = 0.1
    simulation_time = 15.0
    steps = int(simulation_time / dt)
    
    # История данных
    time_points = []
    positions_history = {drone_id: [] for drone_id in swarm.drones}
    connectivity_history = []
    swarm_radius_history = []
    consensus_values_history = {drone_id: [] for drone_id in swarm.drones}
    phase_history = {drone_id: [] for drone_id in swarm.drones}
    order_parameter_history = []
    
    # Создание алгоритмов
    consensus = SwarmConsensusWrapper(swarm, AverageConsensus(weight=0.6))
    phase_sync = SwarmPhaseSyncWrapper(swarm, natural_frequency=1.2, coupling_strength=0.8)
    
    print(f"\nНачальные значения консенсуса: {consensus.values}")
    
    # Основной цикл симуляции
    for step in range(steps):
        t = step * dt
        time_points.append(t)
        
        # Обновление роя
        swarm.update(dt)
        
        # Обновление алгоритмов
        consensus.update(dt)
        phase_sync.update(dt)
        
        # Сохранение данных
        for drone_id, drone in swarm.drones.items():
            positions_history[drone_id].append(drone.state.position.copy())
            consensus_values_history[drone_id].append(consensus.get_value(drone_id))
            phase_history[drone_id].append(phase_sync.get_phase(drone_id))
        
        connectivity_history.append(swarm.get_connectivity())
        swarm_radius_history.append(swarm.get_swarm_radius())
        order_parameter_history.append(phase_sync.get_order_parameter()[0])
        
        # Вывод прогресса
        if step % 50 == 0:
            print(f"Время: {t:.1f}с - Связность: {swarm.get_connectivity():.2f} - "
                  f"Радиус: {swarm.get_swarm_radius():.1f}м - "
                  f"Порядок: {phase_sync.get_order_parameter()[0]:.3f}")
    
    print(f"\nСимуляция завершена!")
    print(f"Финальная связность: {swarm.get_connectivity():.3f}")
    print(f"Финальный радиус роя: {swarm.get_swarm_radius():.2f} м")
    print(f"Финальный параметр порядка: {phase_sync.get_order_parameter()[0]:.3f}")
    
    return {
        'time_points': time_points,
        'positions_history': positions_history,
        'connectivity_history': connectivity_history,
        'swarm_radius_history': swarm_radius_history,
        'consensus_values_history': consensus_values_history,
        'phase_history': phase_history,
        'order_parameter_history': order_parameter_history,
        'swarm': swarm
    }


def create_comprehensive_visualization(data):
    """Создание комплексной визуализации результатов"""
    print("\nСоздание графиков...")
    
    # Настройка стиля
    plt.style.use('default')
    fig = plt.figure(figsize=(20, 16))
    
    # 1. 3D траектории дронов
    ax1 = fig.add_subplot(3, 3, 1, projection='3d')
    colors = ['red', 'blue', 'green', 'orange', 'purple', 'brown']
    
    for i, (drone_id, positions) in enumerate(data['positions_history'].items()):
        if positions:
            positions = np.array(positions)
            color = colors[i % len(colors)]
            
            # Траектория
            ax1.plot(positions[:, 0], positions[:, 1], positions[:, 2], 
                    color=color, linewidth=2, label=f'Дрон {drone_id}')
            
            # Начальная и конечная точки
            ax1.scatter(positions[0, 0], positions[0, 1], positions[0, 2], 
                       color=color, s=100, marker='o')
            ax1.scatter(positions[-1, 0], positions[-1, 1], positions[-1, 2], 
                       color=color, s=100, marker='s')
    
    ax1.set_xlabel('X (м)')
    ax1.set_ylabel('Y (м)')
    ax1.set_zlabel('Z (м)')
    ax1.set_title('3D Траектории дронов')
    ax1.legend()
    ax1.grid(True)
    
    # 2. Связность сети
    ax2 = fig.add_subplot(3, 3, 2)
    ax2.plot(data['time_points'], data['connectivity_history'], 'b-', linewidth=2)
    ax2.set_xlabel('Время (с)')
    ax2.set_ylabel('Связность')
    ax2.set_title('Динамика связности сети')
    ax2.grid(True)
    ax2.set_ylim(0, 1.1)
    
    # 3. Радиус роя
    ax3 = fig.add_subplot(3, 3, 3)
    ax3.plot(data['time_points'], data['swarm_radius_history'], 'g-', linewidth=2)
    ax3.set_xlabel('Время (с)')
    ax3.set_ylabel('Радиус роя (м)')
    ax3.set_title('Динамика радиуса роя')
    ax3.grid(True)
    
    # 4. Консенсус - значения
    ax4 = fig.add_subplot(3, 3, 4)
    for drone_id, values in data['consensus_values_history'].items():
        color = colors[int(drone_id.split('_')[1]) % len(colors)]
        ax4.plot(data['time_points'], values, color=color, linewidth=2, label=f'Дрон {drone_id}')
    
    ax4.set_xlabel('Время (с)')
    ax4.set_ylabel('Значение консенсуса')
    ax4.set_title('Динамика консенсуса')
    ax4.legend()
    ax4.grid(True)
    
    # 5. Фазы осцилляторов
    ax5 = fig.add_subplot(3, 3, 5)
    for drone_id, phases in data['phase_history'].items():
        color = colors[int(drone_id.split('_')[1]) % len(colors)]
        ax5.plot(data['time_points'], phases, color=color, linewidth=2, label=f'Дрон {drone_id}')
    
    ax5.set_xlabel('Время (с)')
    ax5.set_ylabel('Фаза (рад)')
    ax5.set_title('Динамика фаз осцилляторов')
    ax5.legend()
    ax5.grid(True)
    
    # 6. Параметр порядка
    ax6 = fig.add_subplot(3, 3, 6)
    ax6.plot(data['time_points'], data['order_parameter_history'], 'r-', linewidth=2)
    ax6.set_xlabel('Время (с)')
    ax6.set_ylabel('Параметр порядка')
    ax6.set_title('Синхронизация фаз (Курамото)')
    ax6.grid(True)
    ax6.set_ylim(0, 1.1)
    
    # 7. Фазы на единичной окружности (конец симуляции)
    ax7 = fig.add_subplot(3, 3, 7, projection='polar')
    final_phases = [data['phase_history'][drone_id][-1] for drone_id in data['phase_history']]
    final_phases = np.array(final_phases)
    
    # Построение точек на окружности
    ax7.scatter(final_phases, [1]*len(final_phases), c=colors[:len(final_phases)], s=100)
    ax7.set_title('Финальное распределение фаз')
    ax7.grid(True)
    
    # 8. Статистика консенсуса
    ax8 = fig.add_subplot(3, 3, 8)
    consensus_std = []
    for i in range(len(data['time_points'])):
        values_at_time = [data['consensus_values_history'][drone_id][i] 
                         for drone_id in data['consensus_values_history']]
        consensus_std.append(np.std(values_at_time))
    
    ax8.plot(data['time_points'], consensus_std, 'm-', linewidth=2)
    ax8.set_xlabel('Время (с)')
    ax8.set_ylabel('Стандартное отклонение')
    ax8.set_title('Сходимость консенсуса')
    ax8.grid(True)
    
    # 9. Сводная статистика
    ax9 = fig.add_subplot(3, 3, 9)
    ax9.axis('off')
    
    # Текстовая статистика
    stats_text = f"""
    СТАТИСТИКА СИМУЛЯЦИИ
    
    Количество дронов: {len(data['swarm'].drones)}
    Время симуляции: {data['time_points'][-1]:.1f} с
    
    Финальные показатели:
    • Связность: {data['connectivity_history'][-1]:.3f}
    • Радиус роя: {data['swarm_radius_history'][-1]:.2f} м
    • Параметр порядка: {data['order_parameter_history'][-1]:.3f}
    • Стандартное отклонение консенсуса: {consensus_std[-1]:.3f}
    
    Лидер роя: {data['swarm'].leader_id}
    """
    
    ax9.text(0.1, 0.9, stats_text, transform=ax9.transAxes, fontsize=12,
             verticalalignment='top', fontfamily='monospace',
             bbox=dict(boxstyle="round,pad=0.3", facecolor="lightgray"))
    
    plt.tight_layout()
    plt.show()
    
    print("Графики созданы успешно!")


def main():
    """Основная функция"""
    print("ЗАПУСК ПРОДВИНУТОГО МОДЕЛИРОВАНИЯ РОЕВОЙ СИСТЕМЫ")
    print("=" * 80)
    
    try:
        # Запуск комплексного моделирования
        data = run_comprehensive_simulation()
        
        # Создание визуализации
        create_comprehensive_visualization(data)
        
        print("\n" + "=" * 80)
        print("МОДЕЛИРОВАНИЕ ЗАВЕРШЕНО УСПЕШНО!")
        print("=" * 80)
        
    except Exception as e:
        print(f"Ошибка в моделировании: {e}")
        import traceback
        traceback.print_exc()


if __name__ == "__main__":
    main() 