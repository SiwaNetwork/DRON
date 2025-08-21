#!/usr/bin/env python3
"""
Базовый пример использования роевой системы синхронизации
"""
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import time

from src.core import Drone, Swarm, PhysicsModel
from src.core.physics import WindModel
from src.algorithms.consensus import AverageConsensus, LeaderFollowerConsensus
from src.algorithms.synchronization import TimeSynchronization, PhaseSync
from src.algorithms.formation import FormationController, FormationConfig, FormationType
from src.algorithms.collision import PotentialFieldAvoidance, Obstacle


def demo_basic_swarm():
    """Демонстрация базовой работы роя"""
    print("=" * 60)
    print("ДЕМОНСТРАЦИЯ РОЕВОЙ СИСТЕМЫ СИНХРОНИЗАЦИИ")
    print("=" * 60)
    
    # Создание физической модели с ветром
    wind_model = WindModel(
        base_velocity=np.array([2.0, 1.0, 0.0]),
        turbulence_intensity=0.1,
        gust_probability=0.01,
        gust_strength=3.0
    )
    physics = PhysicsModel(enable_wind=True, wind_model=wind_model)
    
    # Создание роя
    swarm = Swarm(physics_model=physics)
    
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
    
    # Инициализация дронов с разными начальными значениями
    initial_values = {}
    for i in range(num_drones):
        drone = Drone(f"drone_{i}")
        swarm.add_drone(drone)
        # Случайное начальное значение (например, оценка позиции цели)
        initial_values[f"drone_{i}"] = np.random.randn(3) * 10
    
    print("Начальные значения агентов:")
    for drone_id, value in initial_values.items():
        print(f"  {drone_id}: [{value[0]:.2f}, {value[1]:.2f}, {value[2]:.2f}]")
    
    # Алгоритм усредняющего консенсуса
    consensus = AverageConsensus(weight=0.6)
    
    # Итерации консенсуса
    max_iterations = 50
    values = initial_values.copy()
    convergence_history = []
    
    for iteration in range(max_iterations):
        new_values = {}
        
        # Обновление значений каждого агента
        for drone_id in swarm.drones:
            # Получение значений соседей (все связаны)
            neighbor_values = {
                nid: values[nid] 
                for nid in swarm.drones 
                if nid != drone_id
            }
            
            new_values[drone_id] = consensus.update(
                drone_id, values[drone_id], neighbor_values
            )
        
        # Проверка сходимости
        if consensus.check_convergence(new_values, values):
            print(f"Консенсус достигнут за {iteration + 1} итераций")
            break
        
        values = new_values
        
        # Расчет дисперсии для отслеживания сходимости
        all_values = np.array(list(values.values()))
        variance = np.var(all_values, axis=0).mean()
        convergence_history.append(variance)
    
    print("\nФинальные значения (консенсус):")
    for drone_id, value in values.items():
        print(f"  {drone_id}: [{value[0]:.2f}, {value[1]:.2f}, {value[2]:.2f}]")
    
    consensus_value = np.mean(list(values.values()), axis=0)
    print(f"\nСреднее значение: [{consensus_value[0]:.2f}, "
          f"{consensus_value[1]:.2f}, {consensus_value[2]:.2f}]")
    
    return convergence_history


def demo_time_sync():
    """Демонстрация синхронизации времени"""
    print("\n3. СИНХРОНИЗАЦИЯ ВРЕМЕНИ")
    print("-" * 40)
    
    # Создание системы синхронизации
    time_sync = TimeSynchronization(max_drift_rate=1e-5, sync_period=1.0)
    
    # Инициализация агентов с разными смещениями часов
    agents = ['drone_0', 'drone_1', 'drone_2', 'drone_3']
    for i, agent_id in enumerate(agents):
        # Случайное начальное смещение ±1 секунда
        offset = np.random.uniform(-1.0, 1.0)
        time_sync.initialize_agent(agent_id, offset)
        print(f"{agent_id}: начальное смещение {offset:.3f} с")
    
    # Симуляция обмена сообщениями и синхронизации
    global_time = 0.0
    sync_iterations = 10
    
    print("\nПроцесс синхронизации:")
    for iteration in range(sync_iterations):
        global_time += 1.0
        
        # Обмен временными метками между соседями
        for i, agent1 in enumerate(agents):
            for agent2 in agents[i+1:]:
                # Симуляция обмена сообщениями
                t1_local = time_sync.get_local_time(agent1, global_time)
                t2_local = time_sync.get_local_time(agent2, global_time)
                
                # RTT = 0.01-0.05 с (случайная задержка)
                rtt = np.random.uniform(0.01, 0.05)
                
                # Оценка смещения
                offset = time_sync.estimate_offset(agent1, agent2, rtt, t2_local - t1_local)
                
                # Обновление через фильтр Калмана
                time_sync.kalman_update(agent1, -offset, measurement_variance=rtt/10)
        
        # Вывод текущих смещений
        if iteration % 3 == 0:
            print(f"\nИтерация {iteration}:")
            for agent_id in agents:
                offset = time_sync.clock_offsets[agent_id]
                quality = time_sync.get_sync_quality(agent_id)
                print(f"  {agent_id}: смещение {offset:.4f} с, качество {quality:.2f}")
    
    # Финальная синхронизация
    print("\nФинальная синхронизация:")
    max_offset = 0
    for agent_id in agents:
        offset = abs(time_sync.clock_offsets[agent_id])
        max_offset = max(max_offset, offset)
        print(f"  {agent_id}: смещение {time_sync.clock_offsets[agent_id]:.4f} с")
    
    print(f"\nМаксимальная ошибка синхронизации: {max_offset:.4f} с")
    
    return time_sync


