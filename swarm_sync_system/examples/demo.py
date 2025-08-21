#!/usr/bin/env python3
"""
Простая демонстрация роевой системы
"""
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import numpy as np
from src.core import Drone, Swarm
from src.algorithms.consensus import AverageConsensus
from src.algorithms.synchronization import PhaseSync

def main():
    print("РОЕВАЯ СИСТЕМА СИНХРОНИЗАЦИИ БЕСПИЛОТНИКОВ")
    print("=" * 50)
    
    # Создание роя из 3 дронов
    swarm = Swarm()
    
    for i in range(3):
        drone = Drone(
            drone_id=f"drone_{i}",
            initial_position=np.array([i*5, 0, -10])
        )
        swarm.add_drone(drone)
    
    print(f"Создан рой из {len(swarm.drones)} дронов")
    
    # Установка V-образной формации
    swarm.set_formation('v', spacing=5.0)
    print("Установлена V-образная формация")
    
    # Симуляция 5 секунд
    dt = 0.1
    for step in range(50):
        swarm.update(dt)
        if step % 10 == 0:
            print(f"Время: {step*dt:.1f}с, Связность: {swarm.get_connectivity():.2f}")
    
    print("\nСтатус роя:")
    status = swarm.get_status_summary()
    print(f"  Радиус роя: {status['swarm_radius']:.2f} м")
    print(f"  Связность: {status['connectivity']:.2f}")
    
    print("\nДЕМОНСТРАЦИЯ ЗАВЕРШЕНА")

if __name__ == "__main__":
    main()
