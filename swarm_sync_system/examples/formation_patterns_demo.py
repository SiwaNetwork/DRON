#!/usr/bin/env python3
"""
Демонстрация различных паттернов формаций для роя из 50 дронов
"""
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import time
from collections import defaultdict

from src.core import Drone, Swarm
from src.algorithms.consensus import AverageConsensus
from src.algorithms.synchronization import PhaseSync


class FormationPatternManager:
    """Менеджер различных паттернов формаций"""
    
    def __init__(self, num_drones=50):
        self.num_drones = num_drones
        
    def create_grid_formation(self, spacing=8.0):
        """Создание сетчатой формации"""
        positions = []
        grid_size = int(np.ceil(np.sqrt(self.num_drones)))
        
        for i in range(self.num_drones):
            row = i // grid_size
            col = i % grid_size
            
            pos = np.array([
                row * spacing,
                col * spacing,
                -15
            ])
            positions.append(pos)
        
        return positions
    
    def create_circle_formation(self, radius=25.0):
        """Создание круговой формации"""
        positions = []
        
        for i in range(self.num_drones):
            angle = 2 * np.pi * i / self.num_drones
            
            pos = np.array([
                radius * np.cos(angle),
                radius * np.sin(angle),
                -15
            ])
            positions.append(pos)
        
        return positions
    
    def create_sphere_formation(self, radius=20.0):
        """Создание сферической формации"""
        positions = []
        
        # Используем алгоритм равномерного распределения на сфере
        for i in range(self.num_drones):
            # Угол по вертикали
            theta = np.arccos(1 - 2 * (i + 0.5) / self.num_drones)
            # Угол по горизонтали (золотой угол)
            phi = np.pi * (1 + 5**0.5) * i
            
            pos = np.array([
                radius * np.sin(theta) * np.cos(phi),
                radius * np.sin(theta) * np.sin(phi),
                -15 + radius * np.cos(theta)
            ])
            positions.append(pos)
        
        return positions
    
    def create_v_formation(self, spacing=6.0, angle=30):
        """Создание V-образной формации"""
        positions = []
        angle_rad = np.radians(angle)
        
        # Лидер в центре
        positions.append(np.array([0, 0, -15]))
        
        # Остальные дроны в V-форме
        for i in range(1, self.num_drones):
            if i % 2 == 1:  # Правая сторона
                side = 1
                pos_in_line = (i + 1) // 2
            else:  # Левая сторона
                side = -1
                pos_in_line = i // 2
            
            x = -pos_in_line * spacing * np.cos(angle_rad)
            y = side * pos_in_line * spacing * np.sin(angle_rad)
            
            positions.append(np.array([x, y, -15]))
        
        return positions
    
    def create_line_formation(self, spacing=5.0, direction='x'):
        """Создание линейной формации"""
        positions = []
        
        for i in range(self.num_drones):
            if direction == 'x':
                pos = np.array([i * spacing, 0, -15])
            elif direction == 'y':
                pos = np.array([0, i * spacing, -15])
            else:  # diagonal
                pos = np.array([i * spacing * 0.707, i * spacing * 0.707, -15])
            
            positions.append(pos)
        
        return positions
    
    def create_diamond_formation(self, size=30.0):
        """Создание ромбовидной формации"""
        positions = []
        
        # Центральная точка
        center = np.array([0, 0, -15])
        
        # Распределение по ромбу
        for i in range(self.num_drones):
            angle = 2 * np.pi * i / self.num_drones
            
            # Создание ромбовидной формы
            r = size * (1 + 0.5 * np.cos(4 * angle))
            
            pos = np.array([
                r * np.cos(angle),
                r * np.sin(angle),
                -15
            ])
            positions.append(pos)
        
        return positions
    
    def create_spiral_formation(self, spacing=3.0, turns=3):
        """Создание спиральной формации"""
        positions = []
        
        for i in range(self.num_drones):
            angle = 2 * np.pi * turns * i / self.num_drones
            radius = spacing * i / 5
            
            pos = np.array([
                radius * np.cos(angle),
                radius * np.sin(angle),
                -15 - i * 0.5  # Постепенное изменение высоты
            ])
            positions.append(pos)
        
        return positions
    
    def create_layered_formation(self, layers=3, spacing=8.0):
        """Создание многослойной формации"""
        positions = []
        drones_per_layer = self.num_drones // layers
        
        for layer in range(layers):
            layer_drones = drones_per_layer
            if layer == layers - 1:  # Последний слой получает оставшиеся дроны
                layer_drones = self.num_drones - layer * drones_per_layer
            
            radius = 10 + layer * spacing
            height = -15 - layer * 5
            
            for i in range(layer_drones):
                angle = 2 * np.pi * i / layer_drones
                
                pos = np.array([
                    radius * np.cos(angle),
                    radius * np.sin(angle),
                    height
                ])
                positions.append(pos)
        
        return positions


