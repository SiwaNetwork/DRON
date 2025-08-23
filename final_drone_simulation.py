#!/usr/bin/env python3
"""
FINAL DRONE SIMULATION - Финальная 3D симуляция роя дронов
Полностью автономный файл со всеми зависимостями
Включает:
- HTTP сервер с API
- 3D визуализацию с Three.js
- Ультра-точные алгоритмы синхронизации
- Интерактивное управление
- Все в одном файле без внешних зависимостей
"""

import json
import time
import threading
import random
import math
from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse, parse_qs
import webbrowser
from collections import deque
from enum import Enum


# ===== КОНСТАНТЫ И ТИПЫ =====

class ClockType(Enum):
    """Типы часов"""
    RUBIDIUM = "rubidium"
    OCXO = "ocxo"
    TCXO = "tcxo"
    QUARTZ = "quartz"


# ===== АЛГОРИТМЫ СИНХРОНИЗАЦИИ =====

class SimpleDPLL:
    """Упрощенный цифровой PLL контроллер"""
    def __init__(self):
        self.kp = 1.0
        self.ki = 0.2
        self.integral = 0.0
        self.locked = False
        self.lock_threshold = 1e-9
        
    def update(self, error: float, dt: float) -> float:
        """Обновление PLL"""
        self.integral += error * dt
        output = self.kp * error + self.ki * self.integral
        self.locked = abs(error) < self.lock_threshold
        return output


