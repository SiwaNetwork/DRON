#!/usr/bin/env python3
"""
Unified 3D Web Simulation - Единая 3D веб-симуляция роя дронов
Включает:
- HTTP сервер с API
- 3D визуализацию с Three.js
- Ультра-точные алгоритмы синхронизации
- Интерактивное управление
- Все зависимости в одном файле
"""

import json
import time
import threading
import random
import math
# import numpy as np  # Заменим на встроенные функции
from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse, parse_qs
import webbrowser
from collections import deque
from enum import Enum


# ===== АЛГОРИТМЫ СИНХРОНИЗАЦИИ =====

class ClockType(Enum):
    """Типы часов"""
    RUBIDIUM = "rubidium"
    OCXO = "ocxo"
    TCXO = "tcxo"
    QUARTZ = "quartz"


class V4ClockState:
    """Состояние часов V4"""
    def __init__(self, clock_type: ClockType):
        self.clock_type = clock_type
        self.frequency_offset = 0.0
        self.phase_offset = 0.0
        self.temperature = 25.0
        self.aging_rate = 0.0
        self.holdover_time = 0.0
        self.sync_quality = 0.0


class V4DPLLController:
    """Цифровой PLL контроллер V4"""
    def __init__(self):
        self.kp = 1.0
        self.ki = 0.2
        self.kd = 0.05
        self.integral = 0.0
        self.last_error = 0.0
        self.locked = False
        self.lock_threshold = 1e-9
        
    def update(self, error: float, dt: float) -> float:
        """Обновление PLL"""
        self.integral += error * dt
        derivative = (error - self.last_error) / dt if dt > 0 else 0
        
        output = self.kp * error + self.ki * self.integral + self.kd * derivative
        
        self.locked = abs(error) < self.lock_threshold
        self.last_error = error
        
        return output


