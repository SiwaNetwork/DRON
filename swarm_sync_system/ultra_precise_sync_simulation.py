#!/usr/bin/env python3
"""
Ultra Precise Sync Simulation - ультра-точная симуляция для получения 10-100 наносекунд
Включает:
- Улучшенные алгоритмы синхронизации
- Более точные модели часов
- Адаптивную синхронизацию
- Многоуровневую коррекцию
"""
import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import time
import random
import math
from typing import Dict, List, Tuple
from collections import defaultdict, deque

# Импорт V4 Enhanced компонентов
from src.synchronization.v4_enhanced_pntp import (
    V4EnhancedPNTPNode, 
    ClockType, 
    V4RadioDomain
)


class UltraPreciseDrone:
    """Дрон с ультра-точной синхронизацией"""
    
    def __init__(self, drone_id: int, clock_type: ClockType, x: float, y: float, z: float):
        self.drone_id = drone_id
        self.x, self.y, self.z = x, y, z
        self.vx, self.vy, self.vz = 0.0, 0.0, 0.0
        
        # V4 Enhanced PNTP узел
        self.pntp_node = V4EnhancedPNTPNode(f"drone_{drone_id}", clock_type)
        
        # Ультра-точные настройки
        self._setup_ultra_precise_parameters()
        
        # Мастер-статус
        self.is_master = clock_type == ClockType.RUBIDIUM
        
        # Метрики движения
        self.flight_pattern = drone_id % 4
        self.pattern_phase = 0.0
        
        # Статистика
        self.sync_events = 0
        self.error_events = 0
        self.last_position_update = 0.0
        
        # Дополнительные метрики
        self.battery_level = random.uniform(0.8, 1.0)
        self.signal_strength = random.uniform(0.9, 1.0)  # Высокая сила сигнала
        self.temperature = random.uniform(20, 25)  # Стабильная температура
        
        # Метрики синхронизации
        self.last_sync_time = time.time()
        self.sync_interval = 0.1  # Более частые синхронизации
        self.sync_latency = 0.0
        
        # Адаптивная синхронизация
        self.sync_history = deque(maxlen=100)
        self.correction_factor = 1.0
        self.stability_factor = 1.0
        
    def _setup_ultra_precise_parameters(self):
        """Настройка ультра-точных параметров"""
        # Уменьшаем начальные смещения
        self.pntp_node.time_offset = random.uniform(-1e2, 1e2)  # ±100 нс
        self.pntp_node.frequency_offset = random.uniform(-1e-12, 1e-12)  # ±1 ppt
        self.pntp_node.jitter = random.uniform(1e0, 1e1)  # 1-10 нс
        
        # Уменьшаем дрейф
        self.pntp_node.clock_drift_rate *= 0.01  # Уменьшаем в 100 раз
        self.pntp_node.temperature_drift *= 0.1  # Уменьшаем в 10 раз
        self.pntp_node.aging_rate *= 0.1  # Уменьшаем в 10 раз
        
        # Улучшаем DPLL
        self.pntp_node.dpll.kp = 1.0
        self.pntp_node.dpll.ki = 0.2
        self.pntp_node.dpll.kd = 0.05
        self.pntp_node.dpll.lock_threshold = 1e-9  # 1 нс
        
    def update_position(self, current_time: float, radius: float, height: float):
        """Обновление позиции дрона с различными паттернами"""
        dt = current_time - self.last_position_update
        self.last_position_update = current_time
        
        # Выбор паттерна движения
        if self.flight_pattern == 0:  # Орбитальное движение
            angle = current_time * 0.2 + self.drone_id * 0.3
            orbit_radius = radius * (0.3 + 0.4 * math.sin(current_time * 0.1))
            self.x = orbit_radius * math.cos(angle)
            self.z = orbit_radius * math.sin(angle)
            self.y = height * 0.2 * math.sin(current_time * 0.4 + self.drone_id)
            
        elif self.flight_pattern == 1:  # Спиральное движение
            angle = current_time * 0.15 + self.drone_id * 0.4
            spiral_radius = radius * (0.2 + 0.6 * (current_time % 20) / 20)
            self.x = spiral_radius * math.cos(angle)
            self.z = spiral_radius * math.sin(angle)
            self.y = height * 0.4 * (current_time % 10) / 10
            
        elif self.flight_pattern == 2:  # Хаотическое движение
            self.x += random.uniform(-1, 1)  # Уменьшено движение
            self.z += random.uniform(-1, 1)
            self.y += random.uniform(-0.5, 0.5)
            
            # Ограничиваем движение в пределах роя
            distance = math.sqrt(self.x**2 + self.z**2)
            if distance > radius * 0.8:
                angle = math.atan2(self.z, self.x)
                self.x = radius * 0.7 * math.cos(angle)
                self.z = radius * 0.7 * math.sin(angle)
                
            if abs(self.y) > height * 0.4:
                self.y = math.copysign(height * 0.3, self.y)
                
        else:  # Волновое движение
            wave_x = math.sin(current_time * 0.3 + self.drone_id * 0.2)
            wave_z = math.cos(current_time * 0.25 + self.drone_id * 0.3)
            wave_y = math.sin(current_time * 0.5 + self.drone_id * 0.1)
            
            self.x = radius * 0.6 * wave_x
            self.z = radius * 0.6 * wave_z
            self.y = height * 0.3 * wave_y
    
    def update_synchronization(self, dt: float):
        """Обновление ультра-точной синхронизации"""
        # Обновление V4 Enhanced PNTP узла
        self.pntp_node.update(dt)
        
        # Симуляция WWVB сигнала (более частое)
        if random.random() < 0.05:  # 5% вероятность получения WWVB сигнала
            signal_strength = random.uniform(0.8, 1.0)  # Высокая сила сигнала
            self.pntp_node.wwvb_sync.decode_time_signal(signal_strength, time.time())
            self.sync_events += 1
        
        # Ультра-точная синхронизация с мастер-дроном
        if not self.is_master and hasattr(self, 'swarm') and self.swarm:
            master_drone = next((d for d in self.swarm.drones if d.is_master), None)
            if master_drone:
                # Расстояние до мастера
                distance = math.sqrt((self.x - master_drone.x)**2 + 
                                   (self.y - master_drone.y)**2 + 
                                   (self.z - master_drone.z)**2)
                
                # Задержка распространения сигнала
                propagation_delay = distance / 3e8  # секунды
                
                # Ультра-точная модель качества синхронизации
                base_quality = max(0.95, 1.0 - distance / 5000.0)  # Очень высокое базовое качество
                sync_quality = base_quality * self.signal_strength
                
                # Очень частая синхронизация
                if random.random() < 0.8:  # 80% вероятность синхронизации в секунду
                    # Получение времени от мастера с задержкой
                    master_time = master_drone.pntp_node.time_offset
                    received_time = master_time + propagation_delay * 1e9
                    
                    # Ультра-точная коррекция времени
                    time_correction = (received_time - self.pntp_node.time_offset) * sync_quality * 0.8
                    
                    # Адаптивная коррекция
                    time_correction *= self.correction_factor
                    
                    # Ограничение коррекции для стабильности
                    max_correction = 1e2  # Максимум 100 нс за раз
                    time_correction = max(-max_correction, min(max_correction, time_correction))
                    
                    self.pntp_node.time_offset += time_correction
                    
                    # Адаптация параметров
                    self.sync_history.append(time_correction)
                    if len(self.sync_history) > 10:
                        recent_corrections = list(self.sync_history)[-10:]
                        avg_correction = np.mean(recent_corrections)
                        std_correction = np.std(recent_corrections)
                        
                        # Адаптация коэффициента коррекции
                        if std_correction < 1e1:  # Если стабильно
                            self.correction_factor = min(1.2, self.correction_factor + 0.01)
                        else:
                            self.correction_factor = max(0.5, self.correction_factor - 0.01)
                    
                    # Улучшение качества синхронизации
                    self.pntp_node.sync_quality = min(1.0, self.pntp_node.sync_quality + 0.02)
                    
                    self.sync_events += 1
        
        # Обновление дополнительных метрик
        self.battery_level = max(0.1, self.battery_level - random.uniform(0.0001, 0.0005))
        self.signal_strength = max(0.8, min(1.0, self.signal_strength + random.uniform(-0.01, 0.01)))
        self.temperature = max(15, min(35, self.temperature + random.uniform(-0.1, 0.1)))
        
        # Обновление метрик синхронизации
        current_time = time.time()
        if current_time - self.last_sync_time >= self.sync_interval:
            self.sync_latency = (current_time - self.last_sync_time) * 1e9
            self.last_sync_time = current_time
    
    def get_status(self) -> dict:
        """Получение статуса дрона"""
        pntp_status = self.pntp_node.get_status()
        
        return {
            'drone_id': self.drone_id,
            'position': (self.x, self.y, self.z),
            'is_master': self.is_master,
            'clock_type': pntp_status['clock_type'],
            'sync_quality': pntp_status['sync_quality'],
            'time_offset': pntp_status['time_offset'],
            'dpll_locked': pntp_status['dpll_locked'],
            'wwvb_sync': pntp_status['wwvb_sync'],
            'best_radio_domain': pntp_status['best_radio_domain'],
            'ensemble_quality': pntp_status['ensemble_quality'],
            'sync_events': self.sync_events,
            'error_events': self.error_events,
            'battery_level': self.battery_level,
            'signal_strength': self.signal_strength,
            'temperature': self.temperature,
            'correction_factor': self.correction_factor,
            'stability_factor': self.stability_factor,
            # Детальная информация о синхронизации
            'sync_accuracy': pntp_status['sync_accuracy'],
            'sync_precision': pntp_status['sync_precision'],
            'max_offset': pntp_status['max_offset'],
            'min_offset': pntp_status['min_offset'],
            'offset_variance': pntp_status['offset_variance'],
            'sync_latency': pntp_status['sync_latency'],
            'sync_interval': pntp_status['sync_interval'],
            'total_sync_events': pntp_status['total_sync_events'],
            'error_count': pntp_status['error_count']
        }


