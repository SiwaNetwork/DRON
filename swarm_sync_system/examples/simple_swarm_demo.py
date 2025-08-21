#!/usr/bin/env python3
"""
Упрощенная демонстрация роевой системы синхронизации без scipy
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
from src.algorithms.formation import FormationController, FormationConfig, FormationType


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


def demo_basic_swarm():
    """Демонстрация базовой работы роя"""
    print("=" * 60)
    print("ДЕМОНСТРАЦИЯ РОЕВОЙ СИСТЕМЫ СИНХРОНИЗАЦИИ")
    print("=" * 60)
    
    # Создание роя
    swarm = Swarm()
    
    # Добавление дронов
    num_drones = 5
    for i in range(num_drones):
        # Случайные начальные позиции
        initial_pos = np.array([
            np.random.uniform(-10, 10),
            np.random.uniform(-10, 10),
            np.random.uniform(-20, -10)  # Высота от 10 до 20 м
        ])
        
        drone = Drone(
            drone_id=f"drone_{i}",
            initial_position=initial_pos,
            communication_range=50.0
        )
        swarm.add_drone(drone)
    
    print(f"Создан рой из {num_drones} дронов")
    print(f"Лидер роя: {swarm.leader_id}")
    
    # Установка формации
    print("\n1. ФОРМИРОВАНИЕ СТРОЯ")
    print("-" * 40)
    swarm.set_formation('v', spacing=10.0)
    print("Установлена V-образная формация")
    
    # Симуляция на 10 секунд
    dt = 0.1
    simulation_time = 10.0
    steps = int(simulation_time / dt)
    
    positions_history = {drone_id: [] for drone_id in swarm.drones}
    
    for step in range(steps):
        swarm.update(dt)
        
        # Сохранение позиций для визуализации
        for drone_id, drone in swarm.drones.items():
            positions_history[drone_id].append(drone.state.position.copy())
        
        # Вывод статуса каждую секунду
        if step % 10 == 0:
            t = step * dt
            print(f"Время: {t:.1f}с - Связность роя: {swarm.get_connectivity():.2f}")
    
    print(f"Формация достигнута. Радиус роя: {swarm.get_swarm_radius():.2f} м")
    
    return swarm, positions_history


def demo_consensus_sync():
    """Демонстрация алгоритмов консенсуса"""
    print("\n2. СИНХРОНИЗАЦИЯ ЧЕРЕЗ КОНСЕНСУС")
    print("-" * 40)
    
    # Создание простого роя
    swarm = Swarm()
    num_drones = 4
    
    for i in range(num_drones):
        drone = Drone(
            drone_id=f"drone_{i}",
            initial_position=np.array([i*5, 0, -10])
        )
        swarm.add_drone(drone)
    
    # Создание алгоритма консенсуса
    consensus_alg = AverageConsensus(weight=0.7)
    consensus = SwarmConsensusWrapper(swarm, consensus_alg)
    
    print(f"Начальные значения: {consensus.values}")
    
    # Симуляция консенсуса
    dt = 0.1
    simulation_time = 5.0
    steps = int(simulation_time / dt)
    
    values_history = {drone_id: [consensus.values[drone_id]] for drone_id in swarm.drones}
    
    for step in range(steps):
        # Обновление консенсуса
        consensus.update(dt)
        
        # Сохранение значений
        for drone_id in swarm.drones:
            values_history[drone_id].append(consensus.get_value(drone_id))
        
        # Вывод каждую секунду
        if step % 10 == 0:
            t = step * dt
            current_values = {drone_id: consensus.get_value(drone_id) for drone_id in swarm.drones}
            print(f"Время: {t:.1f}с - Значения: {current_values}")
    
    final_values = {drone_id: consensus.get_value(drone_id) for drone_id in swarm.drones}
    print(f"Финальные значения: {final_values}")
    
    return consensus, values_history


def demo_phase_synchronization():
    """Демонстрация фазовой синхронизации"""
    print("\n3. ФАЗОВАЯ СИНХРОНИЗАЦИЯ")
    print("-" * 40)
    
    # Создание роя
    swarm = Swarm()
    num_drones = 3
    
    for i in range(num_drones):
        drone = Drone(
            drone_id=f"drone_{i}",
            initial_position=np.array([i*8, 0, -15])
        )
        swarm.add_drone(drone)
    
    # Создание алгоритма фазовой синхронизации
    phase_sync = SwarmPhaseSyncWrapper(swarm, natural_frequency=1.0, coupling_strength=0.5)
    
    # Симуляция
    dt = 0.1
    simulation_time = 8.0
    steps = int(simulation_time / dt)
    
    phases_history = {drone_id: [] for drone_id in swarm.drones}
    
    for step in range(steps):
        # Обновление фазовой синхронизации
        phase_sync.update(dt)
        
        # Сохранение фаз
        for drone_id in swarm.drones:
            phases_history[drone_id].append(phase_sync.get_phase(drone_id))
        
        # Вывод каждые 2 секунды
        if step % 20 == 0:
            t = step * dt
            current_phases = {drone_id: phase_sync.get_phase(drone_id) for drone_id in swarm.drones}
            order_param = phase_sync.get_order_parameter()
            print(f"Время: {t:.1f}с - Фазы: {current_phases}")
            print(f"  Параметр порядка: {order_param[0]:.3f}")
    
    print("Фазовая синхронизация завершена")
    
    return phase_sync, phases_history


def visualize_3d_trajectories(positions_history, title="Траектории дронов"):
    """Визуализация 3D траекторий"""
    try:
        fig = plt.figure(figsize=(12, 8))
        ax = fig.add_subplot(111, projection='3d')
        
        colors = ['red', 'blue', 'green', 'orange', 'purple', 'brown', 'pink', 'gray']
        
        for i, (drone_id, positions) in enumerate(positions_history.items()):
            if positions:
                positions = np.array(positions)
                color = colors[i % len(colors)]
                
                # Траектория
                ax.plot(positions[:, 0], positions[:, 1], positions[:, 2], 
                       color=color, linewidth=2, label=f'Дрон {drone_id}')
                
                # Начальная точка
                ax.scatter(positions[0, 0], positions[0, 1], positions[0, 2], 
                          color=color, s=100, marker='o')
                
                # Конечная точка
                ax.scatter(positions[-1, 0], positions[-1, 1], positions[-1, 2], 
                          color=color, s=100, marker='s')
        
        ax.set_xlabel('X (м)')
        ax.set_ylabel('Y (м)')
        ax.set_zlabel('Z (м)')
        ax.set_title(title)
        ax.legend()
        ax.grid(True)
        
        plt.tight_layout()
        plt.show()
        
    except Exception as e:
        print(f"Ошибка визуализации: {e}")
        print("Продолжаем без графиков...")


def main():
    """Основная функция демонстрации"""
    print("ЗАПУСК МОДЕЛИРОВАНИЯ РОЕВОЙ СИСТЕМЫ")
    print("=" * 60)
    
    try:
        # 1. Базовая демонстрация роя
        swarm, positions = demo_basic_swarm()
        
        # 2. Демонстрация консенсуса
        consensus, values = demo_consensus_sync()
        
        # 3. Демонстрация фазовой синхронизации
        phase_sync, phases = demo_phase_synchronization()
        
        # 4. Визуализация результатов
        print("\n4. ВИЗУАЛИЗАЦИЯ РЕЗУЛЬТАТОВ")
        print("-" * 40)
        
        if positions:
            visualize_3d_trajectories(positions, "Траектории дронов в формации")
        
        # 5. Итоговая статистика
        print("\n5. ИТОГОВАЯ СТАТИСТИКА")
        print("-" * 40)
        
        status = swarm.get_status_summary()
        print(f"Радиус роя: {status['swarm_radius']:.2f} м")
        print(f"Связность сети: {status['connectivity']:.2f}")
        print(f"Количество дронов: {len(swarm.drones)}")
        print(f"Лидер роя: {swarm.leader_id}")
        
        print("\nМОДЕЛИРОВАНИЕ ЗАВЕРШЕНО УСПЕШНО!")
        
    except Exception as e:
        print(f"Ошибка в моделировании: {e}")
        import traceback
        traceback.print_exc()


if __name__ == "__main__":
    main() 