class UltraPreciseDrone:
    """Ультра-точный дрон с V4 алгоритмами"""
    
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
        
        # Состояние часов
        self.clock_state = V4ClockState(self.clock_type)
        self.dpll = V4DPLLController()
        
        # Параметры синхронизации
        self.time_offset = random.uniform(-100, 100)  # нс
        self.frequency_offset = random.uniform(-1e-12, 1e-12)  # ppt
        self.jitter = random.uniform(1, 10)  # нс
        
        # Характеристики дрейфа по типу часов
        self._setup_clock_characteristics()
        
        # Физические параметры
        self.velocity_x = random.uniform(-5, 5)
        self.velocity_y = random.uniform(-5, 5)
        self.velocity_z = random.uniform(-2, 2)
        
        # Метрики
        self.sync_events = 0
        self.battery_level = random.uniform(0.8, 1.0)
        self.signal_strength = random.uniform(0.8, 1.0)
        self.temperature = random.uniform(20, 30)
        self.correction_factor = 1.0
        self.sync_history = deque(maxlen=20)
    
    def _setup_clock_characteristics(self):
        """Настройка характеристик часов по типу"""
        if self.clock_type == ClockType.RUBIDIUM:
            self.clock_drift_rate = random.uniform(-1e-15, 1e-15)  # fs/s
            self.temperature_drift = random.uniform(-1e-11, 1e-11)
            self.aging_rate = random.uniform(-1e-12, 1e-12)
        elif self.clock_type == ClockType.OCXO:
            self.clock_drift_rate = random.uniform(-1e-12, 1e-12)  # ps/s
            self.temperature_drift = random.uniform(-1e-9, 1e-9)
            self.aging_rate = random.uniform(-1e-10, 1e-10)
        elif self.clock_type == ClockType.TCXO:
            self.clock_drift_rate = random.uniform(-1e-9, 1e-9)  # ns/s
            self.temperature_drift = random.uniform(-1e-7, 1e-7)
            self.aging_rate = random.uniform(-1e-8, 1e-8)
        else:  # QUARTZ
            self.clock_drift_rate = random.uniform(-1e-6, 1e-6)  # µs/s
            self.temperature_drift = random.uniform(-1e-5, 1e-5)
            self.aging_rate = random.uniform(-1e-6, 1e-6)
    
    def update(self, dt: float, swarm=None):
        """Обновление дрона"""
        # Обновление физики движения
        self._update_physics(dt)
        
        # Обновление синхронизации
        self._update_synchronization(dt, swarm)
        
        # Обновление метрик
        self._update_metrics()
    
    def _update_physics(self, dt: float):
        """Обновление физики движения"""
        # Случайные изменения скорости
        self.velocity_x += random.uniform(-0.5, 0.5)
        self.velocity_y += random.uniform(-0.5, 0.5)
        self.velocity_z += random.uniform(-0.2, 0.2)
        
        # Ограничение скорости
        max_speed = 10.0
        self.velocity_x = max(-max_speed, min(max_speed, self.velocity_x))
        self.velocity_y = max(-max_speed, min(max_speed, self.velocity_y))
        self.velocity_z = max(-max_speed, min(max_speed, self.velocity_z))
        
        # Обновление позиции
        self.x += self.velocity_x * dt
        self.y += self.velocity_y * dt
        self.z += self.velocity_z * dt
        
        # Ограничение области полета
        max_range = 200.0
        self.x = max(-max_range, min(max_range, self.x))
        self.y = max(-max_range, min(max_range, self.y))
        self.z = max(10, min(100, self.z))
        
        # Отскок от границ
        if abs(self.x) > max_range * 0.9:
            self.velocity_x *= -0.5
        if abs(self.y) > max_range * 0.9:
            self.velocity_y *= -0.5
        if self.z < 15 or self.z > 95:
            self.velocity_z *= -0.5
    
    def _update_synchronization(self, dt: float, swarm):
        """Обновление синхронизации"""
        # Симуляция дрейфа часов
        drift_component = self.clock_drift_rate * dt
        temp_component = self.temperature_drift * (self.temperature - 25.0) * dt
        aging_component = self.aging_rate * dt
        jitter_component = random.uniform(-self.jitter, self.jitter)
        
        total_drift = drift_component + temp_component + aging_component + jitter_component
        self.time_offset += total_drift
        
        # Синхронизация с мастер-дроном
        if not self.is_master and swarm:
            master_drone = next((d for d in swarm.drones if d.is_master), None)
            if master_drone:
                # Расчет расстояния и задержки
                distance = math.sqrt(
                    (self.x - master_drone.x)**2 + 
                    (self.y - master_drone.y)**2 + 
                    (self.z - master_drone.z)**2
                )
                
                propagation_delay = distance / 3e8 * 1e9  # нс
                
                # Качество синхронизации
                base_quality = max(0.95, 1.0 - distance / 1000.0)
                sync_quality = base_quality * self.signal_strength
                
                # Синхронизация с высокой вероятностью
                if random.random() < 0.8:
                    master_time = master_drone.time_offset
                    received_time = master_time + propagation_delay
                    
                    # Коррекция времени
                    error = received_time - self.time_offset
                    correction = self.dpll.update(error, dt)
                    
                    # Применение коррекции
                    time_correction = correction * sync_quality * 0.8 * self.correction_factor
                    max_correction = 50.0  # Максимум 50 нс за раз
                    time_correction = max(-max_correction, min(max_correction, time_correction))
                    
                    self.time_offset += time_correction
                    
                    # Адаптация
                    self.sync_history.append(time_correction)
                    if len(self.sync_history) > 10:
                        recent_corrections = list(self.sync_history)[-10:]

                        
                        # Вычисляем стандартное отклонение
                        mean_correction = sum(recent_corrections) / len(recent_corrections)
                        variance = sum((x - mean_correction)**2 for x in recent_corrections) / len(recent_corrections)
                        std_correction = math.sqrt(variance)
                        
                        if std_correction < 5.0:
                            self.correction_factor = min(1.2, self.correction_factor + 0.01)
                        else:
                            self.correction_factor = max(0.5, self.correction_factor - 0.01)
                    
                    self.sync_events += 1
                    self.clock_state.sync_quality = min(1.0, self.clock_state.sync_quality + 0.02)
    
    def _update_metrics(self):
        """Обновление метрик"""
        self.battery_level = max(0.1, self.battery_level - random.uniform(0.00005, 0.0002))
        self.signal_strength = max(0.7, min(1.0, self.signal_strength + random.uniform(-0.005, 0.005)))
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
            'sync_quality': self.clock_state.sync_quality,
            'dpll_locked': self.dpll.locked,
            'sync_events': self.sync_events,
            'battery_level': self.battery_level,
            'signal_strength': self.signal_strength,
            'temperature': self.temperature
        }