def run_formation_comparison():
    """Запуск сравнения различных формаций"""
    print("СРАВНЕНИЕ РАЗЛИЧНЫХ ФОРМАЦИЙ РОЯ ИЗ 50 ДРОНОВ")
    print("=" * 80)
    
    pattern_manager = FormationPatternManager(50)
    
    # Определение всех формаций
    formations = {
        'grid': pattern_manager.create_grid_formation(),
        'circle': pattern_manager.create_circle_formation(),
        'sphere': pattern_manager.create_sphere_formation(),
        'v_formation': pattern_manager.create_v_formation(),
        'line': pattern_manager.create_line_formation(),
        'diamond': pattern_manager.create_diamond_formation(),
        'spiral': pattern_manager.create_spiral_formation(),
        'layered': pattern_manager.create_layered_formation()
    }
    
    # Анализ каждой формации
    formation_stats = {}
    
    for name, positions in formations.items():
        print(f"\nАнализ формации '{name}':")
        print("-" * 40)
        
        # Создание роя для анализа
        swarm = Swarm()
        
        for i, pos in enumerate(positions):
            drone = Drone(
                drone_id=f"drone_{i:02d}",
                initial_position=pos,
                communication_range=25.0
            )
            swarm.add_drone(drone)
        
        # Анализ метрик
        stats = analyze_formation(swarm, name)
        formation_stats[name] = stats
        
        print(f"  Связность: {stats['connectivity']:.3f}")
        print(f"  Радиус роя: {stats['swarm_radius']:.2f} м")
        print(f"  Компактность: {stats['compactness']:.3f}")
        print(f"  Среднее расстояние: {stats['avg_distance']:.2f} м")
    
    # Создание визуализации всех формаций
    create_formation_comparison_plot(formations, formation_stats)
    
    # Симуляция лучшей формации
    best_formation = max(formation_stats.keys(), 
                        key=lambda x: formation_stats[x]['overall_score'])
    
    print(f"\nЛучшая формация по общему счету: {best_formation}")
    print(f"Общий счет: {formation_stats[best_formation]['overall_score']:.3f}")
    
    # Запуск детальной симуляции лучшей формации
    run_detailed_formation_simulation(best_formation, formations[best_formation])