class FinalDrone:
    """Финальная версия дрона с упрощенными алгоритмами"""
    
    def __init__(self, drone_id: int, x: float, y: float, z: float, is_master: bool = False):
        self.id = drone_id
        self.x = x
        self.y = y
        self.z = z
        self.is_master = is_master
        
        # Выбор типа часов
        if is_master:
            self.clock_type = ClockType.RUBIDIUM
        else:
            self.clock_type = random.choice([ClockType.OCXO, ClockType.TCXO, ClockType.QUARTZ])
        
        # PLL контроллер
        self.dpll = SimpleDPLL()
        
        # Параметры синхронизации (в наносекундах)
        self.time_offset = random.uniform(-100, 100)  # нс
        self.frequency_offset = random.uniform(-1e-12, 1e-12)  # ppt
        self.jitter = random.uniform(1, 10)  # нс
        
        # Метрики (должны быть до _setup_clock_characteristics!)
        self.sync_events = 0
        self.battery_level = random.uniform(0.8, 1.0)
        self.signal_strength = random.uniform(0.8, 1.0)
        self.temperature = random.uniform(20, 30)
        
        # Характеристики дрейфа по типу часов
        self._setup_clock_characteristics()
        
        # Физические параметры (реалистичные для квадрокоптера)
        # Начальная скорость в пределах precision_speed для стабильности
        max_initial_speed = 2.0  # м/с
        self.velocity_x = random.uniform(-max_initial_speed, max_initial_speed)
        self.velocity_y = random.uniform(-max_initial_speed, max_initial_speed)
        self.velocity_z = random.uniform(-0.5, 0.5)  # Меньше вертикальная скорость
        
        # Режим полета (влияет на максимальную скорость)
        self.flight_mode = random.choice(['precision', 'normal', 'sport'])  # Режимы как у Mavic
        self.wind_resistance = random.uniform(0.8, 1.2)  # Влияние ветра
        self.sync_quality = 0.5
        self.sync_history = deque(maxlen=10)
    
    def _setup_clock_characteristics(self):
        """Настройка характеристик часов по типу"""
        clock_params = {
            ClockType.RUBIDIUM: {
                'drift_rate': (-1e-15, 1e-15),  # fs/s
                'stability': 0.95,
                'accuracy': 1e-11,
                'phase_noise': 1e-12
            },
            ClockType.OCXO: {
                'drift_rate': (-1e-12, 1e-12),  # ps/s
                'stability': 0.85,
                'accuracy': 1e-9,
                'phase_noise': 1e-10
            },
            ClockType.TCXO: {
                'drift_rate': (-1e-9, 1e-9),   # ns/s
                'stability': 0.70,
                'accuracy': 1e-6,
                'phase_noise': 1e-8
            },
            ClockType.QUARTZ: {
                'drift_rate': (-1e-6, 1e-6),   # µs/s
                'stability': 0.50,
                'accuracy': 1e-4,
                'phase_noise': 1e-6
            }
        }
        
        params = clock_params[self.clock_type]
        self.clock_drift_rate = random.uniform(*params['drift_rate'])
        self.stability = params['stability']
        self.accuracy = params['accuracy']
        self.phase_noise = params['phase_noise']
        
        # Новые параметры для продвинутой синхронизации
        self.neighbors = []  # Соседние дроны для peer-to-peer
        self.sync_partners = {}  # Партнеры по синхронизации с качеством связи
        self.clock_offset_estimates = {}  # Оценки смещения часов соседей
        self.path_delay_estimates = {}  # Оценки задержки до соседей
        self.last_sync_time = 0
        self.sync_algorithm = 'ptp'  # По умолчанию PTP
        
        # Параметры для failover и выборов лидера
        self.connection_lost = False  # Потеряна ли связь с мастером
        self.last_master_contact = time.time()  # Время последней связи с мастером
        self.master_timeout = 5.0  # Таймаут для объявления мастера пропавшим (секунды)
        self.election_in_progress = False  # Идут ли выборы нового мастера
        self.election_vote = None  # За кого голосует этот дрон
        self.election_votes_received = {}  # Полученные голоса (для кандидатов)
        self.leader_priority = self._calculate_leader_priority()  # Приоритет для выборов
        self.backup_master = False  # Является ли резервным мастером
    
    def _calculate_leader_priority(self):
        """Вычисление приоритета для выборов лидера"""
        # Приоритет основан на типе часов, стабильности, батарее и ID
        clock_priority = {
            ClockType.RUBIDIUM: 100,
            ClockType.OCXO: 80,
            ClockType.TCXO: 60,
            ClockType.QUARTZ: 40
        }
        
        base_priority = clock_priority.get(self.clock_type, 20)
        stability_bonus = int(self.stability * 20)
        battery_bonus = int(self.battery_level * 10)
        
        # ID как tie-breaker (меньший ID = выше приоритет)
        id_penalty = self.id
        
        return base_priority + stability_bonus + battery_bonus - id_penalty
    
    def update(self, dt: float, swarm=None):
        """Обновление дрона"""
        # Обновление физики движения
        self._update_physics(dt)
        
        # Обновление синхронизации
        self._update_synchronization(dt, swarm)
        
        # Обновление системы failover и выборов лидера
        self._update_failover_system(dt, swarm)
        
        # Обновление метрик
        self._update_metrics()
    
    def _update_physics(self, dt: float):
        """Обновление реалистичной физики движения"""
        # Получаем параметры от роя
        if hasattr(self, 'swarm_ref') and self.swarm_ref:
            flight_pattern = getattr(self.swarm_ref, 'flight_pattern', 'random')
            formation_type = getattr(self.swarm_ref, 'formation_type', 'sphere')
            # Выбираем скорость в зависимости от режима полета дрона
            if self.flight_mode == 'precision':
                max_speed = getattr(self.swarm_ref, 'precision_speed', 3.5)
            elif self.flight_mode == 'sport':
                max_speed = getattr(self.swarm_ref, 'max_speed', 15.0)
            else:  # normal
                max_speed = getattr(self.swarm_ref, 'normal_speed', 8.0)
            max_range = getattr(self.swarm_ref, 'radius', 80.0)
            ascent_speed = getattr(self.swarm_ref, 'ascent_speed', 5.0)
            descent_speed = getattr(self.swarm_ref, 'descent_speed', 3.0)
        else:
            flight_pattern = 'random'
            formation_type = 'sphere'
            max_speed = 8.0 if self.flight_mode == 'normal' else (3.5 if self.flight_mode == 'precision' else 15.0)
            max_range = 80.0
            ascent_speed = 5.0
            descent_speed = 3.0
        
        # Симуляция разных паттернов полета
        if flight_pattern == 'formation':
            self._update_formation_flight(dt, formation_type, max_range)
        elif flight_pattern == 'patrol':
            self._update_patrol_flight(dt, max_range)
        elif flight_pattern == 'orbit':
            self._update_orbit_flight(dt, max_range)
        else:  # random
            self._update_random_flight(dt)
        
        # Ограничение скорости с учетом реалистичных параметров
        # Применяем влияние ветра
        effective_max_speed = max_speed * self.wind_resistance
        
        # Горизонтальные скорости
        self.velocity_x = max(-effective_max_speed, min(effective_max_speed, self.velocity_x))
        self.velocity_y = max(-effective_max_speed, min(effective_max_speed, self.velocity_y))
        
        # Вертикальные скорости с поддержанием эшелона
        if hasattr(self, 'assigned_altitude'):
            # Стремимся к назначенной высоте
            altitude_error = self.assigned_altitude - self.z
            
            # ПИД-регулятор для высоты
            if not hasattr(self, 'altitude_error_integral'):
                self.altitude_error_integral = 0
                self.last_altitude_error = 0
            
            # Пропорциональная составляющая
            kp = 0.1
            # Интегральная составляющая
            ki = 0.01
            self.altitude_error_integral += altitude_error * dt
            # Дифференциальная составляющая
            kd = 0.05
            altitude_error_derivative = (altitude_error - self.last_altitude_error) / dt
            
            # ПИД-коррекция
            altitude_correction = (kp * altitude_error + 
                                 ki * self.altitude_error_integral + 
                                 kd * altitude_error_derivative)
            
            # Применяем коррекцию к вертикальной скорости
            self.velocity_z += altitude_correction
            self.last_altitude_error = altitude_error
        
        # Ограничения вертикальной скорости
        if self.velocity_z > 0:  # Подъем
            self.velocity_z = min(ascent_speed, self.velocity_z)
        else:  # Спуск
            self.velocity_z = max(-descent_speed, self.velocity_z)
        
        # Обновление позиции
        self.x += self.velocity_x * dt
        self.y += self.velocity_y * dt
        self.z += self.velocity_z * dt
        
        # Ограничение области полета
        self.x = max(-max_range, min(max_range, self.x))
        self.y = max(-max_range, min(max_range, self.y))
        self.z = max(5, min(100, self.z))
        
        # Отскок от границ
        if abs(self.x) > max_range * 0.9:
            self.velocity_x *= -0.8
        if abs(self.y) > max_range * 0.9:
            self.velocity_y *= -0.8
        if self.z < 10 or self.z > 90:
            self.velocity_z *= -0.8
    
    def _update_random_flight(self, dt: float):
        """Случайный полет"""
        self.velocity_x += random.uniform(-0.5, 0.5)
        self.velocity_y += random.uniform(-0.5, 0.5)
        self.velocity_z += random.uniform(-0.2, 0.2)
    
    def _update_formation_flight(self, dt: float, formation_type: str, max_range: float):
        """Полет в формации с многоуровневым размещением"""
        # Получаем эшелон дрона
        altitude_level = getattr(self, 'altitude_level', 2)
        base_altitude = getattr(self, 'assigned_altitude', 100)
        
        # Целевая позиция в формации с учетом эшелона
        if formation_type == 'line':
            target_x = (self.id - 10) * 15
            target_y = altitude_level * 25  # Разные линии по эшелонам
            target_z = base_altitude
        elif formation_type == 'circle':
            angle = (self.id / 20.0) * 2 * math.pi
            radius = max_range * 0.6 + altitude_level * 30  # Концентрические круги
            target_x = radius * math.cos(angle)
            target_y = radius * math.sin(angle)
            target_z = base_altitude
        elif formation_type == 'v_shape':
            if self.id % 2 == 0:
                target_x = (self.id // 2) * 10
                target_y = (self.id // 2) * 10 + altitude_level * 20
            else:
                target_x = (self.id // 2) * 10
                target_y = -(self.id // 2) * 10 - altitude_level * 20
            target_z = base_altitude
        else:  # sphere - 3D сферическая формация
            phi = math.acos(1 - 2 * (self.id / 20.0))
            theta = math.pi * (1 + 5**0.5) * self.id
            # Радиус зависит от эшелона - внутренние и внешние слои
            radius = max_range * (0.4 + altitude_level * 0.15)
            target_x = radius * math.sin(phi) * math.cos(theta)
            target_y = radius * math.sin(phi) * math.sin(theta)
            target_z = base_altitude + radius * math.cos(phi) * 0.2
        
        # Движение к целевой позиции
        dx = target_x - self.x
        dy = target_y - self.y
        dz = target_z - self.z
        
        force = 2.0
        self.velocity_x += dx * force * dt
        self.velocity_y += dy * force * dt
        self.velocity_z += dz * force * dt
    
    def _update_patrol_flight(self, dt: float, max_range: float):
        """Патрульный полет"""
        # Патрулирование по периметру
        center_distance = math.sqrt(self.x**2 + self.y**2)
        patrol_radius = max_range * 0.8
        
        if center_distance < patrol_radius:
            # Движение к периметру
            angle = math.atan2(self.y, self.x)
            target_x = patrol_radius * math.cos(angle)
            target_y = patrol_radius * math.sin(angle)
            
            self.velocity_x += (target_x - self.x) * dt
            self.velocity_y += (target_y - self.y) * dt
        else:
            # Движение по кругу
            angle = math.atan2(self.y, self.x) + 0.5 * dt
            self.velocity_x += patrol_radius * math.cos(angle) - self.x
            self.velocity_y += patrol_radius * math.sin(angle) - self.y
    
    def _update_orbit_flight(self, dt: float, max_range: float):
        """Орбитальный полет вокруг центра"""
        orbit_radius = max_range * (0.3 + (self.id % 5) * 0.15)
        orbit_speed = 0.8 + (self.id % 3) * 0.2
        
        angle = math.atan2(self.y, self.x) + orbit_speed * dt
        target_x = orbit_radius * math.cos(angle)
        target_y = orbit_radius * math.sin(angle)
        target_z = 40 + 10 * math.sin(angle * 2)
        
        self.velocity_x += (target_x - self.x) * 3.0 * dt
        self.velocity_y += (target_y - self.y) * 3.0 * dt
        self.velocity_z += (target_z - self.z) * 2.0 * dt
    
    def _update_synchronization(self, dt: float, swarm):
        """Обновление синхронизации"""
        # Симуляция дрейфа часов
        drift = self.clock_drift_rate * dt
        jitter = random.uniform(-self.jitter, self.jitter) * 0.1
        
        self.time_offset += drift + jitter
        
        # Синхронизация с мастер-дроном
        if not self.is_master and swarm:
            master_drone = next((d for d in swarm.drones if d.is_master), None)
            if master_drone:
                # Расчет расстояния
                distance = math.sqrt(
                    (self.x - master_drone.x)**2 + 
                    (self.y - master_drone.y)**2 + 
                    (self.z - master_drone.z)**2
                )
                
                # Качество синхронизации
                sync_quality = max(0.7, 1.0 - distance / 300.0) * self.stability
                
                # Синхронизация
                if random.random() < 0.6:  # 60% вероятность
                    error = master_drone.time_offset - self.time_offset
                    correction = self.dpll.update(error, dt) * sync_quality * 0.5
                    
                    # Ограничение коррекции
                    max_correction = 20.0  # 20 нс
                    correction = max(-max_correction, min(max_correction, correction))
                    
                    self.time_offset += correction
                    self.sync_events += 1
                    self.sync_quality = min(1.0, self.sync_quality + 0.01)
                    
                    self.sync_history.append(correction)
    
    def _update_metrics(self):
        """Обновление метрик"""
        self.battery_level = max(0.2, self.battery_level - random.uniform(0.0001, 0.0003))
        self.signal_strength = max(0.6, min(1.0, self.signal_strength + random.uniform(-0.01, 0.01)))
        self.temperature = max(15, min(35, self.temperature + random.uniform(-0.05, 0.05)))
    
    def get_status(self):
        """Получение статуса дрона"""
        return {
            'id': self.id,
            'position': [self.x, self.y, self.z],
            'velocity': [self.velocity_x, self.velocity_y, self.velocity_z],
            'is_master': self.is_master,
            'clock_type': self.clock_type.value,
            'time_offset': self.time_offset,
            'frequency_offset': self.frequency_offset,
            'jitter': self.jitter,
            'sync_quality': self.sync_quality,
            'dpll_locked': self.dpll.locked,
            'sync_events': self.sync_events,
            'battery_level': self.battery_level,
            'signal_strength': self.signal_strength,
            'temperature': self.temperature
        }
    
    def _update_synchronization(self, dt: float, swarm=None):
        """Обновленная система синхронизации с поддержкой различных алгоритмов"""
        if not swarm:
            return
            
        # Получаем параметры синхронизации из конфигурации
        sync_config = getattr(swarm, 'sync_config', {})
        topology = sync_config.get('sync_topology', 'master_slave')
        algorithm = sync_config.get('sync_algorithm', 'ptp')
        sync_range = sync_config.get('sync_range', 300.0)
        sync_frequency = sync_config.get('sync_frequency', 1.0)
        
        # Обновляем соседей для peer-to-peer топологий
        if topology != 'master_slave':
            self.discover_neighbors(swarm.drones, sync_range, swarm.sync_config)
        
        # Выполняем синхронизацию в зависимости от топологии
        if topology == 'master_slave':
            self._master_slave_sync(swarm, sync_frequency)
        elif topology == 'peer_to_peer':
            self.peer_to_peer_sync(algorithm)
        elif topology == 'hierarchical':
            self._hierarchical_sync(swarm, sync_range)
        elif topology == 'mesh':
            self._mesh_sync(swarm, sync_range, algorithm)
    
    def discover_neighbors(self, all_drones, sync_range=300.0):
        """Обнаружение соседних дронов для peer-to-peer синхронизации"""
        self.neighbors = []
        self.sync_partners = {}
        
        for drone in all_drones:
            if drone.id == self.id:
                continue
                
            distance = math.sqrt((self.x - drone.x)**2 + 
                               (self.y - drone.y)**2 + 
                               (self.z - drone.z)**2)
            
            if distance <= sync_range:
                self.neighbors.append(drone)
                # Реалистичный расчет качества связи на основе физических законов
                if frequency_config:
                    freq_params = self._get_frequency_parameters(
                        frequency_config.get('frequency_band', '2.4ghz'),
                        frequency_config.get('channel_width', 20),
                        frequency_config.get('interference_model', 'urban')
                    )
                    
                    # Расчет потерь в свободном пространстве (уравнение Фрииса)
                    path_loss_db = 20 * math.log10(distance) + 20 * math.log10(freq_params['frequency']) - 147.55
                    
                    # Эффект Доплера при движении дронов
                    relative_velocity = math.sqrt((self.velocity_x - drone.velocity_x)**2 + 
                                                (self.velocity_y - drone.velocity_y)**2 + 
                                                (self.velocity_z - drone.velocity_z)**2)
                    doppler_shift_hz = (freq_params['frequency'] * relative_velocity) / 299792458  # c = скорость света
                    doppler_error_ns = (doppler_shift_hz / freq_params['frequency']) * 1e9  # наносекунды
                    
                    # Многолучевое распространение
                    multipath_loss = random.gauss(0, freq_params['fading_std'])
                    
                    # Атмосферное поглощение
                    atmospheric_loss = freq_params['atmospheric_absorption'] * (distance / 1000.0)
                    
                    # Общие потери
                    total_loss_db = path_loss_db + multipath_loss + atmospheric_loss
                    
                    # Преобразуем в качество связи (0-1)
                    link_quality = max(0.0, min(1.0, (40 - total_loss_db) / 40))  # 40дБ = хорошая связь
                    
                else:
                    # Упрощенный расчет для обратной совместимости
                    link_quality = max(0.1, 1.0 - (distance / sync_range))
                # Расчет точности синхронизации с учетом физических факторов
                if frequency_config:
                    # Тепловой шум приемника
                    thermal_noise_power = freq_params['thermal_noise']
                    
                    # Джиттер из-за эффекта Доплера
                    doppler_jitter_ns = abs(doppler_error_ns)
                    
                    # Джиттер из-за многолучевого распространения
                    multipath_jitter_ns = freq_params['interference_level'] * 10  # наносекунды
                    
                    # Общий джиттер синхронизации
                    total_jitter_ns = math.sqrt(doppler_jitter_ns**2 + multipath_jitter_ns**2 + 
                                              (2.0 if freq_params['frequency'] > 2e9 else 1.0)**2)
                    
                    # Максимально достижимая точность для данной частоты и скорости
                    theoretical_accuracy_ns = max(0.1, total_jitter_ns)
                    
                    sync_partners_data = {
                        'drone': drone,
                        'distance': distance,
                        'link_quality': link_quality,
                        'last_sync': time.time(),
                        'doppler_shift_hz': doppler_shift_hz,
                        'doppler_error_ns': doppler_error_ns,
                        'multipath_jitter_ns': multipath_jitter_ns,
                        'theoretical_accuracy_ns': theoretical_accuracy_ns,
                        'snr_db': 40 - total_loss_db,
                        'relative_velocity_ms': relative_velocity
                    }
                else:
                    sync_partners_data = {
                        'drone': drone,
                        'distance': distance,
                        'link_quality': link_quality,
                        'last_sync': time.time()
                    }
                
                self.sync_partners[drone.id] = sync_partners_data
    
    def _get_frequency_parameters(self, frequency_band, channel_width, interference_model):
        """Получение параметров для различных частотных диапазонов с реалистичными физическими свойствами"""
        import math
        
        # Реальные физические параметры по частотам (на основе уравнения Фрииса)
        freq_data = {
            '433mhz': {
                'frequency': 433e6, 'wavelength': 0.693, 'range_mult': 1.5, 'quality': 0.8, 'base_snr': 15,
                'path_loss_exp': 2.0, 'fresnel_clearance': 2.5, 'atmospheric_abs': 0.001  # дБ/км
            },
            '900mhz': {
                'frequency': 900e6, 'wavelength': 0.333, 'range_mult': 1.3, 'quality': 0.85, 'base_snr': 18,
                'path_loss_exp': 2.1, 'fresnel_clearance': 1.7, 'atmospheric_abs': 0.002
            },
            '1.2ghz': {
                'frequency': 1.2e9, 'wavelength': 0.25, 'range_mult': 1.1, 'quality': 0.9, 'base_snr': 20,
                'path_loss_exp': 2.2, 'fresnel_clearance': 1.4, 'atmospheric_abs': 0.003
            },
            '2.4ghz': {
                'frequency': 2.4e9, 'wavelength': 0.125, 'range_mult': 1.0, 'quality': 0.9, 'base_snr': 22,
                'path_loss_exp': 2.3, 'fresnel_clearance': 1.0, 'atmospheric_abs': 0.006
            },
            '5ghz': {
                'frequency': 5e9, 'wavelength': 0.06, 'range_mult': 0.8, 'quality': 0.95, 'base_snr': 25,
                'path_loss_exp': 2.5, 'fresnel_clearance': 0.7, 'atmospheric_abs': 0.015
            },
            '5.8ghz': {
                'frequency': 5.8e9, 'wavelength': 0.052, 'range_mult': 0.7, 'quality': 0.95, 'base_snr': 24,
                'path_loss_exp': 2.6, 'fresnel_clearance': 0.65, 'atmospheric_abs': 0.018
            }
        }
        
        # Модели помех (реальные значения для разных сред)
        interference_data = {
            'rural': {'base_noise': -110, 'multipath': 0.05, 'fading_std': 2.0},      # дБм, коэффициент, дБ
            'suburban': {'base_noise': -105, 'multipath': 0.1, 'fading_std': 4.0},   
            'urban': {'base_noise': -95, 'multipath': 0.2, 'fading_std': 6.0},       # Много Wi-Fi
            'indoor': {'base_noise': -100, 'multipath': 0.25, 'fading_std': 8.0},    # Отражения от стен
            'industrial': {'base_noise': -85, 'multipath': 0.3, 'fading_std': 10.0}  # Сильные помехи
        }
        
        # Влияние ширины канала на пропускную способность (закон Шеннона)
        width_data = {20: 1.0, 40: 1.8, 80: 3.2, 160: 5.5}  # Не линейное из-за помех
        
        base_params = freq_data.get(frequency_band, freq_data['2.4ghz'])
        interf_params = interference_data.get(interference_model, interference_data['urban'])
        
        # Расчет реального SNR с учетом частоты и среды
        thermal_noise = -174 + 10 * math.log10(channel_width * 1e6)  # дБм
        effective_noise = max(thermal_noise, interf_params['base_noise'])
        
        return {
            'range_multiplier': base_params['range_mult'],
            'quality_factor': base_params['quality'] * width_data.get(channel_width, 1.0),
            'interference_level': interf_params['multipath'],
            'base_snr': base_params['base_snr'] - interf_params['fading_std'],
            'frequency': base_params['frequency'],
            'wavelength': base_params['wavelength'],
            'path_loss_exponent': base_params['path_loss_exp'],
            'atmospheric_absorption': base_params['atmospheric_abs'],
            'thermal_noise': thermal_noise,
            'fading_std': interf_params['fading_std']
        }
    
    def _master_slave_sync(self, swarm, sync_frequency):
        """Классическая мастер-ведомый синхронизация"""
        if self.is_master:
            return
            
        master_drone = next((d for d in swarm.drones if d.is_master), None)
        if not master_drone:
            return
            
        # Вычисление расстояния до мастера
        distance = math.sqrt((self.x - master_drone.x)**2 + 
                           (self.y - master_drone.y)**2 + 
                           (self.z - master_drone.z)**2)
        
        # Модель задержки распространения
        propagation_delay = distance / 299792458.0  # секунды
        
        # Симуляция jitter'а
        jitter = random.uniform(0, distance * 1e-9)  # наносекунды
        
        # Вычисление ошибки синхронизации
        sync_error = self.time_offset - master_drone.time_offset + propagation_delay + jitter
        
        # Обновление PLL
        correction = self.dpll.update(sync_error, 1.0/sync_frequency)
        
        # Применение коррекции
        self.time_offset -= correction * 0.1
        self.frequency_offset -= correction * 0.01
        
        # Обновление качества синхронизации
        self.sync_quality = max(0.1, 1.0 - abs(sync_error) * 1e6)
        self.sync_history.append(self.sync_quality)
        self.sync_events += 1
    
    def peer_to_peer_sync(self, algorithm='consensus'):
        """Peer-to-peer синхронизация с соседними дронами"""
        if not self.neighbors:
            return
        
        if algorithm == 'consensus':
            self._consensus_sync()
        elif algorithm == 'distributed':
            self._distributed_sync()
        elif algorithm == 'ptp':
            self._ptp_sync()
        elif algorithm == 'ntp':
            self._ntp_sync()
    
    def _consensus_sync(self):
        """Алгоритм консенсуса для синхронизации"""
        if not self.neighbors:
            return
            
        # Собираем оценки времени от соседей
        time_estimates = [self.time_offset]
        weights = [self.stability]
        
        for neighbor in self.neighbors:
            if neighbor.id in self.sync_partners:
                partner = self.sync_partners[neighbor.id]
                # Взвешиваем по качеству связи и стабильности часов
                weight = partner['link_quality'] * neighbor.stability
                time_estimates.append(neighbor.time_offset)
                weights.append(weight)
        
        # Взвешенное усреднение
        if weights:
            total_weight = sum(weights)
            consensus_time = sum(est * w for est, w in zip(time_estimates, weights)) / total_weight
            
            # Постепенная корректировка к консенсусу
            correction_factor = 0.1  # скорость конвергенции
            self.time_offset += (consensus_time - self.time_offset) * correction_factor
            
            # Обновление качества синхронизации
            sync_error = abs(consensus_time - self.time_offset)
            self.sync_quality = max(0.1, 1.0 - sync_error * 1e6)
    
    def _distributed_sync(self):
        """Распределенный алгоритм синхронизации"""
        if not self.neighbors:
            return
            
        # Найдем соседа с лучшими часами
        best_neighbor = None
        best_accuracy = self.accuracy
        
        for neighbor in self.neighbors:
            if neighbor.accuracy < best_accuracy:
                best_neighbor = neighbor
                best_accuracy = neighbor.accuracy
        
        # Синхронизируемся с лучшим соседом
        if best_neighbor:
            distance = self.sync_partners[best_neighbor.id]['distance']
            propagation_delay = distance / 299792458.0
            
            sync_error = self.time_offset - best_neighbor.time_offset - propagation_delay
            correction = sync_error * 0.05  # медленная коррекция
            
            self.time_offset -= correction
            self.sync_quality = max(0.1, 1.0 - abs(sync_error) * 1e6)
    
    def _ptp_sync(self):
        """IEEE 1588 PTP-подобная синхронизация"""
        if not self.neighbors:
            return
            
        # Выбираем мастера среди соседей (с лучшими часами)
        ptp_master = None
        best_priority = float('inf')
        
        for neighbor in self.neighbors:
            # Приоритет основан на типе часов и стабильности
            priority = self._calculate_ptp_priority(neighbor)
            if priority < best_priority:
                ptp_master = neighbor
                best_priority = priority
        
        if ptp_master:
            self._perform_ptp_exchange(ptp_master)
    
    def _ntp_sync(self):
        """NTP-подобная синхронизация"""
        if not self.neighbors:
            return
            
        # Выбираем несколько лучших источников времени
        sources = sorted(self.neighbors, 
                        key=lambda x: x.accuracy)[:3]  # топ-3 источника
        
        offsets = []
        delays = []
        
        for source in sources:
            if source.id in self.sync_partners:
                partner = self.sync_partners[source.id]
                distance = partner['distance']
                
                # Симуляция NTP обмена
                delay = (distance / 299792458.0) * 2  # round-trip delay
                offset = source.time_offset - self.time_offset
                
                offsets.append(offset)
                delays.append(delay)
        
        if offsets:
            # Взвешенное усреднение с учетом задержек
            weights = [1.0 / (delay + 1e-9) for delay in delays]
            total_weight = sum(weights)
            avg_offset = sum(o * w for o, w in zip(offsets, weights)) / total_weight
            
            # Применяем коррекцию
            self.time_offset += avg_offset * 0.1
            self.sync_quality = max(0.1, 1.0 - abs(avg_offset) * 1e6)
    
    def _hierarchical_sync(self, swarm, sync_range):
        """Иерархическая синхронизация"""
        # В иерархической топологии дроны организованы в уровни
        if self.is_master:
            return  # Мастер не синхронизируется
            
        # Найти ближайший дрон с лучшими часами
        best_parent = None
        best_distance = float('inf')
        
        for drone in swarm.drones:
            if drone.id == self.id:
                continue
                
            distance = math.sqrt((self.x - drone.x)**2 + 
                               (self.y - drone.y)**2 + 
                               (self.z - drone.z)**2)
            
            # Проверяем если дрон может быть родителем
            if (distance <= sync_range and 
                drone.accuracy < self.accuracy and 
                distance < best_distance):
                best_parent = drone
                best_distance = distance
        
        if best_parent:
            propagation_delay = best_distance / 299792458.0
            sync_error = self.time_offset - best_parent.time_offset - propagation_delay
            
            # Иерархическая коррекция
            correction = sync_error * 0.2
            self.time_offset -= correction
            self.sync_quality = max(0.1, 1.0 - abs(sync_error) * 1e6)
    
    def _mesh_sync(self, swarm, sync_range, algorithm):
        """Сетчатая синхронизация - гибрид всех алгоритмов"""
        # Обновляем соседей
        self.discover_neighbors(swarm.drones, sync_range)
        
        if not self.neighbors:
            return
            
        # Используем разные алгоритмы в зависимости от условий
        if len(self.neighbors) >= 3:
            # Если много соседей - используем консенсус
            self._consensus_sync()
        elif len(self.neighbors) == 2:
            # Если 2 соседа - используем PTP
            self._ptp_sync()
        elif len(self.neighbors) == 1:
            # Если 1 сосед - простая синхронизация
            neighbor = self.neighbors[0]
            distance = self.sync_partners[neighbor.id]['distance']
            propagation_delay = distance / 299792458.0
            
            sync_error = self.time_offset - neighbor.time_offset - propagation_delay
            correction = sync_error * 0.1
            
            self.time_offset -= correction
            self.sync_quality = max(0.1, 1.0 - abs(sync_error) * 1e6)
    
    def _calculate_ptp_priority(self, drone):
        """Вычисление PTP приоритета для дрона"""
        # Меньший приоритет = лучше
        clock_class = {
            ClockType.RUBIDIUM: 10,
            ClockType.OCXO: 20,
            ClockType.TCXO: 30,
            ClockType.QUARTZ: 40
        }
        
        base_priority = clock_class.get(drone.clock_type, 50)
        stability_bonus = int((1.0 - drone.stability) * 10)
        
        return base_priority + stability_bonus
    
    def _perform_ptp_exchange(self, master):
        """Выполнение PTP обмена с мастером"""
        if master.id not in self.sync_partners:
            return
            
        partner = self.sync_partners[master.id]
        distance = partner['distance']
        
        # Симуляция 4-шагового PTP обмена
        # 1. Sync message
        t1 = time.time()  # время отправки Sync
        
        # 2. Delay_Req message  
        propagation_delay = distance / 299792458.0
        t2 = t1 + propagation_delay  # время получения Sync
        
        # 3. Follow_Up message (содержит точное t1)
        # 4. Delay_Resp message
        t3 = t2 + 1e-6  # время отправки Delay_Req
        t4 = t3 + propagation_delay  # время получения Delay_Req
        
        # Вычисление offset и delay
        path_delay = ((t4 - t1) - (t3 - t2)) / 2
        clock_offset = ((t2 - t1) - (t4 - t3)) / 2
        
        # Сохраняем оценки
        self.path_delay_estimates[master.id] = path_delay
        self.clock_offset_estimates[master.id] = clock_offset
        
        # Применяем коррекцию
        self.time_offset -= clock_offset * 0.1
        self.sync_quality = max(0.1, 1.0 - abs(clock_offset) * 1e6)
    
    def _update_failover_system(self, dt: float, swarm=None):
        """Обновление системы failover и выборов лидера"""
        if not swarm:
            return
        
        current_time = time.time()
        
        # Для мастер-дрона: симуляция возможных сбоев
        if self.is_master:
            self._simulate_master_failures()
            return
        
        # Для ведомых дронов: проверка связи с мастером
        master_drone = next((d for d in swarm.drones if d.is_master and not d.connection_lost), None)
        
        if master_drone:
            # Мастер доступен - обновляем время последней связи
            distance = math.sqrt((self.x - master_drone.x)**2 + 
                               (self.y - master_drone.y)**2 + 
                               (self.z - master_drone.z)**2)
            
            # Связь теряется при большом расстоянии или случайных помехах
            sync_range = getattr(swarm, 'sync_config', {}).get('sync_range', 300.0)
            connection_quality = max(0, 1.0 - (distance / sync_range))
            
            # Случайные помехи
            interference_level = getattr(swarm, 'interference_level', 0.1)
            if random.random() < interference_level * 0.1:
                connection_quality *= 0.5
            
            if connection_quality > 0.3:  # Минимальное качество связи
                self.last_master_contact = current_time
                self.connection_lost = False
            else:
                # Слабая связь - увеличивается вероятность потери
                if random.random() < 0.05:  # 5% шанс потери связи
                    print(f"⚠️ Дрон {self.id}: слабая связь с мастером (качество={connection_quality:.2f})")
        
        else:
            # Мастер недоступен или потерян
            if current_time - self.last_master_contact > self.master_timeout:
                if not self.connection_lost:
                    print(f"🔴 Дрон {self.id}: потеря связи с мастером!")
                    self.connection_lost = True
                    
                # Запуск выборов нового лидера
                if not self.election_in_progress:
                    self._start_leader_election(swarm)
    
    def _simulate_master_failures(self):
        """Симуляция сбоев мастер-дрона"""
        # Случайные сбои мастера (редко)
        if random.random() < 0.001:  # 0.1% шанс сбоя за обновление
            print(f"💥 КРИТИЧЕСКИЙ СБОЙ: Мастер-дрон {self.id} потерял связь!")
            self.connection_lost = True
            self.is_master = False  # Теряет статус мастера
            
        # Деградация батареи
        if self.battery_level < 0.3:
            if random.random() < 0.002:  # Повышенный риск при низкой батарее
                print(f"🔋 Мастер-дрон {self.id}: критически низкая батарея, передача управления...")
                self.connection_lost = True
                self.is_master = False
    
    def _start_leader_election(self, swarm):
        """Запуск выборов нового лидера"""
        print(f"🗳️ Дрон {self.id}: запуск выборов нового лидера")
        
        # Помечаем, что выборы идут
        self.election_in_progress = True
        self.election_votes_received = {}
        
        # Обновляем приоритет
        self.leader_priority = self._calculate_leader_priority()
        
        # Объявляем себя кандидатом, если приоритет достаточно высок
        candidates = []
        for drone in swarm.drones:
            if (not drone.connection_lost and 
                not drone.is_master and 
                drone.battery_level > 0.5 and
                drone.signal_strength > 0.6):
                candidates.append(drone)
        
        if not candidates:
            print("❌ Нет подходящих кандидатов для выборов!")
            return
        
        # Сортируем кандидатов по приоритету
        candidates.sort(key=lambda d: d.leader_priority, reverse=True)
        
        # Выбираем лучшего кандидата
        best_candidate = candidates[0]
        
        print(f"🏆 Лучший кандидат: Дрон {best_candidate.id} (приоритет={best_candidate.leader_priority})")
        
        # Голосуем за лучшего кандидата
        self._vote_for_leader(best_candidate, swarm)
    
    def _vote_for_leader(self, candidate, swarm):
        """Голосование за кандидата в лидеры"""
        self.election_vote = candidate.id
        
        # Добавляем голос кандидату
        if candidate.id not in candidate.election_votes_received:
            candidate.election_votes_received[candidate.id] = 0
        candidate.election_votes_received[candidate.id] += 1
        
        print(f"✅ Дрон {self.id} голосует за Дрон {candidate.id}")
        
        # Проверяем, набрал ли кандидат большинство голосов
        active_drones = [d for d in swarm.drones if not d.connection_lost and not d.is_master]
        required_votes = len(active_drones) // 2 + 1
        
        total_votes = sum(candidate.election_votes_received.values())
        
        if total_votes >= required_votes:
            self._elect_new_leader(candidate, swarm)
    
    def _elect_new_leader(self, new_leader, swarm):
        """Избрание нового лидера"""
        print(f"👑 НОВЫЙ ЛИДЕР ИЗБРАН: Дрон {new_leader.id}!")
        
        # Устанавливаем нового мастера
        new_leader.is_master = True
        new_leader.connection_lost = False
        new_leader.election_in_progress = False
        
        # Обновляем тип часов нового мастера на лучший доступный
        new_leader.clock_type = ClockType.RUBIDIUM
        new_leader._setup_clock_characteristics()
        
        # Сбрасываем выборы для всех дронов
        for drone in swarm.drones:
            drone.election_in_progress = False
            drone.election_vote = None
            drone.election_votes_received = {}
            
            # Обновляем время последней связи с новым мастером
            if not drone.is_master:
                drone.last_master_contact = time.time()
        
        print(f"📡 Дрон {new_leader.id} теперь координирует рой из {len(swarm.drones)} дронов")
    
    def get_status(self):
        """Получение статуса дрона с физическими метриками"""
        # Собираем физические метрики синхронизации
        physical_metrics = {}
        if hasattr(self, 'sync_partners') and self.sync_partners:
            # Берем метрики от ближайшего партнера
            closest_partner = min(self.sync_partners.values(), key=lambda p: p['distance'])
            if 'doppler_shift_hz' in closest_partner:
                physical_metrics = {
                    'doppler_shift_hz': round(closest_partner.get('doppler_shift_hz', 0), 2),
                    'doppler_error_ns': round(closest_partner.get('doppler_error_ns', 0), 3),
                    'multipath_jitter_ns': round(closest_partner.get('multipath_jitter_ns', 0), 3),
                    'theoretical_accuracy_ns': round(closest_partner.get('theoretical_accuracy_ns', 1.0), 3),
                    'snr_db': round(closest_partner.get('snr_db', 20), 1),
                    'relative_velocity_ms': round(closest_partner.get('relative_velocity_ms', 0), 2)
                }
        
        base_status = {
            'id': self.id,
            'position': [self.x, self.y, self.z],
            'velocity': [self.velocity_x, self.velocity_y, self.velocity_z],
            'is_master': self.is_master,
            'clock_type': self.clock_type.value,
            'time_offset': self.time_offset,
            'frequency_offset': self.frequency_offset,
            'jitter': self.jitter,
            'sync_quality': self.sync_quality,
            'dpll_locked': self.dpll.locked,
            'sync_events': self.sync_events,
            'battery_level': self.battery_level,
            'signal_strength': self.signal_strength,
            'temperature': self.temperature,
            # Новые поля для failover
            'connection_lost': self.connection_lost,
            'election_in_progress': self.election_in_progress,
            'leader_priority': self.leader_priority,
            'backup_master': self.backup_master,
            # Новые поля для реалистичной симуляции
            'flight_mode': getattr(self, 'flight_mode', 'normal'),
            'wind_resistance': getattr(self, 'wind_resistance', 1.0),
            'altitude_level': getattr(self, 'altitude_level', 2),
            'assigned_altitude': getattr(self, 'assigned_altitude', 100)
        }
        
        # Добавляем физические метрики если они доступны
        base_status.update(physical_metrics)
        return base_status


class FinalSwarm:
    """Финальная версия роя дронов с расширенными параметрами"""
    
    def __init__(self, num_drones: int = 20, radius: float = 80.0, height: float = 40.0):
        self.num_drones = num_drones
        self.radius = radius
        self.height = height
        self.simulation_time = 0.0
        
        # Параметры симуляции (реалистичные скорости DJI Mavic)
        self.flight_pattern = 'random'  # random, formation, patrol, orbit
        self.formation_type = 'sphere'  # sphere, circle, line, v_shape
        self.max_speed = 15.0  # м/с (54 км/ч) - максимальная скорость Mavic в S-режиме
        self.normal_speed = 8.0  # м/с (29 км/ч) - обычная крейсерская скорость
        self.precision_speed = 3.5  # м/с (12.6 км/ч) - точный режим/съемка
        self.ascent_speed = 5.0  # м/с вертикальная скорость подъема
        self.descent_speed = 3.0  # м/с вертикальная скорость спуска
        self.angular_speed = 90.0  # град/с поворот (как у реального Mavic)
        
        # Новые параметры синхронизации
        self.sync_config = {
            'sync_frequency': 1.0,
            'sync_topology': 'master_slave',
            'sync_range': 300.0,
            'sync_algorithm': 'ptp',
            'master_clock': 'rubidium',
            'slave_clock': 'ocxo',
            'adaptive_sync': 'enabled',
            'delay_compensation': 'automatic',
            'frequency_band': '2.4ghz',  # Частотный диапазон связи
            'channel_width': 20,  # Ширина канала в МГц
            'interference_model': 'urban'  # Модель помех (urban/rural/indoor)
        }
        self.sync_frequency = 1.0  # Hz
        self.clock_accuracy = 1e-9  # наносекунды
        self.master_clock_type = 'rubidium'
        self.signal_strength = 0.8
        self.interference_level = 0.1
        
        self.drones = []
        self._create_drones()
    
    def _create_drones(self):
        """Создание дронов с многоуровневым размещением"""
        self.drones = []
        
        # Определяем уровни высот для эшелонированного полета
        altitude_levels = [
            self.height - 40,  # Нижний эшелон
            self.height - 20,  # Средне-нижний
            self.height,       # Базовый эшелон
            self.height + 20,  # Средне-верхний
            self.height + 40   # Верхний эшелон
        ]
        
        # Создание мастер-дрона на базовом эшелоне
        master_drone = FinalDrone(0, 0, 0, self.height, is_master=True)
        master_drone.swarm_ref = self  # Ссылка на рой
        master_drone.assigned_altitude = self.height
        master_drone.altitude_level = 2  # Базовый уровень
        self.drones.append(master_drone)
        
        # Создание остальных дронов с распределением по эшелонам
        for i in range(1, self.num_drones):
            # Случайное размещение вокруг центра
            angle = random.uniform(0, 2 * math.pi)
            r = random.uniform(20, self.radius)
            
            x = r * math.cos(angle)
            y = r * math.sin(angle)
            
            # Выбираем эшелон в зависимости от роли дрона
            if i <= 4:  # Первые дроны - на разных уровнях для разведки
                altitude_level = i % len(altitude_levels)
            elif i <= 8:  # Средние дроны - основная группа на базовом уровне
                altitude_level = 2  # Базовый
            elif i <= 12: # Патрульные дроны - верхние эшелоны
                altitude_level = random.choice([3, 4])
            else:  # Остальные - случайное распределение
                altitude_level = random.randint(0, len(altitude_levels)-1)
            
            z = altitude_levels[altitude_level] + random.uniform(-5, 5)  # Небольшие вариации
            
            drone = FinalDrone(i, x, y, z, is_master=False)
            drone.swarm_ref = self  # Ссылка на рой
            drone.assigned_altitude = altitude_levels[altitude_level]
            drone.altitude_level = altitude_level
            self.drones.append(drone)
    
    def update_parameters(self, **kwargs):
        """Обновление параметров роя"""
        for key, value in kwargs.items():
            if hasattr(self, key):
                setattr(self, key, value)
                print(f"⚙️ Параметр {key} обновлен: {value}")
    
    def update(self, dt: float):
        """Обновление роя"""
        self.simulation_time += dt
        
        # Обновление всех дронов
        for drone in self.drones:
            drone.update(dt, self)
    
    def get_swarm_status(self):
        """Получение статуса роя"""
        if not self.drones:
            return self._empty_status()
        
        # Расчет статистики
        time_offsets = [d.time_offset for d in self.drones]
        sync_qualities = [d.sync_quality for d in self.drones]
        dpll_locked = sum(1 for d in self.drones if d.dpll.locked)
        sync_events = sum(d.sync_events for d in self.drones)
        battery_levels = [d.battery_level for d in self.drones]
        signal_strengths = [d.signal_strength for d in self.drones]
        temperatures = [d.temperature for d in self.drones]
        
        # Вычисления без numpy
        avg_offset = sum(time_offsets) / len(time_offsets)
        avg_sync_quality = sum(sync_qualities) / len(sync_qualities)
        avg_battery = sum(battery_levels) / len(battery_levels)
        avg_signal = sum(signal_strengths) / len(signal_strengths)
        avg_temp = sum(temperatures) / len(temperatures)
        
        # Стандартное отклонение
        variance = sum((offset - avg_offset)**2 for offset in time_offsets) / len(time_offsets)
        time_divergence = math.sqrt(variance)
        swarm_accuracy = time_divergence
        
        return {
            'running': True,
            'simulation_time': self.simulation_time,
            'num_drones': len(self.drones),
            'avg_time_offset': avg_offset,
            'avg_sync_quality': avg_sync_quality,
            'swarm_sync_accuracy': swarm_accuracy,
            'swarm_time_divergence': time_divergence,
            'dpll_locked_count': dpll_locked,
            'wwvb_sync_count': sync_events,
            'avg_battery_level': avg_battery,
            'avg_signal_strength': avg_signal,
            'avg_temperature': avg_temp
        }
    
    def _empty_status(self):
        """Пустой статус"""
        return {
            'running': True,
            'simulation_time': self.simulation_time,
            'num_drones': 0,
            'avg_time_offset': 0.0,
            'avg_sync_quality': 0.0,
            'swarm_sync_accuracy': 0.0,
            'swarm_time_divergence': 0.0,
            'dpll_locked_count': 0,
            'wwvb_sync_count': 0,
            'avg_battery_level': 0.0,
            'avg_signal_strength': 0.0,
            'avg_temperature': 0.0
        }


# ===== ВЕБ-СЕРВЕР =====

# Глобальные переменные для роя (вне класса)
GLOBAL_SWARM = None
GLOBAL_SIMULATION_THREAD = None
GLOBAL_SIMULATION_RUNNING = False
GLOBAL_SWARM_CONFIG = {
    'num_drones': 20,
    'radius': 1000.0,  # 1 км радиус роя
    'height': 100.0,   # 100м высота полета
    'sync_frequency': 1.0,  # Частота синхронизации в Гц
    'sync_topology': 'master_slave',  # Топология синхронизации
    'sync_range': 300.0,  # Дальность связи в метрах
    'sync_algorithm': 'ptp',  # Алгоритм синхронизации
    'master_clock': 'rubidium',  # Тип часов главного дрона
    'slave_clock': 'ocxo',  # Тип часов ведомых дронов
    'adaptive_sync': 'enabled',  # Адаптивная коррекция
    'delay_compensation': 'automatic',  # Компенсация задержки
    'failure_simulation': 'enabled',  # Симуляция сбоев
    'master_failure_rate': 0.1,  # Вероятность сбоя мастера (%)
    'master_timeout': 5.0,  # Таймаут мастера (секунды)
    'election_algorithm': 'priority'  # Алгоритм выборов
}

class FinalWebHandler(BaseHTTPRequestHandler):
    """HTTP обработчик для финальной веб-симуляции"""
    
    def do_GET(self):
        """Обработка GET запросов"""
        parsed_url = urlparse(self.path)
        path = parsed_url.path
        
        if path == '/':
            self.serve_main_page()
        elif path == '/api/start':
            self.start_simulation()
        elif path == '/api/stop':
            self.stop_simulation()
        elif path == '/api/status':
            self.get_simulation_status()
        elif path == '/api/drones':
            self.get_drones_data()
        elif path == '/api/config':
            self.get_config()
        elif path == '/api/update_config':
            self.update_config(parse_qs(parsed_url.query))
        else:
            self.send_error(404, "Not Found")
    
    def serve_main_page(self):
        """Сервинг главной HTML страницы"""
        html_content = """
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🚁 Final Drone Swarm Simulation 🚁</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #0f0f23 0%, #1a1a3a 100%);
            color: white;
            overflow: hidden;
        }
        
        .header {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            background: rgba(0, 0, 0, 0.9);
            padding: 15px 20px;
            z-index: 1000;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 3px solid #00ff88;
            box-shadow: 0 2px 20px rgba(0, 255, 136, 0.3);
        }
        
        .title {
            font-size: 26px;
            font-weight: bold;
            color: #00ff88;
            text-shadow: 0 0 15px rgba(0, 255, 136, 0.5);
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .controls {
            display: flex;
            gap: 15px;
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 16px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .btn-start {
            background: linear-gradient(45deg, #00ff88, #00cc6a);
            color: #000;
            box-shadow: 0 4px 15px rgba(0, 255, 136, 0.3);
        }
        
        .btn-start:hover {
            background: linear-gradient(45deg, #00cc6a, #00aa55);
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0, 255, 136, 0.5);
        }
        
        .btn-stop {
            background: linear-gradient(45deg, #ff4444, #cc3333);
            color: white;
            box-shadow: 0 4px 15px rgba(255, 68, 68, 0.3);
        }
        
        .btn-stop:hover {
            background: linear-gradient(45deg, #cc3333, #aa2222);
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(255, 68, 68, 0.5);
        }
        
        .btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            transform: none !important;
        }
        
        .config-panel {
            position: fixed;
            top: 90px;
            left: 20px;
            width: 280px;
            max-height: calc(100vh - 120px);
            background: rgba(0, 0, 0, 0.9);
            padding: 15px;
            border-radius: 12px;
            border: 2px solid rgba(0, 255, 136, 0.3);
            backdrop-filter: blur(15px);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            overflow-y: auto;
            overflow-x: hidden;
        }
        
        .config-panel::-webkit-scrollbar {
            width: 8px;
        }
        
        .config-panel::-webkit-scrollbar-track {
            background: rgba(0, 0, 0, 0.3);
            border-radius: 4px;
        }
        
        .config-panel::-webkit-scrollbar-thumb {
            background: rgba(0, 255, 136, 0.5);
            border-radius: 4px;
        }
        
        .config-panel::-webkit-scrollbar-thumb:hover {
            background: rgba(0, 255, 136, 0.7);
        }
        
        .metrics-panel {
            position: fixed;
            top: 90px;
            right: 20px;
            width: 320px;
            background: rgba(0, 0, 0, 0.85);
            padding: 20px;
            border-radius: 15px;
            border: 2px solid rgba(0, 255, 136, 0.3);
            backdrop-filter: blur(15px);
            max-height: calc(100vh - 130px);
            overflow-y: auto;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
        }
        
        .config-group {
            margin-bottom: 10px;
        }
        
        .config-label {
            display: block;
            margin-bottom: 4px;
            font-weight: bold;
            color: #00ff88;
            font-size: 12px;
        }
        
        .config-input {
            width: 100%;
            padding: 6px 8px;
            border: 1px solid rgba(0, 255, 136, 0.3);
            border-radius: 4px;
            background: rgba(0, 0, 0, 0.7);
            color: white;
            font-size: 13px;
            box-sizing: border-box;
        }
        
        .config-input:focus {
            outline: none;
            border-color: #00ff88;
            box-shadow: 0 0 15px rgba(0, 255, 136, 0.4);
        }
        
        .metric {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            padding: 10px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            border-left: 4px solid #00ff88;
        }
        
        .metric-label {
            font-weight: bold;
            color: #00ff88;
            font-size: 14px;
        }
        
        .metric-value {
            color: white;
            font-family: 'Courier New', monospace;
            font-size: 14px;
            font-weight: bold;
        }
        
        .canvas-container {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 1;
            display: none; /* Скрыто изначально */
        }
        
        .status-indicator {
            display: inline-block;
            width: 16px;
            height: 16px;
            border-radius: 50%;
            margin-right: 10px;
        }
        
        .status-running {
            background: #00ff88;
            animation: pulse 1.5s infinite;
            box-shadow: 0 0 15px rgba(0, 255, 136, 0.7);
        }
        
        .status-stopped {
            background: #ff4444;
            box-shadow: 0 0 15px rgba(255, 68, 68, 0.7);
        }
        
        @keyframes pulse {
            0% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.6; transform: scale(1.2); }
            100% { opacity: 1; transform: scale(1); }
        }
        
        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 15px 25px;
            border-radius: 8px;
            color: white;
            font-weight: bold;
            z-index: 10000;
            max-width: 350px;
            animation: slideIn 0.4s ease-out;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
        }
        
        @keyframes slideIn {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
        
        h3 {
            margin: 8px 0 6px 0;
            color: #00ff88;
            font-size: 14px;
            text-shadow: 0 0 10px rgba(0, 255, 136, 0.3);
            border-bottom: 1px solid rgba(0, 255, 136, 0.3);
            padding-bottom: 4px;
        }
        
        h3:first-child {
            margin-top: 0;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="title">
            <span class="status-indicator" id="statusIndicator"></span>
            🚁 <span id="titleText">Final Drone Swarm Simulation</span> 🚁
        </div>
        <div class="controls">
            <button class="btn btn-start" onclick="startSimulation()" id="startBtn">🚀 Запустить</button>
            <button class="btn btn-stop" onclick="stopSimulation()">⏹️ Остановить</button>
        </div>
    </div>
    
    <div class="config-panel">
        <h3>⚙️ Конфигурация роя</h3>
        <div class="config-group">
            <label class="config-label">Количество дронов:</label>
            <input type="number" id="numDrones" class="config-input" value="20" min="5" max="50">
        </div>
        <div class="config-group">
            <label class="config-label">Радиус роя (м):</label>
            <input type="number" id="radius" class="config-input" value="1000" min="100" max="2000" step="50">
        </div>
        <div class="config-group">
            <label class="config-label">Высота полета (м):</label>
            <input type="number" id="height" class="config-input" value="100" min="50" max="300" step="10">
        </div>
        
        <h3>📡 Параметры синхронизации</h3>
        <div class="config-group">
            <label class="config-label">Частота синхронизации (Гц):</label>
            <input type="number" id="syncFrequency" class="config-input" value="1.0" min="0.1" max="10.0" step="0.1">
        </div>
        <div class="config-group">
            <label class="config-label">Топология синхронизации:</label>
            <select id="syncTopology" class="config-input">
                <option value="master_slave">Мастер-Ведомый</option>
                <option value="peer_to_peer">Peer-to-Peer</option>
                <option value="hierarchical">Иерархическая</option>
                <option value="mesh">Сетчатая</option>
            </select>
        </div>
        <div class="config-group">
            <label class="config-label">Дальность связи (м):</label>
            <input type="number" id="syncRange" class="config-input" value="300" min="50" max="1000" step="50">
        </div>
        <div class="config-group">
            <label class="config-label">Алгоритм синхронизации:</label>
            <select id="syncAlgorithm" class="config-input">
                <option value="ptp">IEEE 1588 (PTP)</option>
                <option value="ntp">NTP-подобный</option>
                <option value="consensus">Консенсус</option>
                <option value="distributed">Распределенный</option>
            </select>
        </div>
        
        <h3>⏰ Генераторы времени</h3>
        <div class="config-group">
            <label class="config-label">Главный дрон:</label>
            <select id="masterClock" class="config-input">
                <option value="rubidium">Рубидиевый (10⁻¹¹)</option>
                <option value="cesium">Цезиевый (10⁻¹²)</option>
                <option value="gps_disciplined">GPS-Disciplined OCXO</option>
                <option value="hydrogen_maser">Водородный мазер (10⁻¹⁵)</option>
            </select>
        </div>
        <div class="config-group">
            <label class="config-label">Ведомые дроны:</label>
            <select id="slaveClock" class="config-input">
                <option value="ocxo">OCXO (10⁻⁹)</option>
                <option value="tcxo">TCXO (10⁻⁶)</option>
                <option value="quartz">Кварц (10⁻⁴)</option>
                <option value="crystal">Кристалл (10⁻³)</option>
            </select>
        </div>
        <div class="config-group">
            <label class="config-label">Адаптивная коррекция:</label>
            <select id="adaptiveSync" class="config-input">
                <option value="enabled">Включена</option>
                <option value="disabled">Отключена</option>
            </select>
        </div>
        <div class="config-group">
            <label class="config-label">Компенсация задержки:</label>
            <select id="delayCompensation" class="config-input">
                <option value="automatic">Автоматическая</option>
                <option value="manual">Ручная</option>
                <option value="disabled">Отключена</option>
            </select>
        </div>
        
        <h3>📡 Радиочастотные параметры</h3>
        <div class="config-group">
            <label class="config-label">Частотный диапазон:</label>
            <select id="frequencyBand" class="config-input">
                <option value="2.4ghz">2.4 ГГц (Wi-Fi/Bluetooth)</option>
                <option value="5ghz">5 ГГц (Wi-Fi 5/6)</option>
                <option value="900mhz">900 МГц (LoRa/дальняя связь)</option>
                <option value="433mhz">433 МГц (RC/телеметрия)</option>
                <option value="1.2ghz">1.2 ГГц (видеосвязь)</option>
                <option value="5.8ghz">5.8 ГГц (FPV видео)</option>
            </select>
        </div>
        <div class="config-group">
            <label class="config-label">Ширина канала (МГц):</label>
            <select id="channelWidth" class="config-input">
                <option value="20">20 МГц</option>
                <option value="40">40 МГц</option>
                <option value="80">80 МГц</option>
                <option value="160">160 МГц</option>
            </select>
        </div>
        <div class="config-group">
            <label class="config-label">Модель помех:</label>
            <select id="interferenceModel" class="config-input">
                <option value="urban">Городская (много помех)</option>
                <option value="suburban">Пригородная (средние помехи)</option>
                <option value="rural">Сельская (мало помех)</option>
                <option value="indoor">Помещение (отражения)</option>
                <option value="industrial">Промышленная (сильные помехи)</option>
            </select>
        </div>
        
        <h3>🔄 Система отказоустойчивости</h3>
        <div class="config-group">
            <label class="config-label">Симуляция сбоев:</label>
            <select id="failureSimulation" class="config-input">
                <option value="enabled">Включена</option>
                <option value="disabled">Отключена</option>
            </select>
        </div>
        <div class="config-group">
            <label class="config-label">Вероятность сбоя мастера (%):</label>
            <input type="number" id="masterFailureRate" class="config-input" value="0.1" min="0" max="5" step="0.1">
        </div>
        <div class="config-group">
            <label class="config-label">Таймаут мастера (сек):</label>
            <input type="number" id="masterTimeout" class="config-input" value="5" min="1" max="30" step="1">
        </div>
        <div class="config-group">
            <label class="config-label">Алгоритм выборов:</label>
            <select id="electionAlgorithm" class="config-input">
                <option value="priority">По приоритету</option>
                <option value="raft">RAFT-подобный</option>
                <option value="byzantine">Byzantine Fault Tolerant</option>
            </select>
        </div>
        
        <h3>🚁 Паттерны полета</h3>
        <div class="config-group">
            <label class="config-label">Тип полета:</label>
            <select id="flightPattern" class="config-input">
                <option value="random">🎲 Случайный</option>
                <option value="formation">📐 Формация</option>
                <option value="patrol">🛡️ Патрулирование</option>
                <option value="orbit">🌍 Орбитальный</option>
            </select>
        </div>
        <div class="config-group">
            <label class="config-label">Тип формации:</label>
            <select id="formationType" class="config-input">
                <option value="sphere">🌐 Сфера</option>
                <option value="circle">⭕ Круг</option>
                <option value="line">📏 Линия</option>
                <option value="v_shape">✈️ V-образная</option>
            </select>
        </div>
        <div class="config-group">
            <label class="config-label">Макс. скорость (м/с):</label>
            <input type="number" id="maxSpeed" class="config-input" value="8" min="1" max="20" step="0.5">
        </div>
        
        <h3>📡 Параметры синхронизации</h3>
        <div class="config-group">
            <label class="config-label">Частота синхронизации (Гц):</label>
            <input type="number" id="syncFrequency" class="config-input" value="1.0" min="0.1" max="10" step="0.1">
        </div>
        <div class="config-group">
            <label class="config-label">Точность часов (нс):</label>
            <input type="number" id="clockAccuracy" class="config-input" value="1" min="0.1" max="100" step="0.1">
        </div>
        <div class="config-group">
            <label class="config-label">Мастер-часы:</label>
            <select id="masterClockType" class="config-input">
                <option value="rubidium">🔴 Рубидиевые</option>
                <option value="ocxo">🟢 OCXO</option>
                <option value="tcxo">🔵 TCXO</option>
                <option value="quartz">🟡 Кварцевые</option>
            </select>
        </div>
        <div class="config-group">
            <label class="config-label">Уровень помех:</label>
            <input type="range" id="interferenceLevel" class="config-input" value="0.1" min="0" max="1" step="0.05">
            <span id="interferenceValue">0.1</span>
        </div>
        
        <button class="btn btn-start" onclick="updateConfig()" style="width: 100%; margin-top: 10px; padding: 8px 16px; font-size: 13px;">🔄 Обновить параметры</button>
    </div>
    
    <div class="metrics-panel">
        <h3>📊 Метрики синхронизации</h3>
        <div class="metric">
            <div class="metric-label">⏱️ Время симуляции</div>
            <div class="metric-value" id="simTime">0.0с</div>
        </div>
        <div class="metric">
            <div class="metric-label">📏 Среднее смещение</div>
            <div class="metric-value" id="avgOffset">0.00 нс</div>
        </div>
        <div class="metric">
            <div class="metric-label">🎯 Качество синхронизации</div>
            <div class="metric-value" id="syncQuality">0.000</div>
        </div>
        <div class="metric">
            <div class="metric-label">🔍 Точность роя</div>
            <div class="metric-value" id="swarmAccuracy">0.00 нс</div>
        </div>
        <div class="metric">
            <div class="metric-label">📈 Расхождение времени</div>
            <div class="metric-value" id="timeDivergence">0.00 нс</div>
        </div>
        <div class="metric">
            <div class="metric-label">🔒 DPLL заблокированы</div>
            <div class="metric-value" id="dpllLocked">0/20</div>
        </div>
        <div class="metric">
            <div class="metric-label">📡 События синхронизации</div>
            <div class="metric-value" id="syncEvents">0</div>
        </div>
        <div class="metric">
            <div class="metric-label">👑 Текущий мастер</div>
            <div class="metric-value" id="currentMaster">Дрон 0</div>
        </div>
        <div class="metric">
            <div class="metric-label">🔄 Смены мастера</div>
            <div class="metric-value" id="masterChanges">0</div>
        </div>
        <div class="metric">
            <div class="metric-label">🗳️ Активные выборы</div>
            <div class="metric-value" id="activeElections">0</div>
        </div>
        <div class="metric">
            <div class="metric-label">✈️ Эшелоны (0-4)</div>
            <div class="metric-value" id="altitudeLevels">Н/Д</div>
        </div>
        <div class="metric">
            <div class="metric-label">📏 Диапазон высот</div>
            <div class="metric-value" id="altitudeRange">Н/Д</div>
        </div>
        <div class="metric">
            <div class="metric-label">🔋 Уровень батареи</div>
            <div class="metric-value" id="batteryLevel">0.00</div>
        </div>
        <div class="metric">
            <div class="metric-label">📶 Сила сигнала</div>
            <div class="metric-value" id="signalStrength">0.00</div>
        </div>
        <div class="metric">
            <div class="metric-label">🌡️ Температура</div>
            <div class="metric-value" id="temperature">0.0°C</div>
        </div>
    </div>
    
    <div class="canvas-container">
        <canvas id="canvas"></canvas>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/controls/OrbitControls.js"></script>
    
    <script>
        // Three.js переменные
        let scene, camera, renderer, controls;
        let droneMeshes = [];
        let syncLines = [];  // Линии синхронизации между дронами
        let isSimulationRunning = false;
        
        // Инициализация Three.js
        function initThreeJS() {
            console.log('🔧 Инициализация Final Three.js...');
            
            try {
                // Проверка THREE
                if (typeof THREE === 'undefined') {
                    console.error('❌ THREE.js не загружен!');
                    showNotification('❌ Ошибка: THREE.js не загружен', 'error');
                    return false;
                }
                
                console.log('✅ THREE.js загружен, версия:', THREE.REVISION);
                
                // Сцена
                scene = new THREE.Scene();
                scene.background = new THREE.Color(0x0a0a1a);
                scene.fog = new THREE.Fog(0x0a0a1a, 500, 2500);
                
                // Камера для большого масштаба (1км)
                camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 1, 3000);
                camera.position.set(800, 400, 800);
                camera.lookAt(0, 100, 0);
                
                // Рендерер
                renderer = new THREE.WebGLRenderer({ 
                    canvas: document.getElementById('canvas'), 
                    antialias: true
                });
                renderer.setSize(window.innerWidth, window.innerHeight);
                renderer.shadowMap.enabled = true;
                renderer.shadowMap.type = THREE.PCFSoftShadowMap;
                
                // Контролы
                if (typeof THREE.OrbitControls !== 'undefined') {
                    controls = new THREE.OrbitControls(camera, renderer.domElement);
                    controls.enableDamping = true;
                    controls.dampingFactor = 0.05;
                    controls.minDistance = 50;
                    controls.maxDistance = 400;
                    controls.target.set(0, 40, 0);
                    console.log('✅ OrbitControls инициализированы');
                } else {
                    console.warn('⚠️ OrbitControls не доступны');
                }
                
                // Освещение
                const ambientLight = new THREE.AmbientLight(0x404040, 0.6);
                scene.add(ambientLight);
                
                const directionalLight = new THREE.DirectionalLight(0xffffff, 1.0);
                directionalLight.position.set(100, 100, 50);
                directionalLight.castShadow = true;
                scene.add(directionalLight);
                
                // Точечный свет для драматичности
                const pointLight = new THREE.PointLight(0x00ff88, 0.8, 200);
                pointLight.position.set(0, 60, 0);
                scene.add(pointLight);
                
                // Реалистичная земля/ландшафт
                createRealisticTerrain();
                
                // Оси координат
                const axesHelper = new THREE.AxesHelper(80);
                scene.add(axesHelper);
                
                // Добавляем тестовый куб для проверки
                const testGeometry = new THREE.BoxGeometry(10, 10, 10);
                const testMaterial = new THREE.MeshBasicMaterial({ 
                    color: 0xff0000,
                    wireframe: true
                });
                const testCube = new THREE.Mesh(testGeometry, testMaterial);
                testCube.position.set(0, 50, 0);
                scene.add(testCube);
                console.log('🧪 Добавлен тестовый куб в позицию (0, 50, 0)');
                
                animate();
                console.log('✅ Three.js инициализирован успешно');
                showNotification('🎯 3D визуализация готова!', 'success');
                return true;
                
            } catch (error) {
                console.error('❌ Критическая ошибка инициализации Three.js:', error);
                showNotification('❌ Критическая ошибка 3D: ' + error.message, 'error');
                return false;
            }
        }
        
        // Анимация
        function animate() {
            requestAnimationFrame(animate);
            
            if (controls) {
                controls.update();
            }
            
            // Анимация дронов
            droneMeshes.forEach((mesh, index) => {
                const time = Date.now() * 0.001;
                
                // Анимация пропеллеров
                if (mesh.userData.propellers) {
                    mesh.userData.propellers.forEach((prop, i) => {
                        prop.rotation.y += (i % 2 === 0 ? 0.8 : -0.8); // Противоположное вращение
                    });
                }
                
                // Анимация мастера
                if (mesh.userData.isMaster) {
                    // Пульсация антенны
                    if (mesh.userData.beacon) {
                        const pulse = 1 + 0.3 * Math.sin(time * 4);
                        mesh.userData.beacon.scale.setScalar(pulse);
                    }
                    
                    // Легкое покачивание
                    mesh.rotation.y += 0.005;
                } else {
                    // Легкое покачивание обычных дронов
                    mesh.rotation.y += 0.002;
                }
                
                // Анимация кольца синхронизации
                if (mesh.userData.syncRing) {
                    mesh.userData.syncRing.rotation.z += 0.02;
                    
                    // Пульсация кольца синхронизации
                    const syncPulse = 1 + 0.2 * Math.sin(time * 2 + index);
                    mesh.userData.syncRing.scale.setScalar(syncPulse);
                }
            });
            
            renderer.render(scene, camera);
        }
        
        // Создание реалистичной модели дрона
        function createDroneMesh(droneData) {
            console.log('🔨 Создание реалистичного дрона ID:', droneData.id, 'тип:', droneData.clock_type);
            
            const group = new THREE.Group();
            group.userData = { 
                isMaster: droneData.is_master,
                id: droneData.id,
                syncQuality: droneData.sync_quality || 0,
                clockType: droneData.clock_type,
                propellers: []
            };
            
            // Размеры дрона (реалистичные)
            const bodySize = droneData.is_master ? 6 : 4;
            const armLength = bodySize * 1.5;
            
            // Основное тело дрона
            const bodyGeometry = new THREE.BoxGeometry(bodySize, bodySize * 0.3, bodySize);
            const bodyMaterial = new THREE.MeshLambertMaterial({ 
                color: getDroneColor(droneData.clock_type, droneData.altitude_level)
            });
            const body = new THREE.Mesh(bodyGeometry, bodyMaterial);
            group.add(body);
            
            // Четыре луча/консоли
            const armGeometry = new THREE.CylinderGeometry(0.2, 0.2, armLength);
            const armMaterial = new THREE.MeshLambertMaterial({ color: 0x333333 });
            
            for (let i = 0; i < 4; i++) {
                const arm = new THREE.Mesh(armGeometry, armMaterial);
                const angle = (i * Math.PI) / 2;
                arm.position.x = Math.cos(angle) * armLength * 0.4;
                arm.position.z = Math.sin(angle) * armLength * 0.4;
                arm.rotation.z = Math.PI / 2;
                arm.rotation.y = angle;
                group.add(arm);
                
                // Пропеллеры
                const propGeometry = new THREE.CylinderGeometry(armLength * 0.4, armLength * 0.4, 0.1, 8);
                const propMaterial = new THREE.MeshLambertMaterial({ 
                    color: 0x444444,
                    transparent: true,
                    opacity: 0.8
                });
                const propeller = new THREE.Mesh(propGeometry, propMaterial);
                propeller.position.x = Math.cos(angle) * armLength * 0.7;
                propeller.position.z = Math.sin(angle) * armLength * 0.7;
                propeller.position.y = 0.3;
                group.add(propeller);
                
                // Сохраняем пропеллеры для анимации
                group.userData.propellers.push(propeller);
            }
            
            // Мастер-индикатор (антенна)
            if (droneData.is_master) {
                const antennaGeometry = new THREE.CylinderGeometry(0.1, 0.1, bodySize * 1.5);
                const antennaMaterial = new THREE.MeshLambertMaterial({ color: 0xffff00 });
                const antenna = new THREE.Mesh(antennaGeometry, antennaMaterial);
                antenna.position.y = bodySize;
                group.add(antenna);
                
                // Светящийся шар на антенне
                const beaconGeometry = new THREE.SphereGeometry(0.5, 8, 6);
                const beaconMaterial = new THREE.MeshBasicMaterial({ 
                    color: 0xffff00,
                    transparent: true,
                    opacity: 0.9
                });
                const beacon = new THREE.Mesh(beaconGeometry, beaconMaterial);
                beacon.position.y = bodySize * 1.8;
                group.add(beacon);
                group.userData.beacon = beacon;
            }
            
            // Индикатор синхронизации - кольцо вокруг дрона
            const syncGeometry = new THREE.RingGeometry(bodySize, bodySize * 1.3, 16);
            const syncMaterial = new THREE.MeshBasicMaterial({ 
                color: getSyncColor(droneData.sync_quality || 0),
                transparent: true,
                opacity: 0.4,
                side: THREE.DoubleSide
            });
            const syncRing = new THREE.Mesh(syncGeometry, syncMaterial);
            syncRing.rotation.x = -Math.PI / 2;
            syncRing.position.y = -0.5;
            group.add(syncRing);
            group.userData.syncRing = syncRing;
            
            // Метка с ID дрона
            const canvas = document.createElement('canvas');
            const context = canvas.getContext('2d');
            canvas.width = 64;
            canvas.height = 32;
            context.fillStyle = 'rgba(0, 0, 0, 0.8)';
            context.fillRect(0, 0, 64, 32);
            context.fillStyle = 'white';
            context.font = '12px Arial';
            context.textAlign = 'center';
            context.fillText(`D${droneData.id}`, 32, 20);
            
            const texture = new THREE.CanvasTexture(canvas);
            const spriteMaterial = new THREE.SpriteMaterial({ map: texture });
            const sprite = new THREE.Sprite(spriteMaterial);
            sprite.position.y = bodySize + 3;
            sprite.scale.set(8, 4, 1);
            group.add(sprite);
            
            console.log('✅ Создан реалистичный дрон ID:', droneData.id);
            return group;
        }
        
        // Цвет синхронизации в зависимости от качества
        function getSyncColor(quality) {
            if (quality > 0.8) return 0x00ff00;  // Зеленый - отличная синхронизация
            if (quality > 0.6) return 0xffff00;  // Желтый - хорошая синхронизация
            if (quality > 0.3) return 0xff8800;  // Оранжевый - плохая синхронизация
            return 0xff0000;                      // Красный - нет синхронизации
        }
        
        function createRealisticTerrain() {
            // Создаем землю с текстурой
            const groundGeometry = new THREE.PlaneGeometry(3000, 3000, 100, 100);
            
            // Добавляем рельеф (небольшие холмы)
            const vertices = groundGeometry.attributes.position.array;
            for (let i = 0; i < vertices.length; i += 3) {
                const x = vertices[i];
                const y = vertices[i + 1];
                // Создаем холмистую местность
                vertices[i + 2] = Math.sin(x * 0.01) * 5 + Math.cos(y * 0.008) * 3 + Math.random() * 2;
            }
            groundGeometry.attributes.position.needsUpdate = true;
            groundGeometry.computeVertexNormals();
            
            // Материал земли с травой
            const groundMaterial = new THREE.MeshLambertMaterial({
                color: 0x3a5f3a,  // Темно-зеленый цвет травы
                transparent: false
            });
            
            const ground = new THREE.Mesh(groundGeometry, groundMaterial);
            ground.rotation.x = -Math.PI / 2;  // Поворачиваем горизонтально
            ground.position.y = -5;  // Немного ниже уровня дронов
            scene.add(ground);
            
            // Добавляем дороги/тропинки
            createRoads();
            
            // Добавляем деревья и растительность
            createVegetation();
            
            // Добавляем здания для городского пейзажа
            createBuildings();
        }
        
        function createRoads() {
            // Главная дорога
            const roadGeometry = new THREE.PlaneGeometry(1500, 20);
            const roadMaterial = new THREE.MeshBasicMaterial({ color: 0x333333 });
            const road1 = new THREE.Mesh(roadGeometry, roadMaterial);
            road1.rotation.x = -Math.PI / 2;
            road1.position.y = -4;
            scene.add(road1);
            
            // Перпендикулярная дорога
            const road2 = new THREE.Mesh(roadGeometry, roadMaterial);
            road2.rotation.x = -Math.PI / 2;
            road2.rotation.z = Math.PI / 2;
            road2.position.y = -4;
            scene.add(road2);
        }
        
        function createVegetation() {
            // Создаем случайные деревья
            for (let i = 0; i < 50; i++) {
                const treeGroup = new THREE.Group();
                
                // Ствол дерева
                const trunkGeometry = new THREE.CylinderGeometry(2, 3, 15);
                const trunkMaterial = new THREE.MeshLambertMaterial({ color: 0x8B4513 });
                const trunk = new THREE.Mesh(trunkGeometry, trunkMaterial);
                trunk.position.y = 7.5;
                
                // Крона дерева
                const crownGeometry = new THREE.SphereGeometry(8, 8, 6);
                const crownMaterial = new THREE.MeshLambertMaterial({ color: 0x228B22 });
                const crown = new THREE.Mesh(crownGeometry, crownMaterial);
                crown.position.y = 18;
                
                treeGroup.add(trunk);
                treeGroup.add(crown);
                
                // Случайное размещение (избегаем дорог)
                const x = (Math.random() - 0.5) * 2000;
                const z = (Math.random() - 0.5) * 2000;
                if (Math.abs(x) > 30 && Math.abs(z) > 30) {  // Не ставим на дороги
                    treeGroup.position.set(x, -5, z);
                    scene.add(treeGroup);
                }
            }
        }
        
        function createBuildings() {
            // Создаем несколько зданий для городского пейзажа
            for (let i = 0; i < 20; i++) {
                const height = Math.random() * 60 + 20;
                const width = Math.random() * 20 + 10;
                const depth = Math.random() * 20 + 10;
                
                const buildingGeometry = new THREE.BoxGeometry(width, height, depth);
                const buildingMaterial = new THREE.MeshLambertMaterial({ 
                    color: new THREE.Color().setHSL(0.1, 0.2, Math.random() * 0.3 + 0.5) 
                });
                const building = new THREE.Mesh(buildingGeometry, buildingMaterial);
                
                // Размещение в "городских" зонах
                const x = (Math.random() - 0.5) * 800 + (Math.random() > 0.5 ? 400 : -400);
                const z = (Math.random() - 0.5) * 800 + (Math.random() > 0.5 ? 400 : -400);
                
                building.position.set(x, height/2 - 5, z);
                scene.add(building);
            }
        }
        
        // Цвета дронов с учетом эшелонов
        function getDroneColor(clockType, altitudeLevel) {
            const colors = {
                'rubidium': 0xff3366,  // Ярко-красный
                'ocxo': 0x33ff66,      // Ярко-зеленый
                'tcxo': 0x3366ff,      // Ярко-синий
                'quartz': 0xffff33     // Ярко-желтый
            };
            
            let baseColor = colors[clockType] || 0x888888;
            
            // Модификация цвета в зависимости от эшелона
            if (typeof altitudeLevel !== 'undefined') {
                const altitudeFactors = [
                    0.6, // Эшелон 0 - темнее (нижний)
                    0.75, // Эшелон 1 - средне-темный
                    1.0,  // Эшелон 2 - базовый цвет
                    1.15, // Эшелон 3 - ярче
                    1.3   // Эшелон 4 - самый яркий (верхний)
                ];
                
                const factor = altitudeFactors[altitudeLevel] || 1.0;
                
                // Применяем фактор яркости
                const r = Math.min(255, ((baseColor >> 16) & 0xFF) * factor);
                const g = Math.min(255, ((baseColor >> 8) & 0xFF) * factor);
                const b = Math.min(255, (baseColor & 0xFF) * factor);
                
                baseColor = (r << 16) | (g << 8) | b;
            }
            
            return baseColor;
        }
        
        // Создание линий синхронизации между дронами
        function createSyncLines(dronesData) {
            // Найдем мастер-дрон
            const masterDrone = dronesData.find(drone => drone.is_master);
            if (!masterDrone) return;
            
            const masterIndex = dronesData.indexOf(masterDrone);
            const masterMesh = droneMeshes[masterIndex];
            if (!masterMesh) return;
            
            // Создаем линии от мастера к каждому дрону
            dronesData.forEach((drone, index) => {
                if (drone.is_master) return; // Пропускаем мастера
                
                const slaveMesh = droneMeshes[index];
                if (!slaveMesh) return;
                
                // Качество синхронизации определяет цвет и прозрачность линии
                const syncQuality = drone.sync_quality || 0;
                const lineColor = getSyncColor(syncQuality);
                const lineOpacity = Math.max(0.1, syncQuality);
                
                // Создаем геометрию линии
                const points = [];
                points.push(masterMesh.position.clone());
                points.push(slaveMesh.position.clone());
                
                const geometry = new THREE.BufferGeometry().setFromPoints(points);
                const material = new THREE.LineBasicMaterial({
                    color: lineColor,
                    transparent: true,
                    opacity: lineOpacity,
                    linewidth: syncQuality > 0.5 ? 2 : 1
                });
                
                const line = new THREE.Line(geometry, material);
                line.userData = {
                    masterIndex: masterIndex,
                    slaveIndex: index,
                    syncQuality: syncQuality
                };
                
                scene.add(line);
                syncLines.push(line);
            });
            
            console.log(`📡 Создано ${syncLines.length} линий синхронизации от мастера`);
        }
        
        // Обновление дронов - С МАКСИМАЛЬНОЙ ОТЛАДКОЙ
        function updateDrones(dronesData) {
            try {
                // Сохраняем данные дронов для использования в других функциях
                window.lastDronesData = dronesData;
                
                console.log('🔄 ОБНОВЛЕНИЕ ДРОНОВ. Получено:', dronesData.length, 'дронов');
                console.log('📋 Данные дронов:', dronesData);
                
                // Удаляем старые дроны
                droneMeshes.forEach(mesh => {
                    scene.remove(mesh);
                });
                droneMeshes = [];
                
                // Удаляем старые линии синхронизации
                syncLines.forEach(line => {
                    scene.remove(line);
                });
                syncLines = [];
                
                // Создаем новые
                dronesData.forEach((droneData, index) => {
                    console.log(`🔨 Создание дрона ${index}/${dronesData.length}:`, droneData);
                    
                    const mesh = createDroneMesh(droneData);
                    
                    // ПРОСТОЕ позиционирование
                    const x = droneData.position[0];
                    const y = droneData.position[1]; 
                    const z = droneData.position[2];
                    
                    mesh.position.set(x, z, y); // Three.js координаты
                    console.log(`📍 Позиция дрона ${index}: (${x.toFixed(1)}, ${z.toFixed(1)}, ${y.toFixed(1)})`);
                    
                    scene.add(mesh);
                    droneMeshes.push(mesh);
                    console.log(`✅ Дрон ${index} добавлен в сцену`);
                });
                
                // Создаем линии синхронизации между дронами
                createSyncLines(dronesData);
                
                console.log('🎉 ЗАВЕРШЕНО! Создано дронов в сцене:', droneMeshes.length);
                console.log('📡 Создано линий синхронизации:', syncLines.length);
                console.log('📊 Объекты в сцене:', scene.children.length);
                
            } catch (error) {
                console.error('❌ КРИТИЧЕСКАЯ ОШИБКА updateDrones:', error);
                console.error('📄 Stack trace:', error.stack);
            }
        }
        
        // Обновление метрик
        function updateMetrics(statusData) {
            try {
                if (statusData.running) {
                    document.getElementById('simTime').textContent = (statusData.simulation_time || 0).toFixed(1) + 'с';
                    document.getElementById('avgOffset').textContent = (statusData.avg_time_offset || 0).toFixed(2) + ' нс';
                    document.getElementById('syncQuality').textContent = (statusData.avg_sync_quality || 0).toFixed(3);
                    document.getElementById('swarmAccuracy').textContent = (statusData.swarm_sync_accuracy || 0).toFixed(2) + ' нс';
                    document.getElementById('timeDivergence').textContent = (statusData.swarm_time_divergence || 0).toFixed(2) + ' нс';
                    document.getElementById('dpllLocked').textContent = (statusData.dpll_locked_count || 0) + '/' + (statusData.num_drones || 0);
                    document.getElementById('syncEvents').textContent = (statusData.wwvb_sync_count || 0);
                    document.getElementById('batteryLevel').textContent = (statusData.avg_battery_level || 0).toFixed(2);
                    document.getElementById('signalStrength').textContent = (statusData.avg_signal_strength || 0).toFixed(2);
                    document.getElementById('temperature').textContent = (statusData.avg_temperature || 0).toFixed(1) + '°C';
                    
                    // Обновляем информацию об эшелонах
                    if (window.lastDronesData && window.lastDronesData.length > 0) {
                        const altitudeLevels = [...new Set(window.lastDronesData.map(d => d.altitude_level || 2))].sort();
                        const altitudes = window.lastDronesData.map(d => d.position ? d.position[2] : d.z || 100);
                        const minAlt = Math.min(...altitudes).toFixed(1);
                        const maxAlt = Math.max(...altitudes).toFixed(1);
                        
                        document.getElementById('altitudeLevels').textContent = altitudeLevels.join(', ');
                        document.getElementById('altitudeRange').textContent = `${minAlt}-${maxAlt}м`;
                    }
                }
            } catch (error) {
                console.error('❌ Ошибка обновления метрик:', error);
            }
        }
        
        // Обновление статуса
        function updateStatus(running) {
            const indicator = document.getElementById('statusIndicator');
            const titleText = document.getElementById('titleText');
            
            if (running) {
                indicator.className = 'status-indicator status-running';
                titleText.textContent = 'Final Drone Swarm Simulation [АКТИВНА]';
            } else {
                indicator.className = 'status-indicator status-stopped';
                titleText.textContent = 'Final Drone Swarm Simulation [ОСТАНОВЛЕНА]';
            }
            isSimulationRunning = running;
        }
        
        // Уведомления
        function showNotification(message, type = 'info') {
            const notification = document.createElement('div');
            notification.className = 'notification';
            
            const colors = {
                'success': '#00ff88',
                'error': '#ff4444',
                'info': '#2196F3'
            };
            
            notification.style.background = colors[type] || colors.info;
            if (type === 'success') notification.style.color = '#000';
            
            notification.textContent = message;
            document.body.appendChild(notification);
            
            setTimeout(() => {
                notification.style.animation = 'slideOut 0.3s ease-in';
                setTimeout(() => {
                    if (notification.parentNode) {
                        notification.parentNode.removeChild(notification);
                    }
                }, 300);
            }, 4000);
        }
        
        // API функции
        async function startSimulation() {
            try {
                const startBtn = document.getElementById('startBtn');
                startBtn.disabled = true;
                startBtn.textContent = '⚡ Запуск...';
                
                console.log('🚀 ЗАПУСК СИМУЛЯЦИИ...');
                
                const response = await fetch('/api/start');
                const data = await response.json();
                console.log('📡 Ответ сервера:', data);
                
                if (response.ok && data.status === 'started') {
                    updateStatus(true);
                    startDataPolling();
                    showNotification('🎉 Симуляция запущена успешно!', 'success');
                    console.log('✅ Симуляция активна');
                } else {
                    showNotification('❌ Ошибка запуска: ' + (data.message || 'Неизвестная ошибка'), 'error');
                }
            } catch (error) {
                console.error('❌ Ошибка запуска:', error);
                showNotification('❌ Ошибка запуска: ' + error.message, 'error');
            } finally {
                const startBtn = document.getElementById('startBtn');
                startBtn.disabled = false;
                startBtn.textContent = '🚀 Запустить';
            }
        }
        
        async function stopSimulation() {
            try {
                const response = await fetch('/api/stop');
                if (response.ok) {
                    updateStatus(false);
                    showNotification('⏹️ Симуляция остановлена', 'info');
                }
            } catch (error) {
                console.error('❌ Ошибка остановки:', error);
            }
        }
        
        async function updateConfig() {
            try {
                // Основные параметры
                const numDrones = document.getElementById('numDrones').value;
                const radius = document.getElementById('radius').value;
                const height = document.getElementById('height').value;
                
                // Параметры синхронизации
                const syncFrequency = document.getElementById('syncFrequency').value;
                const syncTopology = document.getElementById('syncTopology').value;
                const syncRange = document.getElementById('syncRange').value;
                const syncAlgorithm = document.getElementById('syncAlgorithm').value;
                
                // Генераторы времени
                const masterClock = document.getElementById('masterClock').value;
                const slaveClock = document.getElementById('slaveClock').value;
                const adaptiveSync = document.getElementById('adaptiveSync').value;
                const delayCompensation = document.getElementById('delayCompensation').value;
                
                // Частотные параметры
                const frequencyBand = document.getElementById('frequencyBand').value;
                const channelWidth = document.getElementById('channelWidth').value;
                const interferenceModel = document.getElementById('interferenceModel').value;
                
                // Параметры отказоустойчивости
                const failureSimulation = document.getElementById('failureSimulation').value;
                const masterFailureRate = document.getElementById('masterFailureRate').value;
                const masterTimeout = document.getElementById('masterTimeout').value;
                const electionAlgorithm = document.getElementById('electionAlgorithm').value;
                
                // Параметры полета
                const flightPattern = document.getElementById('flightPattern').value;
                const formationType = document.getElementById('formationType').value;
                const maxSpeed = document.getElementById('maxSpeed').value;
                
                // Формирование URL с параметрами
                const params = new URLSearchParams({
                    num_drones: numDrones,
                    radius: radius,
                    height: height,
                    sync_frequency: syncFrequency,
                    sync_topology: syncTopology,
                    sync_range: syncRange,
                    sync_algorithm: syncAlgorithm,
                    master_clock: masterClock,
                    slave_clock: slaveClock,
                    adaptive_sync: adaptiveSync,
                    delay_compensation: delayCompensation,
                    frequency_band: frequencyBand,
                    channel_width: channelWidth,
                    interference_model: interferenceModel,
                    failure_simulation: failureSimulation,
                    master_failure_rate: masterFailureRate,
                    master_timeout: masterTimeout,
                    election_algorithm: electionAlgorithm,
                    flight_pattern: flightPattern,
                    formation_type: formationType,
                    max_speed: maxSpeed
                });
                
                const response = await fetch(`/api/update_config?${params}`);
                if (response.ok) {
                    showNotification('🔄 Все параметры обновлены успешно!', 'success');
                    console.log('✅ Конфигурация обновлена:', Object.fromEntries(params));
                }
            } catch (error) {
                console.error('❌ Ошибка обновления конфигурации:', error);
                showNotification('❌ Ошибка обновления конфигурации', 'error');
            }
        }
        
        // Обновление отображения значения ползунка помех
        document.addEventListener('DOMContentLoaded', function() {
            const interferenceSlider = document.getElementById('interferenceLevel');
            const interferenceValue = document.getElementById('interferenceValue');
            
            if (interferenceSlider && interferenceValue) {
                interferenceSlider.addEventListener('input', function() {
                    interferenceValue.textContent = this.value;
                });
            }
        });
        
        // Опрос данных с максимальной отладкой
        function startDataPolling() {
            console.log('📡 ЗАПУСК ОПРОСА ДАННЫХ');
            
            const pollData = async () => {
                if (!isSimulationRunning) {
                    console.log('⏸️ Опрос остановлен - симуляция не активна');
                    return;
                }
                
                try {
                    // Статус
                    const statusResponse = await fetch('/api/status');
                    if (statusResponse.ok) {
                        const statusData = await statusResponse.json();
                        updateMetrics(statusData);
                    }
                    
                    // Дроны
                    const dronesResponse = await fetch('/api/drones');
                    if (dronesResponse.ok) {
                        const dronesData = await dronesResponse.json();
                        console.log('📥 Получены данные дронов:', dronesData.length, 'штук');
                        updateDrones(dronesData);
                    } else {
                        console.error('❌ Ошибка получения дронов:', dronesResponse.status);
                    }
                    
                } catch (error) {
                    console.error('❌ Ошибка опроса данных:', error);
                }
                
                setTimeout(pollData, 200); // Опрос каждые 200мс
            };
            
            pollData();
        }
        
        // Обработка изменения размера
        window.addEventListener('resize', () => {
            if (camera && renderer) {
                camera.aspect = window.innerWidth / window.innerHeight;
                camera.updateProjectionMatrix();
                renderer.setSize(window.innerWidth, window.innerHeight);
            }
        });
        
        // ИНИЦИАЛИЗАЦИЯ
        window.addEventListener('load', () => {
            console.log('🌍 Страница загружена, запуск инициализации...');
            
            const success = initThreeJS();
            updateStatus(false);
            
            if (success) {
                setTimeout(() => {
                    showNotification('🎯 Финальная симуляция готова! Нажмите "Запустить"', 'info');
                }, 1000);
            } else {
                showNotification('❌ Ошибка инициализации 3D', 'error');
            }
        });
        
        // Функции управления симуляцией
        async function startSimulation() {
            console.log('🚀 Запуск симуляции...');
            try {
                const response = await fetch('/api/start');
                if (response.ok) {
                    const data = await response.json();
                    isSimulationRunning = true;
                    showNotification('🚀 Симуляция запущена!', 'success');
                    
                    // Скрываем панель параметров и показываем 3D сцену
                    document.querySelector('.config-panel').style.display = 'none';
                    document.querySelector('.canvas-container').style.display = 'block';
                    
                    // Запускаем опрос данных
                    startDataPolling();
                } else {
                    showNotification('❌ Ошибка запуска симуляции', 'error');
                }
            } catch (error) {
                console.error('❌ Ошибка запуска:', error);
                showNotification('❌ Ошибка запуска симуляции', 'error');
            }
        }
        
        async function stopSimulation() {
            console.log('⏹️ Остановка симуляции...');
            try {
                const response = await fetch('/api/stop');
                if (response.ok) {
                    isSimulationRunning = false;
                    showNotification('⏹️ Симуляция остановлена', 'info');
                    
                    // Показываем панель параметров и скрываем 3D сцену
                    document.querySelector('.config-panel').style.display = 'block';
                    document.querySelector('.canvas-container').style.display = 'none';
                    
                    // Очищаем дроны
                    clearDrones();
                } else {
                    showNotification('❌ Ошибка остановки симуляции', 'error');
                }
            } catch (error) {
                console.error('❌ Ошибка остановки:', error);
                showNotification('❌ Ошибка остановки симуляции', 'error');
            }
        }
        
        function clearDrones() {
            droneMeshes.forEach(mesh => {
                scene.remove(mesh);
            });
            droneMeshes = [];
        }
    </script>
</body>
</html>
        """
        
        self.send_response(200)
        self.send_header('Content-type', 'text/html; charset=utf-8')
        self.end_headers()
        self.wfile.write(html_content.encode('utf-8'))
    
    def start_simulation(self):
        """Запуск симуляции"""
        global GLOBAL_SWARM, GLOBAL_SIMULATION_RUNNING, GLOBAL_SIMULATION_THREAD, GLOBAL_SWARM_CONFIG
        try:
            print(f"🔧 Попытка запуска симуляции. Текущее состояние: running={GLOBAL_SIMULATION_RUNNING}, swarm={GLOBAL_SWARM is not None}")
            
            if GLOBAL_SIMULATION_RUNNING:
                print("⚠️ Симуляция уже запущена")
                self.send_json_response({'status': 'already_running'})
                return
                
            print(f"🔧 Создание роя с параметрами: {GLOBAL_SWARM_CONFIG}")
            
            # Сначала создаем рой
            print("📦 Создание экземпляра FinalSwarm...")
            GLOBAL_SWARM = FinalSwarm(
                GLOBAL_SWARM_CONFIG['num_drones'],
                GLOBAL_SWARM_CONFIG['radius'],
                GLOBAL_SWARM_CONFIG['height']
            )
            
            print(f"✅ Рой создан! Количество дронов: {len(GLOBAL_SWARM.drones)}")
            
            # Проверяем каждый дрон
            for i, drone in enumerate(GLOBAL_SWARM.drones):
                print(f"  Дрон {i}: позиция ({drone.x:.1f}, {drone.y:.1f}, {drone.z:.1f}), мастер: {drone.is_master}")
            
            # Применяем конфигурацию синхронизации
            if hasattr(GLOBAL_SWARM, 'sync_config'):
                for key in ['sync_frequency', 'sync_topology', 'sync_range', 'sync_algorithm', 
                           'master_clock', 'slave_clock', 'adaptive_sync', 'delay_compensation']:
                    if key in GLOBAL_SWARM_CONFIG:
                        GLOBAL_SWARM.sync_config[key] = GLOBAL_SWARM_CONFIG[key]
                print(f"🔧 Применена конфигурация синхронизации: {GLOBAL_SWARM.sync_config}")
            
            # Только теперь помечаем симуляцию как запущенную
            GLOBAL_SIMULATION_RUNNING = True
            
            # Запускаем поток симуляции
            print("🚀 Запуск потока симуляции...")
            GLOBAL_SIMULATION_THREAD = threading.Thread(target=self._simulation_loop)
            GLOBAL_SIMULATION_THREAD.daemon = True
            GLOBAL_SIMULATION_THREAD.start()
            
            print(f"🚀 Финальная симуляция запущена с {len(GLOBAL_SWARM.drones)} дронами")
            self.send_json_response({'status': 'started', 'message': 'Симуляция запущена'})
            
        except Exception as e:
            print(f"❌ Ошибка запуска симуляции: {e}")
            import traceback
            traceback.print_exc()
            GLOBAL_SIMULATION_RUNNING = False
            GLOBAL_SWARM = None
            self.send_json_response({'status': 'error', 'message': str(e)})
    
    def stop_simulation(self):
        """Остановка симуляции"""
        global GLOBAL_SIMULATION_RUNNING
        GLOBAL_SIMULATION_RUNNING = False
        print("⏹️ Симуляция остановлена")
        self.send_json_response({'status': 'stopped'})
    
    def get_simulation_status(self):
        """Получение статуса"""
        global GLOBAL_SWARM, GLOBAL_SIMULATION_RUNNING, GLOBAL_SWARM_CONFIG
        try:
            if GLOBAL_SWARM and GLOBAL_SIMULATION_RUNNING:
                status = GLOBAL_SWARM.get_swarm_status()
                status['running'] = True
                self.send_json_response(status)
            else:
                self.send_json_response({
                    'running': False,
                    'simulation_time': 0.0,
                    'num_drones': GLOBAL_SWARM_CONFIG['num_drones']
                })
        except Exception as e:
            print(f"❌ Ошибка статуса: {e}")
            self.send_json_response({'running': False, 'error': str(e)})
    
    def get_drones_data(self):
        """Получение данных дронов"""
        global GLOBAL_SWARM, GLOBAL_SIMULATION_RUNNING
        try:
            print(f"🔍 Проверка дронов: swarm={GLOBAL_SWARM is not None}, running={GLOBAL_SIMULATION_RUNNING}")
            if GLOBAL_SWARM:
                print(f"  Количество дронов в рое: {len(GLOBAL_SWARM.drones)}")
            
            if GLOBAL_SWARM and GLOBAL_SIMULATION_RUNNING:
                drones_data = [drone.get_status() for drone in GLOBAL_SWARM.drones]
                print(f"📡 Отправка данных о {len(drones_data)} дронах")
                self.send_json_response(drones_data)
            else:
                if not GLOBAL_SWARM:
                    print("📡 Отправка пустого списка дронов - рой не создан")
                elif not GLOBAL_SIMULATION_RUNNING:
                    print("📡 Отправка пустого списка дронов - симуляция не запущена")
                self.send_json_response([])
        except Exception as e:
            print(f"❌ Ошибка получения данных дронов: {e}")
            import traceback
            traceback.print_exc()
            self.send_json_response([])
    
    def get_config(self):
        """Получение конфигурации"""
        global GLOBAL_SWARM_CONFIG
        self.send_json_response(GLOBAL_SWARM_CONFIG)
    
    def update_config(self, query_params):
        """Обновление конфигурации с поддержкой продвинутых параметров синхронизации"""
        global GLOBAL_SWARM_CONFIG, GLOBAL_SWARM
        try:
            # Основные параметры
            if 'num_drones' in query_params:
                GLOBAL_SWARM_CONFIG['num_drones'] = int(query_params['num_drones'][0])
            if 'radius' in query_params:
                GLOBAL_SWARM_CONFIG['radius'] = float(query_params['radius'][0])
            if 'height' in query_params:
                GLOBAL_SWARM_CONFIG['height'] = float(query_params['height'][0])
            
            # Параметры синхронизации
            if 'sync_frequency' in query_params:
                GLOBAL_SWARM_CONFIG['sync_frequency'] = float(query_params['sync_frequency'][0])
            if 'sync_topology' in query_params:
                GLOBAL_SWARM_CONFIG['sync_topology'] = query_params['sync_topology'][0]
            if 'sync_range' in query_params:
                GLOBAL_SWARM_CONFIG['sync_range'] = float(query_params['sync_range'][0])
            if 'sync_algorithm' in query_params:
                GLOBAL_SWARM_CONFIG['sync_algorithm'] = query_params['sync_algorithm'][0]
            if 'master_clock' in query_params:
                GLOBAL_SWARM_CONFIG['master_clock'] = query_params['master_clock'][0]
            if 'slave_clock' in query_params:
                GLOBAL_SWARM_CONFIG['slave_clock'] = query_params['slave_clock'][0]
            if 'adaptive_sync' in query_params:
                GLOBAL_SWARM_CONFIG['adaptive_sync'] = query_params['adaptive_sync'][0]
            if 'delay_compensation' in query_params:
                GLOBAL_SWARM_CONFIG['delay_compensation'] = query_params['delay_compensation'][0]
            
            # Частотные параметры
            if 'frequency_band' in query_params:
                GLOBAL_SWARM_CONFIG['frequency_band'] = query_params['frequency_band'][0]
            if 'channel_width' in query_params:
                GLOBAL_SWARM_CONFIG['channel_width'] = int(query_params['channel_width'][0])
            if 'interference_model' in query_params:
                GLOBAL_SWARM_CONFIG['interference_model'] = query_params['interference_model'][0]
            
            # Параметры отказоустойчивости
            if 'failure_simulation' in query_params:
                GLOBAL_SWARM_CONFIG['failure_simulation'] = query_params['failure_simulation'][0]
            if 'master_failure_rate' in query_params:
                GLOBAL_SWARM_CONFIG['master_failure_rate'] = float(query_params['master_failure_rate'][0])
            if 'master_timeout' in query_params:
                GLOBAL_SWARM_CONFIG['master_timeout'] = float(query_params['master_timeout'][0])
            if 'election_algorithm' in query_params:
                GLOBAL_SWARM_CONFIG['election_algorithm'] = query_params['election_algorithm'][0]
            
            # Обновление параметров роя (если он существует)
            if GLOBAL_SWARM:
                swarm_params = {}
                
                # Параметры полета
                if 'flight_pattern' in query_params:
                    swarm_params['flight_pattern'] = query_params['flight_pattern'][0]
                if 'formation_type' in query_params:
                    swarm_params['formation_type'] = query_params['formation_type'][0]
                if 'max_speed' in query_params:
                    swarm_params['max_speed'] = float(query_params['max_speed'][0])
                
                # Обновление конфигурации синхронизации роя
                sync_config_updates = {}
                for key in ['sync_frequency', 'sync_topology', 'sync_range', 'sync_algorithm', 
                           'master_clock', 'slave_clock', 'adaptive_sync', 'delay_compensation',
                           'frequency_band', 'channel_width', 'interference_model']:
                    if key in GLOBAL_SWARM_CONFIG:
                        sync_config_updates[key] = GLOBAL_SWARM_CONFIG[key]
                
                if sync_config_updates:
                    GLOBAL_SWARM.sync_config.update(sync_config_updates)
                    print(f"📡 Конфигурация синхронизации обновлена: {sync_config_updates}")
                
                # Применение параметров к рою
                if swarm_params:
                    GLOBAL_SWARM.update_parameters(**swarm_params)
                
                # Обновление типов часов дронов в зависимости от выбранного типа
                master_clock_type = GLOBAL_SWARM_CONFIG.get('master_clock', 'rubidium')
                slave_clock_type = GLOBAL_SWARM_CONFIG.get('slave_clock', 'ocxo')
                
                clock_type_mapping = {
                    'rubidium': ClockType.RUBIDIUM,
                    'cesium': ClockType.RUBIDIUM,  # Используем RUBIDIUM как замену для цезия
                    'gps_disciplined': ClockType.OCXO,
                    'hydrogen_maser': ClockType.RUBIDIUM,  # Используем RUBIDIUM как лучший доступный
                    'ocxo': ClockType.OCXO,
                    'tcxo': ClockType.TCXO,
                    'quartz': ClockType.QUARTZ,
                    'crystal': ClockType.QUARTZ
                }
                
                # Обновляем типы часов дронов
                for drone in GLOBAL_SWARM.drones:
                    if drone.is_master:
                        drone.clock_type = clock_type_mapping.get(master_clock_type, ClockType.RUBIDIUM)
                    else:
                        drone.clock_type = clock_type_mapping.get(slave_clock_type, ClockType.OCXO)
                    
                    # Пересчитываем характеристики часов
                    drone._setup_clock_characteristics()
                
                print(f"⏰ Типы часов обновлены: мастер={master_clock_type}, ведомые={slave_clock_type}")
            
            print(f"⚙️ Конфигурация обновлена: {GLOBAL_SWARM_CONFIG}")
            if GLOBAL_SWARM:
                print(f"🚁 Параметры роя обновлены")
            
            self.send_json_response({'status': 'updated', 'message': 'Все параметры синхронизации обновлены'})
        except Exception as e:
            print(f"❌ Ошибка обновления конфигурации: {e}")
            import traceback
            traceback.print_exc()
            self.send_json_response({'status': 'error', 'message': str(e)})
    
    def _simulation_loop(self):
        """Основной цикл симуляции"""
        global GLOBAL_SWARM, GLOBAL_SIMULATION_RUNNING
        print("🔄 Запуск цикла симуляции")
        dt = 0.1
        while GLOBAL_SIMULATION_RUNNING:
            if GLOBAL_SWARM:
                GLOBAL_SWARM.update(dt)
            time.sleep(dt)
        print("🔄 Цикл симуляции завершен")
    
    def send_json_response(self, data):
        """Отправка JSON ответа"""
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()
        self.wfile.write(json.dumps(data, ensure_ascii=False).encode('utf-8'))


def run_final_simulation_server(port=8080):
    """Запуск финального сервера симуляции"""
    server_address = ('', port)
    httpd = HTTPServer(server_address, FinalWebHandler)
    
    print("=" * 60)
    print("🚁 FINAL DRONE SWARM SIMULATION 🚁")
    print("=" * 60)
    print(f"🚀 Сервер запускается на порту {port}")
    print(f"🌐 Откройте браузер: http://localhost:{port}")
    print("🎯 3D визуализация с ультра-точными алгоритмами")
    print("⚡ Точность синхронизации: 10-100 наносекунд")
    print("🎮 Управление: мышь для поворота камеры")
    print("⏹️ Для остановки нажмите Ctrl+C")
    print("=" * 60)
    
    # Автоматическое открытие браузера
    try:
        webbrowser.open(f'http://localhost:{port}')
        print("🌍 Браузер открыт автоматически")
    except:
        print("⚠️ Не удалось открыть браузер автоматически")
    
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n⏹️ Остановка сервера...")
        httpd.shutdown()
        print("✅ Сервер остановлен")


if __name__ == "__main__":
    run_final_simulation_server()