def demo_phase_sync():
    """Демонстрация синхронизации фазы"""
    print("\n4. СИНХРОНИЗАЦИЯ ФАЗЫ (МОДЕЛЬ КУРАМОТО)")
    print("-" * 40)
    
    # Создание системы фазовой синхронизации
    phase_sync = PhaseSync(natural_frequency=1.0, coupling_strength=0.5)
    
    # Инициализация осцилляторов
    num_oscillators = 6
    for i in range(num_oscillators):
        phase_sync.initialize_oscillator(f"osc_{i}")
    
    print(f"Инициализировано {num_oscillators} осцилляторов")
    print("Начальные фазы (рад):")
    for osc_id, phase in phase_sync.phases.items():
        print(f"  {osc_id}: {phase:.2f}")
    
    # Симуляция синхронизации
    dt = 0.01
    max_time = 20.0
    steps = int(max_time / dt)
    
    sync_history = []
    
    for step in range(steps):
        # Обновление фаз (все связаны со всеми)
        for osc_id in list(phase_sync.phases.keys()):
            neighbor_phases = {
                nid: phase_sync.phases[nid]
                for nid in phase_sync.phases
                if nid != osc_id
            }
            phase_sync.kuramoto_update(osc_id, neighbor_phases, dt)
        
        # Расчет параметра порядка
        r, psi = phase_sync.get_order_parameter()
        sync_history.append(r)
        
        # Проверка синхронизации
        if phase_sync.is_synchronized(threshold=0.95):
            print(f"\nСинхронизация достигнута за {step * dt:.2f} с")
            break
        
        # Адаптивная настройка силы связи
        if step % 100 == 0:
            phase_sync.adaptive_coupling(r, target_sync=0.95)
    
    print("\nФинальные фазы (рад):")
    for osc_id, phase in phase_sync.phases.items():
        print(f"  {osc_id}: {phase:.2f}")
    
    coherence = phase_sync.get_phase_coherence()
    print(f"\nКогерентность фаз: {coherence:.3f}")
    
    return sync_history