def analyze_formation(swarm, formation_name):
    """Анализ характеристик формации"""
    positions = np.array([drone.state.position for drone in swarm.drones.values()])
    
    # Связность
    connectivity = swarm.get_connectivity()
    
    # Радиус роя
    swarm_radius = swarm.get_swarm_radius()
    
    # Центр масс
    center = np.mean(positions, axis=0)
    
    # Компактность (обратная величина разброса)
    distances_from_center = [np.linalg.norm(pos - center) for pos in positions]
    compactness = 1.0 / (1.0 + np.std(distances_from_center))
    
    # Среднее расстояние между дронами
    total_distance = 0
    count = 0
    for i in range(len(positions)):
        for j in range(i+1, len(positions)):
            total_distance += np.linalg.norm(positions[i] - positions[j])
            count += 1
    
    avg_distance = total_distance / count if count > 0 else 0
    
    # Объемная эффективность (количество дронов / объем)
    max_distance = np.max(distances_from_center)
    volume = (4/3) * np.pi * max_distance**3
    volume_efficiency = len(positions) / volume if volume > 0 else 0
    
    # Общий счет (комбинация метрик)
    overall_score = (
        connectivity * 0.3 +
        compactness * 0.25 +
        (1.0 / (1.0 + swarm_radius / 50.0)) * 0.25 +  # Предпочтение компактных формаций
        volume_efficiency * 0.2
    )
    
    return {
        'connectivity': connectivity,
        'swarm_radius': swarm_radius,
        'compactness': compactness,
        'avg_distance': avg_distance,
        'volume_efficiency': volume_efficiency,
        'overall_score': overall_score
    }


def create_formation_comparison_plot(formations, stats):
    """Создание сравнительного графика формаций"""
    fig = plt.figure(figsize=(20, 16))
    
    # 3D визуализация формаций
    formation_names = list(formations.keys())
    rows = 2
    cols = 4
    
    for i, (name, positions) in enumerate(formations.items()):
        ax = fig.add_subplot(rows, cols, i+1, projection='3d')
        
        positions = np.array(positions)
        
        # Разные цвета для разных формаций
        colors = plt.cm.Set3(np.linspace(0, 1, len(positions)))
        
        ax.scatter(positions[:, 0], positions[:, 1], positions[:, 2], 
                  c=colors, s=30, alpha=0.8)
        
        # Центр формации
        center = np.mean(positions, axis=0)
        ax.scatter(center[0], center[1], center[2], 
                  c='red', s=100, marker='x', linewidth=3)
        
        ax.set_xlabel('X (м)')
        ax.set_ylabel('Y (м)')
        ax.set_zlabel('Z (м)')
        ax.set_title(f'{name.upper()}\nСвязность: {stats[name]["connectivity"]:.3f}')
        
        # Одинаковый масштаб для всех графиков
        max_range = 50
        ax.set_xlim([-max_range, max_range])
        ax.set_ylim([-max_range, max_range])
        ax.set_zlim([-35, 5])
    
    plt.tight_layout()
    plt.show()
    
    # Сравнительная таблица метрик
    create_metrics_comparison_plot(stats)


def create_metrics_comparison_plot(stats):
    """Создание графика сравнения метрик"""
    fig, axes = plt.subplots(2, 2, figsize=(15, 12))
    
    formation_names = list(stats.keys())
    
    # 1. Связность
    ax = axes[0, 0]
    connectivities = [stats[name]['connectivity'] for name in formation_names]
    bars = ax.bar(formation_names, connectivities, color='skyblue', alpha=0.7)
    ax.set_ylabel('Связность')
    ax.set_title('Связность различных формаций')
    ax.tick_params(axis='x', rotation=45)
    
    # Добавление значений на столбцы
    for bar, value in zip(bars, connectivities):
        ax.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.01, 
                f'{value:.3f}', ha='center', va='bottom')
    
    # 2. Радиус роя
    ax = axes[0, 1]
    radii = [stats[name]['swarm_radius'] for name in formation_names]
    bars = ax.bar(formation_names, radii, color='lightcoral', alpha=0.7)
    ax.set_ylabel('Радиус роя (м)')
    ax.set_title('Размер различных формаций')
    ax.tick_params(axis='x', rotation=45)
    
    for bar, value in zip(bars, radii):
        ax.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 1, 
                f'{value:.1f}', ha='center', va='bottom')
    
    # 3. Компактность
    ax = axes[1, 0]
    compactness = [stats[name]['compactness'] for name in formation_names]
    bars = ax.bar(formation_names, compactness, color='lightgreen', alpha=0.7)
    ax.set_ylabel('Компактность')
    ax.set_title('Компактность различных формаций')
    ax.tick_params(axis='x', rotation=45)
    
    for bar, value in zip(bars, compactness):
        ax.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.01, 
                f'{value:.3f}', ha='center', va='bottom')
    
    # 4. Общий счет
    ax = axes[1, 1]
    overall_scores = [stats[name]['overall_score'] for name in formation_names]
    bars = ax.bar(formation_names, overall_scores, color='gold', alpha=0.7)
    ax.set_ylabel('Общий счет')
    ax.set_title('Общая эффективность формаций')
    ax.tick_params(axis='x', rotation=45)
    
    for bar, value in zip(bars, overall_scores):
        ax.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.01, 
                f'{value:.3f}', ha='center', va='bottom')
    
    # Выделение лучшей формации
    best_idx = overall_scores.index(max(overall_scores))
    bars[best_idx].set_color('red')
    bars[best_idx].set_alpha(0.9)
    
    plt.tight_layout()
    plt.show()