class UltraPreciseSwarm:
    """Ультра-точный рой дронов"""
    
    def __init__(self, num_drones: int = 20, radius: float = 100.0, height: float = 50.0):
        self.num_drones = num_drones
        self.radius = radius
        self.height = height
        self.simulation_time = 0.0
        
        self.drones = []
        self._create_drones()
    
    def _create_drones(self):
        """Создание дронов"""
        self.drones = []
        
        # Создание мастер-дрона в центре
        master_drone = UltraPreciseDrone(0, 0, 0, self.height, is_master=True)
        self.drones.append(master_drone)
        
        # Создание остальных дронов
        for i in range(1, self.num_drones):
            # Случайное размещение в сфере
            angle = random.uniform(0, 2 * math.pi)
            elevation = random.uniform(-math.pi/4, math.pi/4)
            r = random.uniform(20, self.radius)
            
            x = r * math.cos(elevation) * math.cos(angle)
            y = r * math.cos(elevation) * math.sin(angle)
            z = self.height + r * math.sin(elevation)
            
            drone = UltraPreciseDrone(i, x, y, z, is_master=False)
            self.drones.append(drone)
    
    def update(self, dt: float):
        """Обновление роя"""
        self.simulation_time += dt
        
        # Обновление всех дронов
        for drone in self.drones:
            drone.update(dt, self)
    
    def get_swarm_status(self):
        """Получение статуса роя"""
        if not self.drones:
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
        
        # Расчет статистики
        time_offsets = [d.time_offset for d in self.drones]
        sync_qualities = [d.clock_state.sync_quality for d in self.drones]
        dpll_locked = sum(1 for d in self.drones if d.dpll.locked)
        sync_events = sum(d.sync_events for d in self.drones)
        battery_levels = [d.battery_level for d in self.drones]
        signal_strengths = [d.signal_strength for d in self.drones]
        temperatures = [d.temperature for d in self.drones]
        
        # Расчет точности и расхождения
        avg_offset = sum(time_offsets) / len(time_offsets) if time_offsets else 0
        avg_sync_quality = sum(sync_qualities) / len(sync_qualities) if sync_qualities else 0
        avg_battery = sum(battery_levels) / len(battery_levels) if battery_levels else 0
        avg_signal = sum(signal_strengths) / len(signal_strengths) if signal_strengths else 0
        avg_temp = sum(temperatures) / len(temperatures) if temperatures else 0
        
        # Стандартное отклонение для time_divergence
        if time_offsets:
            variance = sum((offset - avg_offset)**2 for offset in time_offsets) / len(time_offsets)
            time_divergence = math.sqrt(variance)
            swarm_accuracy = math.sqrt(sum((offset - avg_offset)**2 for offset in time_offsets) / len(time_offsets))
        else:
            time_divergence = 0
            swarm_accuracy = 0
        
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


# ===== ВЕБ-СЕРВЕР =====