def demo_collision_avoidance():
    """Демонстрация избегания столкновений"""
    print("\n5. ИЗБЕГАНИЕ СТОЛКНОВЕНИЙ")
    print("-" * 40)
    
    # Создание алгоритма избегания
    avoidance = PotentialFieldAvoidance(
        repulsive_gain=100.0,
        influence_distance=10.0,
        safety_radius=2.0
    )
    
    # Позиция и скорость агента
    agent_pos = np.array([0, 0, -15])
    agent_vel = np.array([5, 0, 0])  # Движение вправо
    
    # Создание препятствий
    obstacles = [
        Obstacle(
            position=np.array([10, 0, -15]),
            velocity=np.array([0, 0, 0]),
            radius=3.0,
            is_static=True
        ),
        Obstacle(
            position=np.array([20, 5, -15]),
            velocity=np.array([-2, 0, 0]),  # Движущееся препятствие
            radius=2.0,
            is_static=False
        )
    ]
    
    print("Сценарий:")
    print(f"  Агент: позиция {agent_pos}, скорость {agent_vel}")
    print("  Препятствия:")
    for i, obs in enumerate(obstacles):
        print(f"    {i+1}: позиция {obs.position}, "
              f"{'статичное' if obs.is_static else f'скорость {obs.velocity}'}")
    
    # Симуляция движения с избеганием
    dt = 0.1
    trajectory = [agent_pos.copy()]
    
    for step in range(50):
        # Вычисление силы избегания
        avoidance_force = avoidance.compute_avoidance(agent_pos, agent_vel, obstacles)
        
        # Притяжение к цели
        target = np.array([30, 0, -15])
        attractive_force = avoidance.compute_attractive_force(
            agent_pos, target, attractive_gain=5.0
        )
        
        # Суммарная сила
        total_force = avoidance_force + attractive_force
        
        # Обновление динамики (упрощенная модель)
        acceleration = total_force / 1.5  # масса = 1.5 кг
        agent_vel += acceleration * dt
        
        # Ограничение скорости
        speed = np.linalg.norm(agent_vel)
        if speed > 10:
            agent_vel = agent_vel * (10 / speed)
        
        agent_pos += agent_vel * dt
        trajectory.append(agent_pos.copy())
        
        # Обновление движущихся препятствий
        for obs in obstacles:
            if not obs.is_static:
                obs.position += obs.velocity * dt
        
        # Проверка достижения цели
        if np.linalg.norm(agent_pos - target) < 1.0:
            print(f"\nЦель достигнута за {(step+1)*dt:.1f} с")
            break
    
    # Анализ траектории
    trajectory = np.array(trajectory)
    min_distances = []
    for obs in obstacles:
        distances = [np.linalg.norm(pos - obs.position) for pos in trajectory]
        min_distances.append(min(distances))
    
    print("\nМинимальные расстояния до препятствий:")
    for i, dist in enumerate(min_distances):
        print(f"  Препятствие {i+1}: {dist:.2f} м")
    
    return trajectory


def visualize_results():
    """Визуализация результатов"""
    print("\n" + "=" * 60)
    print("ВИЗУАЛИЗАЦИЯ РЕЗУЛЬТАТОВ")
    print("=" * 60)
    
    # Создание фигуры с подграфиками
    fig = plt.figure(figsize=(15, 10))
    
    # 1. График сходимости консенсуса
    ax1 = fig.add_subplot(2, 3, 1)
    convergence = demo_consensus_sync()
    ax1.plot(convergence)
    ax1.set_xlabel('Итерация')
    ax1.set_ylabel('Дисперсия')
    ax1.set_title('Сходимость консенсуса')
    ax1.grid(True)
    
    # 2. График синхронизации фазы
    ax2 = fig.add_subplot(2, 3, 2)
    sync_history = demo_phase_sync()
    ax2.plot(sync_history)
    ax2.set_xlabel('Шаг времени')
    ax2.set_ylabel('Параметр порядка')
    ax2.set_title('Синхронизация фазы (Курамото)')
    ax2.grid(True)
    ax2.axhline(y=0.95, color='r', linestyle='--', label='Порог')
    ax2.legend()
    
    # 3. 3D траектория с избеганием препятствий
    ax3 = fig.add_subplot(2, 3, 3, projection='3d')
    trajectory = demo_collision_avoidance()
    ax3.plot(trajectory[:, 0], trajectory[:, 1], trajectory[:, 2], 'b-', label='Траектория')
    ax3.scatter(0, 0, -15, c='g', s=100, marker='o', label='Старт')
    ax3.scatter(30, 0, -15, c='r', s=100, marker='*', label='Цель')
    
    # Препятствия
    u = np.linspace(0, 2 * np.pi, 20)
    v = np.linspace(0, np.pi, 20)
    x = 3 * np.outer(np.cos(u), np.sin(v)) + 10
    y = 3 * np.outer(np.sin(u), np.sin(v))
    z = 3 * np.outer(np.ones(np.size(u)), np.cos(v)) - 15
    ax3.plot_surface(x, y, z, alpha=0.3, color='red')
    
    ax3.set_xlabel('X (м)')
    ax3.set_ylabel('Y (м)')
    ax3.set_zlabel('Z (м)')
    ax3.set_title('Избегание препятствий')
    ax3.legend()
    
    # 4-6. Дополнительные графики можно добавить
    
    plt.tight_layout()
    plt.savefig('/workspace/swarm_sync_system/results.png', dpi=150)
    print("\nРезультаты сохранены в results.png")
    
    # Показать график (если есть дисплей)
    try:
        plt.show()
    except:
        print("Не удалось отобразить график (нет дисплея)")


if __name__ == "__main__":
    # Запуск всех демонстраций
    demo_basic_swarm()
    demo_time_sync()
    
    # Визуализация
    visualize_results()
    
    print("\n" + "=" * 60)
    print("ДЕМОНСТРАЦИЯ ЗАВЕРШЕНА")
    print("=" * 60)