def run_detailed_formation_simulation(formation_name, positions):
    """Запуск детальной симуляции выбранной формации"""
    print(f"\nДЕТАЛЬНАЯ СИМУЛЯЦИЯ ФОРМАЦИИ '{formation_name.upper()}'")
    print("=" * 80)
    
    # Создание роя
    swarm = Swarm()
    
    for i, pos in enumerate(positions):
        # Добавление небольшого шума для реализма
        noise = np.random.normal(0, 0.2, 3)
        noisy_pos = pos + noise
        
        drone = Drone(
            drone_id=f"drone_{i:02d}",
            initial_position=noisy_pos,
            communication_range=25.0,
            max_velocity=12.0,
            max_acceleration=6.0
        )
        swarm.add_drone(drone)
    
    # Алгоритмы синхронизации
    consensus = AverageConsensus(weight=0.7)
    phase_sync = PhaseSync(natural_frequency=1.5, coupling_strength=0.8)
    
    # Инициализация
    consensus_values = {drone_id: np.random.uniform(0, 100) for drone_id in swarm.drones}
    for drone_id in swarm.drones:
        phase_sync.initialize_oscillator(drone_id)
    
    # Параметры симуляции
    dt = 0.1
    duration = 12.0
    steps = int(duration / dt)
    
    # История данных
    time_points = []
    connectivity_history = []
    consensus_history = []
    phase_history = []
    
    print("Запуск симуляции...")
    start_time = time.time()
    
    for step in range(steps):
        t = step * dt
        time_points.append(t)
        
        # Обновление роя
        swarm.update(dt)
        
        # Обновление консенсуса
        new_consensus_values = {}
        for drone_id, drone in swarm.drones.items():
            neighbor_values = {}
            current_pos = drone.state.position
            
            for other_id, other_drone in swarm.drones.items():
                if other_id != drone_id:
                    other_pos = other_drone.state.position
                    distance = np.linalg.norm(current_pos - other_pos)
                    
                    if distance <= drone.communication_range:
                        neighbor_values[other_id] = consensus_values[other_id]
            
            current_value = consensus_values[drone_id]
            new_value = consensus.update(drone_id, current_value, neighbor_values)
            new_consensus_values[drone_id] = new_value
        
        consensus_values.update(new_consensus_values)
        
        # Обновление фазовой синхронизации
        for drone_id, drone in swarm.drones.items():
            neighbor_phases = {}
            current_pos = drone.state.position
            
            for other_id, other_drone in swarm.drones.items():
                if other_id != drone_id:
                    other_pos = other_drone.state.position
                    distance = np.linalg.norm(current_pos - other_pos)
                    
                    if distance <= drone.communication_range:
                        neighbor_phases[other_id] = phase_sync.phases[other_id]
            
            phase_sync.kuramoto_update(drone_id, neighbor_phases, dt)
        
        # Сохранение данных
        connectivity_history.append(swarm.get_connectivity())
        consensus_history.append(np.std(list(consensus_values.values())))
        
        order_param, _ = phase_sync.get_order_parameter()
        phase_history.append(order_param)
        
        # Прогресс
        if step % (steps // 10) == 0:
            progress = step / steps * 100
            print(f"  Прогресс: {progress:5.1f}% | "
                  f"Связность: {swarm.get_connectivity():.3f} | "
                  f"Консенсус: {np.std(list(consensus_values.values())):.4f} | "
                  f"Фазы: {order_param:.3f}")
    
    simulation_time = time.time() - start_time
    print(f"\nСимуляция завершена за {simulation_time:.2f} секунд")
    
    # Финальные результаты
    print(f"\nФИНАЛЬНЫЕ РЕЗУЛЬТАТЫ ФОРМАЦИИ '{formation_name.upper()}':")
    print("-" * 60)
    print(f"Финальная связность: {connectivity_history[-1]:.6f}")
    print(f"Сходимость консенсуса: {consensus_history[-1]:.6f}")
    print(f"Фазовая синхронизация: {phase_history[-1]:.6f}")
    print(f"Радиус роя: {swarm.get_swarm_radius():.2f} м")
    
    # Создание графика результатов
    create_formation_results_plot(time_points, connectivity_history, 
                                 consensus_history, phase_history, formation_name)


def create_formation_results_plot(time_points, connectivity, consensus, phases, formation_name):
    """Создание графика результатов симуляции формации"""
    fig, axes = plt.subplots(2, 2, figsize=(15, 10))
    fig.suptitle(f'Результаты симуляции формации "{formation_name.upper()}"', fontsize=16)
    
    # 1. Связность
    ax = axes[0, 0]
    ax.plot(time_points, connectivity, 'b-', linewidth=2)
    ax.set_xlabel('Время (с)')
    ax.set_ylabel('Связность')
    ax.set_title('Динамика связности')
    ax.grid(True, alpha=0.3)
    ax.set_ylim(0, 1)
    
    # 2. Консенсус
    ax = axes[0, 1]
    ax.semilogy(time_points, consensus, 'r-', linewidth=2)
    ax.set_xlabel('Время (с)')
    ax.set_ylabel('Стд. отклонение консенсуса')
    ax.set_title('Сходимость консенсуса')
    ax.grid(True, alpha=0.3)
    
    # 3. Фазовая синхронизация
    ax = axes[1, 0]
    ax.plot(time_points, phases, 'm-', linewidth=2)
    ax.set_xlabel('Время (с)')
    ax.set_ylabel('Параметр порядка')
    ax.set_title('Фазовая синхронизация')
    ax.grid(True, alpha=0.3)
    ax.set_ylim(0, 1)
    
    # 4. Сводная статистика
    ax = axes[1, 1]
    ax.axis('off')
    
    # Расчет средних значений
    avg_connectivity = np.mean(connectivity)
    final_consensus = consensus[-1]
    final_phases = phases[-1]
    
    stats_text = f"""
    СТАТИСТИКА ФОРМАЦИИ "{formation_name.upper()}"
    
    Средняя связность: {avg_connectivity:.4f}
    Финальный консенсус: {final_consensus:.6f}
    Финальная синхронизация: {final_phases:.4f}
    
    Время симуляции: {time_points[-1]:.1f} секунд
    Количество дронов: 50
    
    Оценка эффективности:
    {"ОТЛИЧНО" if avg_connectivity > 0.8 and final_phases > 0.9 else "ХОРОШО" if avg_connectivity > 0.6 and final_phases > 0.8 else "УДОВЛЕТВОРИТЕЛЬНО"}
    """
    
    ax.text(0.1, 0.9, stats_text, transform=ax.transAxes, fontsize=12,
           verticalalignment='top', fontfamily='monospace',
           bbox=dict(boxstyle="round,pad=0.3", facecolor="lightgray", alpha=0.8))
    
    plt.tight_layout()
    plt.show()


if __name__ == "__main__":
    run_formation_comparison()