class Unified3DWebHandler(BaseHTTPRequestHandler):
    """HTTP обработчик для единой 3D веб-симуляции"""
    
    # Глобальные переменные
    swarm = None
    simulation_thread = None
    simulation_running = False
    swarm_config = {
        'num_drones': 20,
        'radius': 100.0,
        'height': 50.0
    }
    
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
    <title>Unified 3D Drone Swarm Sync</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            overflow: hidden;
        }
        
        .header {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            background: rgba(0, 0, 0, 0.8);
            padding: 15px 20px;
            z-index: 1000;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 2px solid #00ff88;
        }
        
        .title {
            font-size: 24px;
            font-weight: bold;
            color: #00ff88;
            text-shadow: 0 0 10px rgba(0, 255, 136, 0.3);
        }
        
        .controls {
            display: flex;
            gap: 10px;
        }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 14px;
        }
        
        .btn-start {
            background: linear-gradient(45deg, #00ff88, #00cc6a);
            color: #000;
        }
        
        .btn-start:hover {
            background: linear-gradient(45deg, #00cc6a, #00aa55);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 255, 136, 0.4);
        }
        
        .btn-stop {
            background: linear-gradient(45deg, #ff4444, #cc3333);
            color: white;
        }
        
        .btn-stop:hover {
            background: linear-gradient(45deg, #cc3333, #aa2222);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(255, 68, 68, 0.4);
        }
        
        .btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none !important;
        }
        
        .config-panel {
            position: fixed;
            top: 80px;
            left: 20px;
            width: 280px;
            background: rgba(0, 0, 0, 0.8);
            padding: 20px;
            border-radius: 10px;
            border: 1px solid rgba(0, 255, 136, 0.3);
            backdrop-filter: blur(10px);
        }
        
        .config-group {
            margin-bottom: 15px;
        }
        
        .config-label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #00ff88;
        }
        
        .config-input {
            width: 100%;
            padding: 8px;
            border: 1px solid rgba(0, 255, 136, 0.3);
            border-radius: 4px;
            background: rgba(0, 0, 0, 0.5);
            color: white;
            font-size: 14px;
        }
        
        .config-input:focus {
            outline: none;
            border-color: #00ff88;
            box-shadow: 0 0 10px rgba(0, 255, 136, 0.3);
        }
        
        .metrics-panel {
            position: fixed;
            top: 80px;
            right: 20px;
            width: 300px;
            background: rgba(0, 0, 0, 0.8);
            padding: 20px;
            border-radius: 10px;
            border: 1px solid rgba(0, 255, 136, 0.3);
            backdrop-filter: blur(10px);
            max-height: calc(100vh - 120px);
            overflow-y: auto;
        }
        
        .metric {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            padding: 8px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 5px;
        }
        
        .metric-label {
            font-weight: bold;
            color: #00ff88;
        }
        
        .metric-value {
            color: white;
            font-family: 'Courier New', monospace;
        }
        
        .canvas-container {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 1;
        }
        
        .status-indicator {
            display: inline-block;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            margin-right: 8px;
        }
        
        .status-running {
            background: #00ff88;
            animation: pulse 1s infinite;
            box-shadow: 0 0 10px rgba(0, 255, 136, 0.5);
        }
        
        .status-stopped {
            background: #ff4444;
            box-shadow: 0 0 10px rgba(255, 68, 68, 0.5);
        }
        
        @keyframes pulse {
            0% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.7; transform: scale(1.1); }
            100% { opacity: 1; transform: scale(1); }
        }
        
        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 15px 20px;
            border-radius: 5px;
            color: white;
            font-weight: bold;
            z-index: 10000;
            max-width: 300px;
            animation: slideIn 0.3s ease-out;
        }
        
        @keyframes slideIn {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
        
        @keyframes slideOut {
            from { transform: translateX(0); opacity: 1; }
            to { transform: translateX(100%); opacity: 0; }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="title">
            <span class="status-indicator" id="statusIndicator"></span>
            <span id="titleText">Unified 3D Drone Swarm Sync</span>
        </div>
        <div class="controls">
            <button class="btn btn-start" onclick="startSimulation()" id="startBtn">Запустить</button>
            <button class="btn btn-stop" onclick="stopSimulation()">Остановить</button>
        </div>
    </div>
    
    <div class="config-panel">
        <h3 style="margin-top: 0; color: #00ff88;">⚙️ Конфигурация</h3>
        <div class="config-group">
            <label class="config-label">Количество дронов:</label>
            <input type="number" id="numDrones" class="config-input" value="20" min="5" max="50">
        </div>
        <div class="config-group">
            <label class="config-label">Радиус роя (м):</label>
            <input type="number" id="radius" class="config-input" value="100" min="50" max="200">
        </div>
        <div class="config-group">
            <label class="config-label">Высота (м):</label>
            <input type="number" id="height" class="config-input" value="50" min="20" max="100">
        </div>
        <button class="btn btn-start" onclick="updateConfig()" style="width: 100%; margin-top: 10px;">Обновить</button>
    </div>
    
    <div class="metrics-panel">
        <h3 style="margin-top: 0; color: #00ff88;">📊 Метрики синхронизации</h3>
        <div class="metric">
            <div class="metric-label">Время симуляции</div>
            <div class="metric-value" id="simTime">0.0с</div>
        </div>
        <div class="metric">
            <div class="metric-label">Среднее смещение</div>
            <div class="metric-value" id="avgOffset">0.00 нс</div>
        </div>
        <div class="metric">
            <div class="metric-label">Качество синхронизации</div>
            <div class="metric-value" id="syncQuality">0.000</div>
        </div>
        <div class="metric">
            <div class="metric-label">Точность роя</div>
            <div class="metric-value" id="swarmAccuracy">0.00 нс</div>
        </div>
        <div class="metric">
            <div class="metric-label">Расхождение времени</div>
            <div class="metric-value" id="timeDivergence">0.00 нс</div>
        </div>
        <div class="metric">
            <div class="metric-label">DPLL заблокированы</div>
            <div class="metric-value" id="dpllLocked">0/20</div>
        </div>
        <div class="metric">
            <div class="metric-label">События синхронизации</div>
            <div class="metric-value" id="syncEvents">0</div>
        </div>
        <div class="metric">
            <div class="metric-label">Уровень батареи</div>
            <div class="metric-value" id="batteryLevel">0.00</div>
        </div>
        <div class="metric">
            <div class="metric-label">Сила сигнала</div>
            <div class="metric-value" id="signalStrength">0.00</div>
        </div>
        <div class="metric">
            <div class="metric-label">Температура</div>
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
        let swarmData = [];
        let isSimulationRunning = false;
        
        // Инициализация Three.js
        function initThreeJS() {
            try {
                console.log('🔧 Инициализация Three.js...');
                
                // Проверяем, что THREE загружен
                if (typeof THREE === 'undefined') {
                    console.error('❌ THREE.js не загружен!');
                    showNotification('Ошибка: THREE.js не загружен', 'error');
                    return;
                }
                
                console.log('✅ THREE.js загружен, версия:', THREE.REVISION);
                
                // Сцена
                scene = new THREE.Scene();
                scene.background = new THREE.Color(0x0a0a1a);
                scene.fog = new THREE.Fog(0x0a0a1a, 200, 1000);
                
                // Камера
                camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 2000);
                camera.position.set(200, 150, 200);
                
                // Рендерер
                renderer = new THREE.WebGLRenderer({ 
                    canvas: document.getElementById('canvas'), 
                    antialias: true,
                    alpha: true
                });
                renderer.setSize(window.innerWidth, window.innerHeight);
                renderer.shadowMap.enabled = true;
                renderer.shadowMap.type = THREE.PCFSoftShadowMap;
                
                // Контролы
                controls = new THREE.OrbitControls(camera, renderer.domElement);
                controls.enableDamping = true;
                controls.dampingFactor = 0.05;
                controls.screenSpacePanning = false;
                controls.minDistance = 50;
                controls.maxDistance = 500;
                controls.maxPolarAngle = Math.PI / 2;
                
                // Освещение
                const ambientLight = new THREE.AmbientLight(0x404040, 0.4);
                scene.add(ambientLight);
                
                const directionalLight = new THREE.DirectionalLight(0xffffff, 0.8);
                directionalLight.position.set(100, 100, 50);
                directionalLight.castShadow = true;
                directionalLight.shadow.mapSize.width = 2048;
                directionalLight.shadow.mapSize.height = 2048;
                directionalLight.shadow.camera.near = 0.5;
                directionalLight.shadow.camera.far = 500;
                scene.add(directionalLight);
                
                // Точечный свет
                const pointLight = new THREE.PointLight(0x00ff88, 0.5, 300);
                pointLight.position.set(0, 100, 0);
                scene.add(pointLight);
                
                // Сетка
                const gridHelper = new THREE.GridHelper(400, 40, 0x00ff88, 0x333333);
                gridHelper.material.opacity = 0.3;
                gridHelper.material.transparent = true;
                scene.add(gridHelper);
                
                // Оси координат
                const axesHelper = new THREE.AxesHelper(100);
                scene.add(axesHelper);
                
                animate();
                console.log('✅ Three.js инициализирован успешно');
                showNotification('3D визуализация готова!', 'success');
            } catch (error) {
                console.error('❌ Ошибка инициализации Three.js:', error);
                showNotification('Ошибка 3D визуализации: ' + error.message, 'error');
            }
        }
        
        // Анимация
        function animate() {
            requestAnimationFrame(animate);
            controls.update();
            
            // Анимация дронов
            droneMeshes.forEach((mesh, index) => {
                if (mesh.userData.isMaster) {
                    mesh.rotation.y += 0.02;
                    mesh.children[mesh.children.length - 1].scale.setScalar(1 + 0.1 * Math.sin(Date.now() * 0.005));
                } else {
                    mesh.rotation.y += 0.01;
                }
            });
            
            renderer.render(scene, camera);
        }
        
        // Создание дрона
        function createDroneMesh(droneData) {
            console.log('🔨 Создание меша для дрона:', droneData.id, 'тип:', droneData.clock_type);
            
            const group = new THREE.Group();
            group.userData = { isMaster: droneData.is_master };
            
            // Основное тело дрона - увеличиваем размер для лучшей видимости
            const bodyGeometry = new THREE.BoxGeometry(6, 2, 6);
            const bodyMaterial = new THREE.MeshBasicMaterial({ 
                color: getDroneColor(droneData.clock_type),
                transparent: false,
                wireframe: false
            });
            const body = new THREE.Mesh(bodyGeometry, bodyMaterial);
            body.castShadow = true;
            body.receiveShadow = true;
            group.add(body);
            
            console.log('✅ Создан базовый меш для дрона', droneData.id);
            
            // Мастер-индикатор - простая сфера сверху
            if (droneData.is_master) {
                const masterGeometry = new THREE.SphereGeometry(2, 16, 12);
                const masterMaterial = new THREE.MeshBasicMaterial({ 
                    color: 0xffff00
                });
                const masterIndicator = new THREE.Mesh(masterGeometry, masterMaterial);
                masterIndicator.position.set(0, 4, 0);
                group.add(masterIndicator);
                console.log('👑 Добавлен индикатор мастера для дрона', droneData.id);
            }
            
            console.log('🏁 Завершено создание дрона', droneData.id, 'позиция:', droneData.position);
            return group;
        }
        
        // Получение цвета дрона по типу часов
        function getDroneColor(clockType) {
            switch(clockType) {
                case 'rubidium': return 0xff3366; // Ярко-красный
                case 'ocxo': return 0x33ff66;     // Ярко-зеленый
                case 'tcxo': return 0x3366ff;     // Ярко-синий
                case 'quartz': return 0xffff33;   // Ярко-желтый
                default: return 0x888888;         // Серый
            }
        }
        
        // Обновление дронов
        function updateDrones(dronesData) {
            try {
                console.log('🔄 Обновление дронов, получено:', dronesData.length, 'дронов');
                
                // Удаляем старые меши
                droneMeshes.forEach(mesh => scene.remove(mesh));
                droneMeshes = [];
                
                // Создаем новые меши
                dronesData.forEach((droneData, index) => {
                    console.log(`Создание дрона ${index}:`, droneData);
                    const droneMesh = createDroneMesh(droneData);
                    
                    // Правильное позиционирование: x, y, z
                    const x = droneData.position[0];
                    const y = droneData.position[1];
                    const z = droneData.position[2];
                    
                    droneMesh.position.set(x, z, y); // Three.js: x, y(высота), z
                    console.log(`📍 Позиция дрона ${index}: x=${x}, y=${y}, z=${z} -> Three.js(${x}, ${z}, ${y})`);
                    
                    scene.add(droneMesh);
                    droneMeshes.push(droneMesh);
                });
                
                console.log('✅ Создано дронов:', droneMeshes.length);
            } catch (error) {
                console.error('❌ Ошибка обновления дронов:', error);
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
                } else {
                    // Сброс метрик
                    document.getElementById('simTime').textContent = '0.0с';
                    document.getElementById('avgOffset').textContent = '0.00 нс';
                    document.getElementById('syncQuality').textContent = '0.000';
                    document.getElementById('swarmAccuracy').textContent = '0.00 нс';
                    document.getElementById('timeDivergence').textContent = '0.00 нс';
                    document.getElementById('dpllLocked').textContent = '0/' + (statusData.num_drones || 0);
                    document.getElementById('syncEvents').textContent = '0';
                    document.getElementById('batteryLevel').textContent = '0.00';
                    document.getElementById('signalStrength').textContent = '0.00';
                    document.getElementById('temperature').textContent = '0.0°C';
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
                titleText.textContent = '🟢 Unified 3D Drone Swarm Sync (АКТИВНА)';
                titleText.style.color = '#00ff88';
            } else {
                indicator.className = 'status-indicator status-stopped';
                titleText.textContent = '🔴 Unified 3D Drone Swarm Sync (ОСТАНОВЛЕНА)';
                titleText.style.color = '#ff4444';
            }
            isSimulationRunning = running;
        }
        
        // Функция уведомлений
        function showNotification(message, type = 'info') {
            const notification = document.createElement('div');
            notification.className = 'notification';
            
            switch(type) {
                case 'success':
                    notification.style.background = '#00ff88';
                    notification.style.color = '#000';
                    break;
                case 'error':
                    notification.style.background = '#ff4444';
                    break;
                default:
                    notification.style.background = '#2196F3';
            }
            
            notification.textContent = message;
            document.body.appendChild(notification);
            
            setTimeout(() => {
                notification.style.animation = 'slideOut 0.3s ease-in';
                setTimeout(() => {
                    if (notification.parentNode) {
                        notification.parentNode.removeChild(notification);
                    }
                }, 300);
            }, 3000);
        }
        
        // API функции
        async function startSimulation() {
            try {
                const startBtn = document.getElementById('startBtn');
                const originalText = startBtn.textContent;
                startBtn.textContent = 'Запуск...';
                startBtn.disabled = true;
                
                console.log('🚀 Запуск симуляции...');
                const response = await fetch('/api/start');
                const data = await response.json();
                
                if (response.ok && data.status === 'started') {
                    updateStatus(true);
                    startDataPolling();
                    showNotification('Симуляция запущена успешно!', 'success');
                    console.log('✅ Симуляция запущена');
                } else {
                    showNotification('Ошибка запуска: ' + (data.message || 'Неизвестная ошибка'), 'error');
                }
            } catch (error) {
                console.error('❌ Ошибка запуска:', error);
                showNotification('Ошибка запуска: ' + error.message, 'error');
            } finally {
                const startBtn = document.getElementById('startBtn');
                startBtn.textContent = 'Запустить';
                startBtn.disabled = false;
            }
        }
        
        async function stopSimulation() {
            try {
                const response = await fetch('/api/stop');
                const data = await response.json();
                
                if (response.ok) {
                    updateStatus(false);
                    showNotification('Симуляция остановлена', 'info');
                }
            } catch (error) {
                console.error('❌ Ошибка остановки:', error);
                showNotification('Ошибка остановки: ' + error.message, 'error');
            }
        }
        
        async function updateConfig() {
            try {
                const numDrones = document.getElementById('numDrones').value;
                const radius = document.getElementById('radius').value;
                const height = document.getElementById('height').value;
                
                const response = await fetch(`/api/update_config?num_drones=${numDrones}&radius=${radius}&height=${height}`);
                if (response.ok) {
                    showNotification('Конфигурация обновлена', 'success');
                }
            } catch (error) {
                console.error('❌ Ошибка обновления конфигурации:', error);
                showNotification('Ошибка обновления конфигурации', 'error');
            }
        }
        
        // Опрос данных
        function startDataPolling() {
            const pollData = async () => {
                if (!isSimulationRunning) return;
                
                try {
                    // Получаем статус
                    const statusResponse = await fetch('/api/status');
                    if (statusResponse.ok) {
                        const statusData = await statusResponse.json();
                        updateMetrics(statusData);
                    }
                    
                    // Получаем данные дронов
                    const dronesResponse = await fetch('/api/drones');
                    if (dronesResponse.ok) {
                        const dronesData = await dronesResponse.json();
                        console.log('📡 Получены данные дронов:', dronesData);
                        updateDrones(dronesData);
                    } else {
                        console.error('❌ Ошибка получения данных дронов:', dronesResponse.status);
                    }
                } catch (error) {
                    console.error('❌ Ошибка получения данных:', error);
                }
                
                setTimeout(pollData, 100); // Опрос каждые 100мс
            };
            
            pollData();
        }
        
        // Обработка изменения размера окна
        window.addEventListener('resize', () => {
            camera.aspect = window.innerWidth / window.innerHeight;
            camera.updateProjectionMatrix();
            renderer.setSize(window.innerWidth, window.innerHeight);
        });
        
        // Инициализация
        window.addEventListener('load', () => {
            initThreeJS();
            updateStatus(false);
            
            setTimeout(() => {
                showNotification('Веб-симуляция готова! Нажмите "Запустить" для начала.', 'info');
            }, 1000);
        });
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
        try:
            if not self.simulation_running:
                self.simulation_running = True
                
                # Создание роя
                self.swarm = UltraPreciseSwarm(
                    self.swarm_config['num_drones'],
                    self.swarm_config['radius'],
                    self.swarm_config['height']
                )
                
                # Запуск потока симуляции
                self.simulation_thread = threading.Thread(target=self._simulation_loop)
                self.simulation_thread.daemon = True
                self.simulation_thread.start()
                
                print(f"✅ Симуляция запущена с {self.swarm_config['num_drones']} дронами")
                self.send_json_response({'status': 'started', 'message': 'Симуляция запущена'})
            else:
                self.send_json_response({'status': 'already_running', 'message': 'Симуляция уже запущена'})
        except Exception as e:
            print(f"❌ Ошибка запуска симуляции: {e}")
            self.send_json_response({'status': 'error', 'message': str(e)})
    
    def stop_simulation(self):
        """Остановка симуляции"""
        try:
            self.simulation_running = False
            print("⏹️ Симуляция остановлена")
            self.send_json_response({'status': 'stopped', 'message': 'Симуляция остановлена'})
        except Exception as e:
            print(f"❌ Ошибка остановки симуляции: {e}")
            self.send_json_response({'status': 'error', 'message': str(e)})
    
    def get_simulation_status(self):
        """Получение статуса симуляции"""
        try:
            if self.swarm and self.simulation_running:
                status = self.swarm.get_swarm_status()
                status['running'] = self.simulation_running
                status['message'] = 'Симуляция активна'
                self.send_json_response(status)
            else:
                self.send_json_response({
                    'running': False,
                    'simulation_time': 0.0,
                    'avg_time_offset': 0.0,
                    'avg_sync_quality': 0.0,
                    'dpll_locked_count': 0,
                    'wwvb_sync_count': 0,
                    'avg_battery_level': 0.0,
                    'avg_signal_strength': 0.0,
                    'avg_temperature': 0.0,
                    'swarm_sync_accuracy': 0.0,
                    'swarm_time_divergence': 0.0,
                    'num_drones': self.swarm_config['num_drones'],
                    'message': 'Симуляция не запущена'
                })
        except Exception as e:
            print(f"❌ Ошибка получения статуса: {e}")
            self.send_json_response({
                'running': False,
                'error': str(e),
                'message': 'Ошибка получения статуса'
            })
    
    def get_drones_data(self):
        """Получение данных дронов"""
        try:
            if self.swarm and self.simulation_running:
                drones_data = [drone.get_status() for drone in self.swarm.drones]
                self.send_json_response(drones_data)
            else:
                self.send_json_response([])
        except Exception as e:
            print(f"❌ Ошибка получения данных дронов: {e}")
            self.send_json_response([])
    
    def get_config(self):
        """Получение конфигурации"""
        self.send_json_response(self.swarm_config)
    
    def update_config(self, query_params):
        """Обновление конфигурации"""
        try:
            if 'num_drones' in query_params:
                self.swarm_config['num_drones'] = int(query_params['num_drones'][0])
            if 'radius' in query_params:
                self.swarm_config['radius'] = float(query_params['radius'][0])
            if 'height' in query_params:
                self.swarm_config['height'] = float(query_params['height'][0])
            
            self.send_json_response({'status': 'updated'})
        except Exception as e:
            print(f"❌ Ошибка обновления конфигурации: {e}")
            self.send_json_response({'status': 'error', 'message': str(e)})
    
    def _simulation_loop(self):
        """Основной цикл симуляции"""
        dt = 0.1
        while self.simulation_running:
            if self.swarm:
                self.swarm.update(dt)
            time.sleep(dt)
    
    def send_json_response(self, data):
        """Отправка JSON ответа"""
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()
        self.wfile.write(json.dumps(data, ensure_ascii=False).encode('utf-8'))


def run_unified_3d_web_server(port=8080):
    """Запуск единого 3D веб-сервера"""
    server_address = ('', port)
    httpd = HTTPServer(server_address, Unified3DWebHandler)
    
    print("🚀 Запуск Unified 3D Web Server")
    print(f"🌐 Откройте браузер: http://localhost:{port}")
    print("🎯 3D визуализация с ультра-точными алгоритмами")
    print("⚡ Точность синхронизации: 10-100 наносекунд")
    print("⏹️ Для остановки нажмите Ctrl+C")
    
    # Автоматическое открытие браузера
    try:
        webbrowser.open(f'http://localhost:{port}')
    except:
        pass
    
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n⏹️ Остановка сервера...")
        httpd.shutdown()
        print("✅ Сервер остановлен")


if __name__ == "__main__":
    run_unified_3d_web_server()