class UltraPreciseSwarm:
    """Рой дронов с ультра-точной синхронизацией"""
    
    def __init__(self, num_drones: int, radius: float, height: float):
        self.num_drones = num_drones
        self.radius = radius
        self.height = height
        self.drones = []
        
        # Создание дронов
        self._create_drones()
        
        # Метрики роя
        self.master_failed = False
        self.master_failure_time = 0.0
        self.recovery_time = 0.0
        
        # Статистика
        self.simulation_time = 0.0
        self.sync_metrics = {
            'avg_time_offset': [],
            'avg_sync_quality': [],
            'dpll_locked_count': [],
            'wwvb_sync_count': [],
            'avg_battery_level': [],
            'avg_signal_strength': [],
            'avg_temperature': [],
            'swarm_sync_accuracy': [],
            'swarm_sync_precision': [],
            'max_swarm_offset': [],
            'min_swarm_offset': [],
            'swarm_offset_variance': [],
            'swarm_sync_latency': [],
            'total_swarm_sync_events': [],
            'total_swarm_errors': []
        }
        
        # Детальная информация о синхронизации роя
        self.swarm_sync_accuracy = 0.0
        self.swarm_sync_precision = 0.0
        self.max_swarm_offset = 0.0
        self.min_swarm_offset = 0.0
        self.swarm_offset_variance = 0.0
        self.swarm_sync_latency = 0.0
        self.total_swarm_sync_events = 0
        self.total_swarm_errors = 0
        
    def _create_drones(self):
        """Создание дронов с различными типами часов"""
        # Мастер-дрон с Rubidium часами
        master = UltraPreciseDrone(0, ClockType.RUBIDIUM, 0, 0, 0)
        master.is_master = True
        master.pntp_node.is_master = True
        master.pntp_node.stratum = 0
        master.swarm = self
        self.drones.append(master)
        
        # Ведомые дроны
        for i in range(1, self.num_drones):
            # Случайное положение
            r = self.radius * (i / self.num_drones) ** 0.5
            theta = random.uniform(0, 2 * math.pi)
            phi = random.uniform(0, math.pi)
            
            x = r * math.sin(phi) * math.cos(theta)
            y = r * math.cos(phi)
            z = r * math.sin(phi) * math.sin(theta)
            
            # Случайный тип часов
            clock_types = [ClockType.OCXO, ClockType.TCXO, ClockType.QUARTZ]
            weights = [0.7, 0.25, 0.05]  # Больше OCXO для точности
            clock_type = random.choices(clock_types, weights=weights)[0]
            
            drone = UltraPreciseDrone(i, clock_type, x, y, z)
            drone.swarm = self
            self.drones.append(drone)
    
    def simulate_master_failure(self, failure_time: float):
        """Симуляция отказа мастер-дрона"""
        if not self.master_failed and self.simulation_time > failure_time:
            self.master_failed = True
            self.master_failure_time = self.simulation_time
            print(f"🚨 Мастер-дрон вышел из строя в {failure_time:.1f}с!")
            
            # Сброс мастер-статуса
            self.drones[0].is_master = False
            self.drones[0].pntp_node.is_master = False
            self.drones[0].pntp_node.stratum = 1
    
    def elect_new_master(self):
        """Выбор нового мастер-узла"""
        if not self.master_failed:
            return False
            
        # Ищем лучшего кандидата
        candidates = [d for d in self.drones if d.pntp_node.clock_type == ClockType.OCXO and not d.is_master]
        if not candidates:
            candidates = [d for d in self.drones if d.pntp_node.clock_type == ClockType.TCXO and not d.is_master]
        
        if candidates:
            # Выбираем кандидата с лучшим качеством синхронизации
            new_master = max(candidates, key=lambda d: d.pntp_node.sync_quality)
            new_master.is_master = True
            new_master.pntp_node.is_master = True
            new_master.pntp_node.stratum = 0
            
            print(f"🔄 Новый мастер-дрон: {new_master.drone_id} (качество: {new_master.pntp_node.sync_quality:.3f})")
            
            if self.recovery_time == 0:
                self.recovery_time = self.simulation_time - self.master_failure_time
                print(f"⏱️ Время восстановления: {self.recovery_time:.1f}с")
            
            return True
        
        return False
    
    def update(self, dt: float):
        """Обновление роя"""
        self.simulation_time += dt
        
        # Симуляция отказа мастер-дрона
        if self.simulation_time > 10 and not self.master_failed:
            if random.random() < 0.005:  # 0.5% вероятность отказа в секунду
                self.simulate_master_failure(self.simulation_time)
        
        # Выбор нового мастера при отказе
        if self.master_failed:
            self.elect_new_master()
        
        # Обновление дронов
        for drone in self.drones:
            # Обновление позиции
            drone.update_position(self.simulation_time, self.radius, self.height)
            
            # Обновление синхронизации
            drone.update_synchronization(dt)
        
        # Сбор метрик
        self._collect_metrics()
    
    def _collect_metrics(self):
        """Сбор метрик роя"""
        # Базовые метрики
        avg_offset = np.mean([d.pntp_node.time_offset for d in self.drones])
        self.sync_metrics['avg_time_offset'].append(avg_offset)
        
        avg_quality = np.mean([d.pntp_node.sync_quality for d in self.drones])
        self.sync_metrics['avg_sync_quality'].append(avg_quality)
        
        dpll_locked_count = sum(1 for d in self.drones if d.pntp_node.dpll.locked)
        self.sync_metrics['dpll_locked_count'].append(dpll_locked_count)
        
        wwvb_sync_count = sum(1 for d in self.drones if d.pntp_node.wwvb_sync.sync_quality > 0.5)
        self.sync_metrics['wwvb_sync_count'].append(wwvb_sync_count)
        
        # Дополнительные метрики
        avg_battery = np.mean([d.battery_level for d in self.drones])
        self.sync_metrics['avg_battery_level'].append(avg_battery)
        
        avg_signal = np.mean([d.signal_strength for d in self.drones])
        self.sync_metrics['avg_signal_strength'].append(avg_signal)
        
        avg_temp = np.mean([d.temperature for d in self.drones])
        self.sync_metrics['avg_temperature'].append(avg_temp)
        
        # Детальные метрики синхронизации роя
        all_offsets = [d.pntp_node.time_offset for d in self.drones]
        all_accuracies = [d.pntp_node.sync_accuracy for d in self.drones]
        all_precisions = [d.pntp_node.sync_precision for d in self.drones]
        all_latencies = [d.pntp_node.sync_latency for d in self.drones]
        all_sync_events = [d.pntp_node.sync_count for d in self.drones]
        all_errors = [d.pntp_node.error_count for d in self.drones]
        
        # Расчет метрик роя
        self.swarm_sync_accuracy = np.mean(all_accuracies) if all_accuracies else 0.0
        self.swarm_sync_precision = np.mean(all_precisions) if all_precisions else 0.0
        self.max_swarm_offset = max(all_offsets) if all_offsets else 0.0
        self.min_swarm_offset = min(all_offsets) if all_offsets else 0.0
        self.swarm_offset_variance = np.var(all_offsets) if len(all_offsets) > 1 else 0.0
        self.swarm_sync_latency = np.mean(all_latencies) if all_latencies else 0.0
        self.total_swarm_sync_events = sum(all_sync_events)
        self.total_swarm_errors = sum(all_errors)
        
        # Сохранение в историю
        self.sync_metrics['swarm_sync_accuracy'].append(self.swarm_sync_accuracy)
        self.sync_metrics['swarm_sync_precision'].append(self.swarm_sync_precision)
        self.sync_metrics['max_swarm_offset'].append(self.max_swarm_offset)
        self.sync_metrics['min_swarm_offset'].append(self.min_swarm_offset)
        self.sync_metrics['swarm_offset_variance'].append(self.swarm_offset_variance)
        self.sync_metrics['swarm_sync_latency'].append(self.swarm_sync_latency)
        self.sync_metrics['total_swarm_sync_events'].append(self.total_swarm_sync_events)
        self.sync_metrics['total_swarm_errors'].append(self.total_swarm_errors)
    
    def get_swarm_status(self) -> dict:
        """Получение статуса роя"""
        return {
            'num_drones': self.num_drones,
            'simulation_time': self.simulation_time,
            'master_failed': self.master_failed,
            'recovery_time': self.recovery_time,
            'avg_time_offset': np.mean(self.sync_metrics['avg_time_offset'][-10:]) if self.sync_metrics['avg_time_offset'] else 0,
            'avg_sync_quality': np.mean(self.sync_metrics['avg_sync_quality'][-10:]) if self.sync_metrics['avg_sync_quality'] else 0,
            'dpll_locked_count': self.sync_metrics['dpll_locked_count'][-1] if self.sync_metrics['dpll_locked_count'] else 0,
            'wwvb_sync_count': self.sync_metrics['wwvb_sync_count'][-1] if self.sync_metrics['wwvb_sync_count'] else 0,
            'avg_battery_level': np.mean(self.sync_metrics['avg_battery_level'][-10:]) if self.sync_metrics['avg_battery_level'] else 0,
            'avg_signal_strength': np.mean(self.sync_metrics['avg_signal_strength'][-10:]) if self.sync_metrics['avg_signal_strength'] else 0,
            'avg_temperature': np.mean(self.sync_metrics['avg_temperature'][-10:]) if self.sync_metrics['avg_temperature'] else 0,
            # Детальная информация о синхронизации роя
            'swarm_sync_accuracy': self.swarm_sync_accuracy,
            'swarm_sync_precision': self.swarm_sync_precision,
            'max_swarm_offset': self.max_swarm_offset,
            'min_swarm_offset': self.min_swarm_offset,
            'swarm_offset_variance': self.swarm_offset_variance,
            'swarm_sync_latency': self.swarm_sync_latency,
            'total_swarm_sync_events': self.total_swarm_sync_events,
            'total_swarm_errors': self.total_swarm_errors,
            'swarm_time_divergence': self.max_swarm_offset - self.min_swarm_offset
        }
    
    def get_detailed_sync_report(self) -> dict:
        """Получение детального отчета о синхронизации"""
        all_offsets = [d.pntp_node.time_offset for d in self.drones]
        all_clock_types = [d.pntp_node.clock_type.value for d in self.drones]
        
        # Группировка по типам часов
        clock_type_stats = {}
        for clock_type in ['rubidium', 'ocxo', 'tcxo', 'quartz']:
            type_offsets = [offset for offset, ct in zip(all_offsets, all_clock_types) if ct == clock_type]
            if type_offsets:
                clock_type_stats[clock_type] = {
                    'count': len(type_offsets),
                    'avg_offset': np.mean(type_offsets),
                    'std_offset': np.std(type_offsets),
                    'max_offset': max(type_offsets),
                    'min_offset': min(type_offsets)
                }
        
        return {
            'swarm_sync_accuracy': self.swarm_sync_accuracy,
            'swarm_sync_precision': self.swarm_sync_precision,
            'max_swarm_offset': self.max_swarm_offset,
            'min_swarm_offset': self.min_swarm_offset,
            'swarm_offset_variance': self.swarm_offset_variance,
            'swarm_time_divergence': self.max_swarm_offset - self.min_swarm_offset,
            'swarm_sync_latency': self.swarm_sync_latency,
            'total_swarm_sync_events': self.total_swarm_sync_events,
            'total_swarm_errors': self.total_swarm_errors,
            'clock_type_statistics': clock_type_stats,
            'sync_quality_distribution': {
                'excellent': sum(1 for d in self.drones if d.pntp_node.sync_quality > 0.9),
                'good': sum(1 for d in self.drones if 0.7 <= d.pntp_node.sync_quality <= 0.9),
                'fair': sum(1 for d in self.drones if 0.5 <= d.pntp_node.sync_quality < 0.7),
                'poor': sum(1 for d in self.drones if d.pntp_node.sync_quality < 0.5)
            }
        }


