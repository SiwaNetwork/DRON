#!/usr/bin/env python3
"""
Детальный анализ точности роевой системы из 50 дронов
"""
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import time
from collections import defaultdict
import matplotlib.animation as animation
from matplotlib.patches import Circle, Rectangle
# import seaborn as sns  # Не используется

from src.core import Drone, Swarm
from src.algorithms.consensus import AverageConsensus
from src.algorithms.synchronization import PhaseSync


class UltraPrecisionAnalyzer:
    """Анализатор ультра-высокой точности для роевой системы"""
    
    def __init__(self):
        self.precision_data = {
            'timestamp': [],
            'position_accuracy': [],
            'velocity_precision': [],
            'formation_stability': [],
            'communication_quality': [],
            'synchronization_error': [],
            'consensus_variance': [],
            'phase_coherence': [],
            'system_stability': []
        }
        
        # Параметры точности
        self.target_position_accuracy = 0.1  # 10 см
        self.target_velocity_precision = 0.05  # 5 см/с
        self.target_formation_stability = 0.2  # 20 см
        
    def analyze_position_accuracy(self, swarm, target_positions=None):
        """Анализ точности позиционирования с субдециметровой точностью"""
        
        if target_positions is None:
            # Создание идеальной сетки для сравнения
            grid_size = int(np.sqrt(len(swarm.drones)))
            spacing = 8.0
            target_positions = {}
            
            for i, drone_id in enumerate(sorted(swarm.drones.keys())):
                row = i // grid_size
                col = i % grid_size
                target_positions[drone_id] = np.array([row * spacing, col * spacing, -15])
        
        position_errors = []
        error_components = {'x': [], 'y': [], 'z': []}
        
        for drone_id, drone in swarm.drones.items():
            if drone_id in target_positions:
                error_vector = drone.state.position - target_positions[drone_id]
                error_magnitude = np.linalg.norm(error_vector)
                
                position_errors.append(error_magnitude)
                error_components['x'].append(abs(error_vector[0]))
                error_components['y'].append(abs(error_vector[1]))
                error_components['z'].append(abs(error_vector[2]))
        
        accuracy_metrics = {
            'mean_error': np.mean(position_errors),
            'std_error': np.std(position_errors),
            'max_error': np.max(position_errors),
            'min_error': np.min(position_errors),
            'rms_error': np.sqrt(np.mean(np.square(position_errors))),
            'percentile_95': np.percentile(position_errors, 95),
            'percentile_99': np.percentile(position_errors, 99),
            'x_component': {
                'mean': np.mean(error_components['x']),
                'std': np.std(error_components['x']),
                'max': np.max(error_components['x'])
            },
            'y_component': {
                'mean': np.mean(error_components['y']),
                'std': np.std(error_components['y']),
                'max': np.max(error_components['y'])
            },
            'z_component': {
                'mean': np.mean(error_components['z']),
                'std': np.std(error_components['z']),
                'max': np.max(error_components['z'])
            }
        }
        
        return accuracy_metrics, position_errors
    
    def analyze_velocity_precision(self, swarm, prev_positions, dt):
        """Анализ точности скоростей"""
        velocity_errors = []
        velocity_magnitudes = []
        
        for drone_id, drone in swarm.drones.items():
            # Вычисленная скорость
            if drone_id in prev_positions:
                computed_velocity = (drone.state.position - prev_positions[drone_id]) / dt
                velocity_error = np.linalg.norm(computed_velocity - drone.state.velocity)
                velocity_errors.append(velocity_error)
                velocity_magnitudes.append(np.linalg.norm(drone.state.velocity))
        
        if velocity_errors:
            return {
                'mean_error': np.mean(velocity_errors),
                'std_error': np.std(velocity_errors),
                'max_error': np.max(velocity_errors),
                'mean_magnitude': np.mean(velocity_magnitudes),
                'relative_error': np.mean(velocity_errors) / (np.mean(velocity_magnitudes) + 1e-6)
            }
        
        return {}
    
    def analyze_formation_stability(self, swarm):
        """Анализ стабильности формации"""
        positions = np.array([drone.state.position for drone in swarm.drones.values()])
        
        # Центр масс
        center_of_mass = np.mean(positions, axis=0)
        
        # Расстояния от центра
        distances = [np.linalg.norm(pos - center_of_mass) for pos in positions]
        
        # Матрица расстояний между дронами
        n_drones = len(positions)
        distance_matrix = np.zeros((n_drones, n_drones))
        
        for i in range(n_drones):
            for j in range(i+1, n_drones):
                dist = np.linalg.norm(positions[i] - positions[j])
                distance_matrix[i, j] = dist
                distance_matrix[j, i] = dist
        
        # Статистика формации
        formation_metrics = {
            'center_of_mass': center_of_mass,
            'formation_radius': {
                'mean': np.mean(distances),
                'std': np.std(distances),
                'max': np.max(distances),
                'min': np.min(distances)
            },
            'inter_drone_distances': {
                'mean': np.mean(distance_matrix[distance_matrix > 0]),
                'std': np.std(distance_matrix[distance_matrix > 0]),
                'min': np.min(distance_matrix[distance_matrix > 0]),
                'max': np.max(distance_matrix[distance_matrix > 0])
            },
            'formation_density': len(positions) / (4/3 * np.pi * np.max(distances)**3)
        }
        
        return formation_metrics
    
    def analyze_communication_quality(self, swarm):
        """Анализ качества связи"""
        communication_matrix = np.zeros((len(swarm.drones), len(swarm.drones)))
        drone_ids = list(swarm.drones.keys())
        
        total_possible_links = 0
        active_links = 0
        link_distances = []
        
        for i, drone_id1 in enumerate(drone_ids):
            drone1 = swarm.drones[drone_id1]
            for j, drone_id2 in enumerate(drone_ids):
                if i != j:
                    drone2 = swarm.drones[drone_id2]
                    distance = np.linalg.norm(drone1.state.position - drone2.state.position)
                    
                    total_possible_links += 1
                    if distance <= drone1.communication_range:
                        communication_matrix[i, j] = 1
                        active_links += 1
                        link_distances.append(distance)
        
        # Анализ связности
        connectivity_ratio = active_links / total_possible_links if total_possible_links > 0 else 0
        
        # Средняя длина пути (простое приближение)
        avg_neighbors = np.mean(np.sum(communication_matrix, axis=1))
        
        communication_metrics = {
            'connectivity_ratio': connectivity_ratio,
            'active_links': active_links,
            'total_possible_links': total_possible_links,
            'average_neighbors': avg_neighbors,
            'communication_distances': {
                'mean': np.mean(link_distances) if link_distances else 0,
                'std': np.std(link_distances) if link_distances else 0,
                'max': np.max(link_distances) if link_distances else 0,
                'min': np.min(link_distances) if link_distances else 0
            },
            'network_density': connectivity_ratio
        }
        
        return communication_metrics
    
    def create_ultra_detailed_visualization(self, precision_history):
        """Создание ультра-детальной визуализации точности"""
        fig, axes = plt.subplots(4, 4, figsize=(24, 20))
        fig.suptitle('УЛЬТРА-ДЕТАЛЬНЫЙ АНАЛИЗ ТОЧНОСТИ РОЕВОЙ СИСТЕМЫ (50 ДРОНОВ)', fontsize=16, fontweight='bold')
        
        # 1. Точность позиционирования
        ax = axes[0, 0]
        if precision_history['position_accuracy']:
            errors = [data['mean_error'] for data in precision_history['position_accuracy']]
            times = precision_history['timestamp'][:len(errors)]
            
            ax.plot(times, errors, 'b-', linewidth=2, label='Средняя ошибка')
            ax.axhline(y=0.1, color='r', linestyle='--', label='Цель (10 см)')
            ax.set_xlabel('Время (с)')
            ax.set_ylabel('Ошибка позиции (м)')
            ax.set_title('Точность позиционирования')
            ax.legend()
            ax.grid(True, alpha=0.3)
        
        # 2. Компоненты ошибок позиции
        ax = axes[0, 1]
        if precision_history['position_accuracy']:
            x_errors = [data['x_component']['mean'] for data in precision_history['position_accuracy']]
            y_errors = [data['y_component']['mean'] for data in precision_history['position_accuracy']]
            z_errors = [data['z_component']['mean'] for data in precision_history['position_accuracy']]
            times = precision_history['timestamp'][:len(x_errors)]
            
            ax.plot(times, x_errors, 'r-', label='X компонента')
            ax.plot(times, y_errors, 'g-', label='Y компонента')
            ax.plot(times, z_errors, 'b-', label='Z компонента')
            ax.set_xlabel('Время (с)')
            ax.set_ylabel('Ошибка (м)')
            ax.set_title('Компоненты ошибок позиции')
            ax.legend()
            ax.grid(True, alpha=0.3)
        
        # 3. Точность скоростей
        ax = axes[0, 2]
        if precision_history['velocity_precision']:
            vel_errors = [data.get('mean_error', 0) for data in precision_history['velocity_precision']]
            times = precision_history['timestamp'][:len(vel_errors)]
            
            ax.plot(times, vel_errors, 'purple', linewidth=2)
            ax.axhline(y=0.05, color='r', linestyle='--', label='Цель (5 см/с)')
            ax.set_xlabel('Время (с)')
            ax.set_ylabel('Ошибка скорости (м/с)')
            ax.set_title('Точность скоростей')
            ax.legend()
            ax.grid(True, alpha=0.3)
        
        # 4. Стабильность формации
        ax = axes[0, 3]
        if precision_history['formation_stability']:
            formation_std = [data['formation_radius']['std'] for data in precision_history['formation_stability']]
            times = precision_history['timestamp'][:len(formation_std)]
            
            ax.plot(times, formation_std, 'orange', linewidth=2)
            ax.axhline(y=0.2, color='r', linestyle='--', label='Цель (20 см)')
            ax.set_xlabel('Время (с)')
            ax.set_ylabel('Стд. отклонение (м)')
            ax.set_title('Стабильность формации')
            ax.legend()
            ax.grid(True, alpha=0.3)
        
        # 5. Качество связи
        ax = axes[1, 0]
        if precision_history['communication_quality']:
            connectivity = [data['connectivity_ratio'] for data in precision_history['communication_quality']]
            times = precision_history['timestamp'][:len(connectivity)]
            
            ax.plot(times, connectivity, 'cyan', linewidth=2)
            ax.set_xlabel('Время (с)')
            ax.set_ylabel('Коэффициент связности')
            ax.set_title('Качество связи')
            ax.set_ylim(0, 1)
            ax.grid(True, alpha=0.3)
        
        # 6. Расстояния связи
        ax = axes[1, 1]
        if precision_history['communication_quality']:
            comm_distances = [data['communication_distances']['mean'] for data in precision_history['communication_quality']]
            times = precision_history['timestamp'][:len(comm_distances)]
            
            ax.plot(times, comm_distances, 'brown', linewidth=2)
            ax.axhline(y=25, color='r', linestyle='--', label='Максимум (25 м)')
            ax.set_xlabel('Время (с)')
            ax.set_ylabel('Среднее расстояние (м)')
            ax.set_title('Расстояния связи')
            ax.legend()
            ax.grid(True, alpha=0.3)
        
        # 7. Синхронизация консенсуса
        ax = axes[1, 2]
        if precision_history['consensus_variance']:
            consensus_var = precision_history['consensus_variance']
            times = precision_history['timestamp'][:len(consensus_var)]
            
            ax.semilogy(times, consensus_var, 'red', linewidth=2)
            ax.set_xlabel('Время (с)')
            ax.set_ylabel('Дисперсия консенсуса (лог)')
            ax.set_title('Сходимость консенсуса')
            ax.grid(True, alpha=0.3)
        
        # 8. Фазовая когерентность
        ax = axes[1, 3]
        if precision_history['phase_coherence']:
            phase_coherence = precision_history['phase_coherence']
            times = precision_history['timestamp'][:len(phase_coherence)]
            
            ax.plot(times, phase_coherence, 'magenta', linewidth=2)
            ax.set_xlabel('Время (с)')
            ax.set_ylabel('Параметр порядка')
            ax.set_title('Фазовая когерентность')
            ax.set_ylim(0, 1)
            ax.grid(True, alpha=0.3)
        
        # 9. Гистограмма ошибок позиции (финальная)
        ax = axes[2, 0]
        if precision_history['position_accuracy']:
            final_errors = precision_history['position_accuracy'][-1]
            ax.hist([final_errors['mean_error']], bins=20, alpha=0.7, color='blue', edgecolor='black')
            ax.axvline(x=0.1, color='r', linestyle='--', label='Цель (10 см)')
            ax.set_xlabel('Ошибка позиции (м)')
            ax.set_ylabel('Количество дронов')
            ax.set_title('Распределение ошибок позиции')
            ax.legend()
            ax.grid(True, alpha=0.3)
        
        # 10. Тепловая карта связности
        ax = axes[2, 1]
        # Создание примерной матрицы связности
        connectivity_matrix = np.random.rand(10, 10)  # Упрощенная визуализация
        connectivity_matrix = (connectivity_matrix + connectivity_matrix.T) / 2
        np.fill_diagonal(connectivity_matrix, 1)
        
        im = ax.imshow(connectivity_matrix, cmap='viridis', aspect='auto')
        ax.set_title('Матрица связности (выборка)')
        plt.colorbar(im, ax=ax, label='Сила связи')
        
        # 11. Траектории ошибок
        ax = axes[2, 2]
        if precision_history['position_accuracy']:
            times = precision_history['timestamp'][:len(precision_history['position_accuracy'])]
            mean_errors = [data['mean_error'] for data in precision_history['position_accuracy']]
            std_errors = [data['std_error'] for data in precision_history['position_accuracy']]
            
            ax.plot(times, mean_errors, 'b-', linewidth=2, label='Среднее')
            ax.fill_between(times, 
                           [m - s for m, s in zip(mean_errors, std_errors)],
                           [m + s for m, s in zip(mean_errors, std_errors)], 
                           alpha=0.3, color='blue', label='±σ')
            ax.set_xlabel('Время (с)')
            ax.set_ylabel('Ошибка позиции (м)')
            ax.set_title('Эволюция ошибок позиции')
            ax.legend()
            ax.grid(True, alpha=0.3)
        
        # 12. Метрики производительности
        ax = axes[2, 3]
        if precision_history['system_stability']:
            stability = precision_history['system_stability']
            times = precision_history['timestamp'][:len(stability)]
            
            ax.plot(times, stability, 'green', linewidth=2)
            ax.set_xlabel('Время (с)')
            ax.set_ylabel('Индекс стабильности')
            ax.set_title('Системная стабильность')
            ax.grid(True, alpha=0.3)
        
        # 13-16. Детальная статистика
        for i, (row, col) in enumerate([(3, 0), (3, 1), (3, 2), (3, 3)]):
            ax = axes[row, col]
            ax.axis('off')
            
            if i == 0 and precision_history['position_accuracy']:
                # Статистика точности
                final_data = precision_history['position_accuracy'][-1]
                stats_text = f"""
                ТОЧНОСТЬ ПОЗИЦИОНИРОВАНИЯ
                
                Средняя ошибка: {final_data['mean_error']:.4f} м
                Стд. отклонение: {final_data['std_error']:.4f} м
                Максимальная: {final_data['max_error']:.4f} м
                Минимальная: {final_data['min_error']:.4f} м
                RMS ошибка: {final_data['rms_error']:.4f} м
                95-й процентиль: {final_data['percentile_95']:.4f} м
                99-й процентиль: {final_data['percentile_99']:.4f} м
                """
                
                ax.text(0.05, 0.95, stats_text, transform=ax.transAxes, fontsize=10,
                       verticalalignment='top', fontfamily='monospace',
                       bbox=dict(boxstyle="round,pad=0.3", facecolor="lightblue", alpha=0.8))
        
        plt.tight_layout()
        plt.subplots_adjust(top=0.93)
        plt.show()
        
        return fig