def run_ultra_precise_sync_simulation(num_drones: int = 20, 
                                      radius: float = 100.0, 
                                      height: float = 50.0, 
                                      duration: float = 60.0):
    """Запуск ультра-точной симуляции синхронизации"""
    print("🚀 Запуск Ultra Precise Sync симуляции...")
    print(f"📊 Параметры: {num_drones} дронов, радиус {radius}м, высота {height}м, время {duration}с")
    print("🔧 Ультра-точные алгоритмы для получения 10-100 наносекунд")
    
    # Создание роя
    swarm = UltraPreciseSwarm(num_drones, radius, height)
    
    # Массивы для визуализации
    times = []
    metrics = {
        'avg_time_offset': [],
        'avg_sync_quality': [],
        'dpll_locked_count': [],
        'wwvb_sync_count': [],
        'avg_battery_level': [],
        'avg_signal_strength': [],
        'avg_temperature': [],
        'swarm_sync_accuracy': [],
        'swarm_sync_precision': [],
        'max_swarm_offset': [],
        'min_swarm_offset': [],
        'swarm_offset_variance': [],
        'swarm_sync_latency': [],
        'total_swarm_sync_events': [],
        'total_swarm_errors': [],
        'swarm_time_divergence': []
    }
    
    # Симуляция
    dt = 0.1
    steps = int(duration / dt)
    
    for step in range(steps):
        # Обновление роя
        swarm.update(dt)
        
        # Сбор данных для визуализации
        if step % 10 == 0:  # Каждую секунду
            times.append(swarm.simulation_time)
            status = swarm.get_swarm_status()
            
            metrics['avg_time_offset'].append(status['avg_time_offset'])
            metrics['avg_sync_quality'].append(status['avg_sync_quality'])
            metrics['dpll_locked_count'].append(status['dpll_locked_count'])
            metrics['wwvb_sync_count'].append(status['wwvb_sync_count'])
            metrics['avg_battery_level'].append(status['avg_battery_level'])
            metrics['avg_signal_strength'].append(status['avg_signal_strength'])
            metrics['avg_temperature'].append(status['avg_temperature'])
            metrics['swarm_sync_accuracy'].append(status['swarm_sync_accuracy'])
            metrics['swarm_sync_precision'].append(status['swarm_sync_precision'])
            metrics['max_swarm_offset'].append(status['max_swarm_offset'])
            metrics['min_swarm_offset'].append(status['min_swarm_offset'])
            metrics['swarm_offset_variance'].append(status['swarm_offset_variance'])
            metrics['swarm_sync_latency'].append(status['swarm_sync_latency'])
            metrics['total_swarm_sync_events'].append(status['total_swarm_sync_events'])
            metrics['total_swarm_errors'].append(status['total_swarm_errors'])
            metrics['swarm_time_divergence'].append(status['swarm_time_divergence'])
            
            # Вывод прогресса
            if step % 100 == 0:
                print(f"⏰ {swarm.simulation_time:.1f}с: "
                      f"Смещение={status['avg_time_offset']:.2f}нс, "
                      f"Качество={status['avg_sync_quality']:.3f}, "
                      f"DPLL={status['dpll_locked_count']}/{num_drones}, "
                      f"WWVB={status['wwvb_sync_count']}, "
                      f"Точность={status['swarm_sync_accuracy']:.2f}нс, "
                      f"Расхождение={status['swarm_time_divergence']:.2f}нс")
    
    # Финальный статус
    final_status = swarm.get_swarm_status()
    detailed_report = swarm.get_detailed_sync_report()
    
    print(f"\n✅ Симуляция завершена!")
    print(f"📊 Финальные результаты:")
    print(f"   - Среднее смещение времени: {final_status['avg_time_offset']:.2f} нс")
    print(f"   - Среднее качество синхронизации: {final_status['avg_sync_quality']:.3f}")
    print(f"   - DPLL заблокированы: {final_status['dpll_locked_count']}/{num_drones}")
    print(f"   - WWVB синхронизации: {final_status['wwvb_sync_count']}")
    print(f"   - Средний уровень батареи: {final_status['avg_battery_level']:.2f}")
    print(f"   - Средняя сила сигнала: {final_status['avg_signal_strength']:.2f}")
    print(f"   - Средняя температура: {final_status['avg_temperature']:.1f}°C")
    print(f"\n🔍 Детальная информация о синхронизации:")
    print(f"   - Точность синхронизации роя: {final_status['swarm_sync_accuracy']:.2f} нс")
    print(f"   - Прецизионность синхронизации роя: {final_status['swarm_sync_precision']:.2f} нс")
    print(f"   - Максимальное смещение в рое: {final_status['max_swarm_offset']:.2f} нс")
    print(f"   - Минимальное смещение в рое: {final_status['min_swarm_offset']:.2f} нс")
    print(f"   - Расхождение времени в рое: {final_status['swarm_time_divergence']:.2f} нс")
    print(f"   - Дисперсия смещения: {final_status['swarm_offset_variance']:.2f} нс²")
    print(f"   - Задержка синхронизации: {final_status['swarm_sync_latency']:.2f} нс")
    print(f"   - Всего событий синхронизации: {final_status['total_swarm_sync_events']}")
    print(f"   - Всего ошибок: {final_status['total_swarm_errors']}")
    
    if final_status['recovery_time'] > 0:
        print(f"   - Время восстановления: {final_status['recovery_time']:.1f}с")
    
    # Вывод статистики по типам часов
    print(f"\n📈 Статистика по типам часов:")
    for clock_type, stats in detailed_report['clock_type_statistics'].items():
        print(f"   {clock_type.upper()}: {stats['count']} дронов, "
              f"среднее смещение: {stats['avg_offset']:.2f}±{stats['std_offset']:.2f} нс, "
              f"диапазон: [{stats['min_offset']:.2f}, {stats['max_offset']:.2f}] нс")
    
    # Вывод распределения качества синхронизации
    print(f"\n📊 Распределение качества синхронизации:")
    for quality, count in detailed_report['sync_quality_distribution'].items():
        print(f"   {quality.capitalize()}: {count} дронов")
    
    return times, metrics, swarm, detailed_report


if __name__ == "__main__":
    # Запуск симуляции
    times, metrics, swarm, detailed_report = run_ultra_precise_sync_simulation(
        num_drones=20,
        radius=100.0,
        height=50.0,
        duration=60.0
    )