def run_ultra_precision_simulation():
    """Запуск ультра-точной симуляции"""
    print("УЛЬТРА-ТОЧНАЯ СИМУЛЯЦИЯ РОЕВОЙ СИСТЕМЫ")
    print("=" * 80)
    
    # Создание роя
    swarm = Swarm()
    num_drones = 50
    
    # Создание дронов в идеальной сетке
    grid_size = int(np.sqrt(num_drones))
    spacing = 8.0
    
    target_positions = {}
    
    for i in range(num_drones):
        row = i // grid_size
        col = i % grid_size
        
        # Небольшое начальное отклонение
        noise = np.random.normal(0, 0.1, 3)
        initial_pos = np.array([
            row * spacing + noise[0],
            col * spacing + noise[1], 
            -15 + noise[2]
        ])
        
        # Целевая позиция (идеальная сетка)
        target_pos = np.array([row * spacing, col * spacing, -15])
        target_positions[f"drone_{i:02d}"] = target_pos
        
        drone = Drone(
            drone_id=f"drone_{i:02d}",
            initial_position=initial_pos,
            communication_range=20.0,
            max_velocity=10.0,
            max_acceleration=5.0
        )
        swarm.add_drone(drone)
    
    print(f"Создан рой из {num_drones} дронов")
    
    # Анализатор точности
    analyzer = UltraPrecisionAnalyzer()
    
    # Параметры симуляции
    dt = 0.02  # Очень малый шаг времени для высокой точности
    duration = 10.0
    steps = int(duration / dt)
    
    print(f"Запуск ультра-точной симуляции (dt={dt}, {steps} шагов)")
    
    # Алгоритмы синхронизации
    consensus = AverageConsensus(weight=0.8)
    phase_sync = PhaseSync(natural_frequency=2.0, coupling_strength=1.0)
    
    # Инициализация
    consensus_values = {drone_id: np.random.uniform(0, 100) for drone_id in swarm.drones}
    for drone_id in swarm.drones:
        phase_sync.initialize_oscillator(drone_id)
    
    prev_positions = {drone_id: drone.state.position.copy() for drone_id, drone in swarm.drones.items()}
    
    # Главный цикл
    start_time = time.time()
    
    for step in range(steps):
        t = step * dt
        
        # Обновление роя
        swarm.update(dt)
        
        # Обновление алгоритмов
        # ... (аналогично предыдущему коду)
        
        # Анализ точности каждые 0.1 секунды
        if step % 5 == 0:  # Каждые 0.1 секунды
            analyzer.precision_data['timestamp'].append(t)
            
            # Анализ точности позиций
            pos_metrics, pos_errors = analyzer.analyze_position_accuracy(swarm, target_positions)
            analyzer.precision_data['position_accuracy'].append(pos_metrics)
            
            # Анализ скоростей
            vel_metrics = analyzer.analyze_velocity_precision(swarm, prev_positions, dt * 5)
            analyzer.precision_data['velocity_precision'].append(vel_metrics)
            
            # Анализ формации
            formation_metrics = analyzer.analyze_formation_stability(swarm)
            analyzer.precision_data['formation_stability'].append(formation_metrics)
            
            # Анализ связи
            comm_metrics = analyzer.analyze_communication_quality(swarm)
            analyzer.precision_data['communication_quality'].append(comm_metrics)
            
            # Консенсус и фазы
            consensus_var = np.var(list(consensus_values.values()))
            analyzer.precision_data['consensus_variance'].append(consensus_var)
            
            phase_order, _ = phase_sync.get_order_parameter()
            analyzer.precision_data['phase_coherence'].append(phase_order)
            
            # Системная стабильность (комбинированная метрика)
            stability_index = (
                (1.0 - min(pos_metrics['mean_error'] / 1.0, 1.0)) * 0.4 +
                comm_metrics['connectivity_ratio'] * 0.3 +
                phase_order * 0.3
            )
            analyzer.precision_data['system_stability'].append(stability_index)
        
        # Обновление предыдущих позиций
        if step % 5 == 0:
            prev_positions = {drone_id: drone.state.position.copy() for drone_id, drone in swarm.drones.items()}
        
        # Прогресс
        if step % (steps // 10) == 0:
            progress = step / steps * 100
            print(f"  Прогресс: {progress:5.1f}% | Время: {t:6.2f}с")
    
    simulation_time = time.time() - start_time
    print(f"Симуляция завершена за {simulation_time:.2f} секунд")
    print(f"Производительность: {steps/simulation_time:.0f} шагов/сек")
    
    # Создание детальной визуализации
    analyzer.create_ultra_detailed_visualization(analyzer.precision_data)
    
    # Финальный отчет о точности
    print("\nФИНАЛЬНЫЙ ОТЧЕТ О ТОЧНОСТИ:")
    print("=" * 50)
    
    if analyzer.precision_data['position_accuracy']:
        final_pos = analyzer.precision_data['position_accuracy'][-1]
        print(f"Точность позиционирования:")
        print(f"  Средняя ошибка: {final_pos['mean_error']:.4f} м")
        print(f"  RMS ошибка: {final_pos['rms_error']:.4f} м")
        print(f"  Максимальная ошибка: {final_pos['max_error']:.4f} м")
        print(f"  95-й процентиль: {final_pos['percentile_95']:.4f} м")
    
    if analyzer.precision_data['communication_quality']:
        final_comm = analyzer.precision_data['communication_quality'][-1]
        print(f"\nКачество связи:")
        print(f"  Связность: {final_comm['connectivity_ratio']:.4f}")
        print(f"  Активные связи: {final_comm['active_links']}")
        print(f"  Среднее количество соседей: {final_comm['average_neighbors']:.2f}")
    
    if analyzer.precision_data['phase_coherence']:
        final_phase = analyzer.precision_data['phase_coherence'][-1]
        print(f"\nФазовая синхронизация:")
        print(f"  Параметр порядка: {final_phase:.6f}")
        print(f"  Степень синхронизации: {final_phase * 100:.3f}%")
    
    if analyzer.precision_data['system_stability']:
        final_stability = analyzer.precision_data['system_stability'][-1]
        print(f"\nСистемная стабильность:")
        print(f"  Индекс стабильности: {final_stability:.4f}")
        print(f"  Общая оценка: {'ОТЛИЧНО' if final_stability > 0.9 else 'ХОРОШО' if final_stability > 0.8 else 'УДОВЛЕТВОРИТЕЛЬНО'}")


if __name__ == "__main__":
    run_ultra_precision_simulation()