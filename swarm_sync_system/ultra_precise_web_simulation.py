#!/usr/bin/env python3
"""
Ultra Precise Web Simulation - веб-версия ультра-точной симуляции
Включает:
- HTTP сервер с API
- 3D визуализацию с Three.js
- Ультра-точные алгоритмы синхронизации
- Интерактивное управление
"""
import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

import json
import time
import threading
import random
import math
from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse, parse_qs
import webbrowser

# Импорт ультра-точных компонентов
from ultra_precise_sync_simulation import UltraPreciseSwarm, UltraPreciseDrone


class UltraPreciseWebHandler(BaseHTTPRequestHandler):
    """HTTP обработчик для ультра-точной веб-симуляции"""
    
    # Глобальные переменные для симуляции
    swarm = None
    simulation_thread = None
    simulation_running = False
    simulation_speed = 1.0
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
    <title>Ultra Precise Drone Swarm Sync</title>
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
            padding: 10px 20px;
            z-index: 1000;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .title {
            font-size: 24px;
            font-weight: bold;
            color: #00ff88;
        }
        
        .controls {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            transition: all 0.3s;
        }
        
        .btn-start {
            background: #00ff88;
            color: #000;
        }
        
        .btn-stop {
            background: #ff4444;
            color: white;
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.3);
        }
        
        .metrics-panel {
            position: fixed;
            top: 80px;
            right: 20px;
            width: 300px;
            background: rgba(0, 0, 0, 0.8);
            border-radius: 10px;
            padding: 15px;
            z-index: 1000;
            max-height: calc(100vh - 120px);
            overflow-y: auto;
        }
        
        .metric {
            margin-bottom: 10px;
            padding: 8px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 5px;
        }
        
        .metric-label {
            font-size: 12px;
            color: #ccc;
            margin-bottom: 2px;
        }
        
        .metric-value {
            font-size: 16px;
            font-weight: bold;
            color: #00ff88;
        }
        
        .canvas-container {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }
        
        #canvas {
            width: 100%;
            height: 100%;
        }
        
        .config-panel {
            position: fixed;
            top: 80px;
            left: 20px;
            width: 250px;
            background: rgba(0, 0, 0, 0.8);
            border-radius: 10px;
            padding: 15px;
            z-index: 1000;
        }
        
        .config-group {
            margin-bottom: 15px;
        }
        
        .config-label {
            display: block;
            margin-bottom: 5px;
            font-size: 14px;
            color: #ccc;
        }
        
        .config-input {
            width: 100%;
            padding: 5px;
            border: none;
            border-radius: 3px;
            background: rgba(255, 255, 255, 0.2);
            color: white;
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
        }
        
        .status-stopped {
            background: #ff4444;
        }
        
        @keyframes pulse {
            0% { opacity: 1; }
            50% { opacity: 0.5; }
            100% { opacity: 1; }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="title">
            <span class="status-indicator" id="statusIndicator"></span>
            Ultra Precise Drone Swarm Sync
        </div>
        <div class="controls">
            <button class="btn btn-start" onclick="startSimulation()">Запустить</button>
            <button class="btn btn-stop" onclick="stopSimulation()">Остановить</button>
        </div>
    </div>
    
    <div class="config-panel">
        <h3>Конфигурация</h3>
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
        <button class="btn btn-start" onclick="updateConfig()">Обновить</button>
    </div>
    
    <div class="metrics-panel">
        <h3>Метрики синхронизации</h3>
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
            <div class="metric-label">WWVB синхронизации</div>
            <div class="metric-value" id="wwvbSync">0</div>
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
                // Сцена
                scene = new THREE.Scene();
                scene.background = new THREE.Color(0x1a1a2e);
            
            // Камера
            camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
            camera.position.set(200, 150, 200);
            
            // Рендерер
            renderer = new THREE.WebGLRenderer({ canvas: document.getElementById('canvas'), antialias: true });
            renderer.setSize(window.innerWidth, window.innerHeight);
            renderer.shadowMap.enabled = true;
            renderer.shadowMap.type = THREE.PCFSoftShadowMap;
            
            // Контролы
            controls = new THREE.OrbitControls(camera, renderer.domElement);
            controls.enableDamping = true;
            controls.dampingFactor = 0.05;
            
            // Освещение
            const ambientLight = new THREE.AmbientLight(0x404040, 0.6);
            scene.add(ambientLight);
            
            const directionalLight = new THREE.DirectionalLight(0xffffff, 0.8);
            directionalLight.position.set(100, 100, 50);
            directionalLight.castShadow = true;
            directionalLight.shadow.mapSize.width = 2048;
            directionalLight.shadow.mapSize.height = 2048;
            scene.add(directionalLight);
            
            // Сетка
            const gridHelper = new THREE.GridHelper(300, 30, 0x444444, 0x222222);
            scene.add(gridHelper);
            
                            // Оси координат
                const axesHelper = new THREE.AxesHelper(50);
                scene.add(axesHelper);
                
                animate();
                console.log('✅ Three.js инициализирован успешно');
            } catch (error) {
                console.error('❌ Ошибка инициализации Three.js:', error);
                showNotification('Ошибка 3D визуализации: ' + error.message, 'error');
            }
        }
        }
        
        // Анимация
        function animate() {
            requestAnimationFrame(animate);
            controls.update();
            renderer.render(scene, camera);
        }
        
        // Создание дрона
        function createDroneMesh(droneData) {
            const group = new THREE.Group();
            
            // Основное тело дрона (куб)
            const bodyGeometry = new THREE.BoxGeometry(2, 0.5, 2);
            const bodyMaterial = new THREE.MeshLambertMaterial({ 
                color: getDroneColor(droneData.clock_type),
                transparent: true,
                opacity: 0.8
            });
            const body = new THREE.Mesh(bodyGeometry, bodyMaterial);
            body.castShadow = true;
            group.add(body);
            
            // Роторы (4 цилиндра)
            const rotorGeometry = new THREE.CylinderGeometry(0.1, 0.1, 0.1, 8);
            const rotorMaterial = new THREE.MeshLambertMaterial({ color: 0x666666 });
            
            const rotorPositions = [
                [-1.5, 0.3, -1.5], [1.5, 0.3, -1.5],
                [-1.5, 0.3, 1.5], [1.5, 0.3, 1.5]
            ];
            
            rotorPositions.forEach(pos => {
                const rotor = new THREE.Mesh(rotorGeometry, rotorMaterial);
                rotor.position.set(...pos);
                rotor.castShadow = true;
                group.add(rotor);
            });
            
            // Антенна (тонкий цилиндр)
            const antennaGeometry = new THREE.CylinderGeometry(0.05, 0.05, 1, 8);
            const antennaMaterial = new THREE.MeshLambertMaterial({ color: 0x888888 });
            const antenna = new THREE.Mesh(antennaGeometry, antennaMaterial);
            antenna.position.set(0, 0.75, 0);
            group.add(antenna);
            
            // Мастер-индикатор
            if (droneData.is_master) {
                const masterGeometry = new THREE.SphereGeometry(0.3, 8, 6);
                const masterMaterial = new THREE.MeshLambertMaterial({ 
                    color: 0xffff00,
                    emissive: 0xffff00,
                    emissiveIntensity: 0.3
                });
                const masterIndicator = new THREE.Mesh(masterGeometry, masterMaterial);
                masterIndicator.position.set(0, 1.5, 0);
                group.add(masterIndicator);
            }
            
            return group;
        }
        
        // Получение цвета дрона по типу часов
        function getDroneColor(clockType) {
            switch(clockType) {
                case 'rubidium': return 0xff0000; // Красный
                case 'ocxo': return 0x00ff00;     // Зеленый
                case 'tcxo': return 0x0000ff;     // Синий
                case 'quartz': return 0xffff00;   // Желтый
                default: return 0x888888;         // Серый
            }
        }
        
        // Обновление дронов
        function updateDrones(dronesData) {
            // Удаляем старые меши
            droneMeshes.forEach(mesh => scene.remove(mesh));
            droneMeshes = [];
            
            // Создаем новые меши
            dronesData.forEach(droneData => {
                const droneMesh = createDroneMesh(droneData);
                droneMesh.position.set(droneData.position[0], droneData.position[1], droneData.position[2]);
                scene.add(droneMesh);
                droneMeshes.push(droneMesh);
            });
        }
        
        // Обновление метрик
        function updateMetrics(statusData) {
            try {
                console.log('📊 Обновление метрик:', statusData);
                
                if (statusData.running) {
                    document.getElementById('simTime').textContent = (statusData.simulation_time || 0).toFixed(1) + 'с';
                    document.getElementById('avgOffset').textContent = (statusData.avg_time_offset || 0).toFixed(2) + ' нс';
                    document.getElementById('syncQuality').textContent = (statusData.avg_sync_quality || 0).toFixed(3);
                    document.getElementById('swarmAccuracy').textContent = (statusData.swarm_sync_accuracy || 0).toFixed(2) + ' нс';
                    document.getElementById('timeDivergence').textContent = (statusData.swarm_time_divergence || 0).toFixed(2) + ' нс';
                    document.getElementById('dpllLocked').textContent = (statusData.dpll_locked_count || 0) + '/' + (statusData.num_drones || 0);
                    document.getElementById('wwvbSync').textContent = (statusData.wwvb_sync_count || 0);
                    document.getElementById('batteryLevel').textContent = (statusData.avg_battery_level || 0).toFixed(2);
                    document.getElementById('signalStrength').textContent = (statusData.avg_signal_strength || 0).toFixed(2);
                    document.getElementById('temperature').textContent = (statusData.avg_temperature || 0).toFixed(1) + '°C';
                } else {
                    // Сброс метрик если симуляция не запущена
                    document.getElementById('simTime').textContent = '0.0с';
                    document.getElementById('avgOffset').textContent = '0.00 нс';
                    document.getElementById('syncQuality').textContent = '0.000';
                    document.getElementById('swarmAccuracy').textContent = '0.00 нс';
                    document.getElementById('timeDivergence').textContent = '0.00 нс';
                    document.getElementById('dpllLocked').textContent = '0/' + (statusData.num_drones || 0);
                    document.getElementById('wwvbSync').textContent = '0';
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
            const title = document.querySelector('.title');
            
            if (running) {
                indicator.className = 'status-indicator status-running';
                title.style.color = '#00ff88';
                title.textContent = '🟢 Ultra Precise Drone Swarm Sync (АКТИВНА)';
            } else {
                indicator.className = 'status-indicator status-stopped';
                title.style.color = '#ff4444';
                title.textContent = '🔴 Ultra Precise Drone Swarm Sync (ОСТАНОВЛЕНА)';
            }
            isSimulationRunning = running;
        }
        
        // API функции
        async function startSimulation() {
            try {
                console.log('🚀 Запуск симуляции...');
                
                // Показываем индикатор загрузки
                const startBtn = document.querySelector('.btn-start');
                const originalText = startBtn.textContent;
                startBtn.textContent = 'Запуск...';
                startBtn.disabled = true;
                
                const response = await fetch('/api/start');
                const data = await response.json();
                console.log('Ответ сервера:', data);
                
                if (response.ok && data.status === 'started') {
                    updateStatus(true);
                    startDataPolling();
                    console.log('✅ Симуляция запущена успешно');
                    
                    // Показываем уведомление
                    showNotification('Симуляция запущена успешно!', 'success');
                } else {
                    console.error('❌ Ошибка запуска:', data.message || 'Неизвестная ошибка');
                    showNotification('Ошибка запуска: ' + (data.message || 'Неизвестная ошибка'), 'error');
                }
            } catch (error) {
                console.error('❌ Ошибка запуска симуляции:', error);
                showNotification('Ошибка запуска: ' + error.message, 'error');
            } finally {
                // Восстанавливаем кнопку
                const startBtn = document.querySelector('.btn-start');
                startBtn.textContent = 'Запустить';
                startBtn.disabled = false;
            }
        }
        
        async function stopSimulation() {
            try {
                console.log('⏹️ Остановка симуляции...');
                const response = await fetch('/api/stop');
                const data = await response.json();
                console.log('Ответ сервера:', data);
                
                if (response.ok) {
                    updateStatus(false);
                    console.log('✅ Симуляция остановлена');
                } else {
                    console.error('❌ Ошибка остановки:', data.message || 'Неизвестная ошибка');
                }
            } catch (error) {
                console.error('❌ Ошибка остановки симуляции:', error);
                alert('Ошибка остановки симуляции: ' + error.message);
            }
        }
        
        async function updateConfig() {
            try {
                const numDrones = document.getElementById('numDrones').value;
                const radius = document.getElementById('radius').value;
                const height = document.getElementById('height').value;
                
                const response = await fetch(`/api/update_config?num_drones=${numDrones}&radius=${radius}&height=${height}`);
                if (response.ok) {
                    console.log('Конфигурация обновлена');
                }
            } catch (error) {
                console.error('Ошибка обновления конфигурации:', error);
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
                        updateDrones(dronesData);
                    }
                } catch (error) {
                    console.error('Ошибка получения данных:', error);
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
        
        // Функция уведомлений
        function showNotification(message, type = 'info') {
            // Создаем элемент уведомления
            const notification = document.createElement('div');
            notification.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                padding: 15px 20px;
                border-radius: 5px;
                color: white;
                font-weight: bold;
                z-index: 10000;
                animation: slideIn 0.3s ease-out;
                max-width: 300px;
            `;
            
            // Цвета для разных типов
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
            
            // Удаляем через 3 секунды
            setTimeout(() => {
                notification.style.animation = 'slideOut 0.3s ease-in';
                setTimeout(() => {
                    if (notification.parentNode) {
                        notification.parentNode.removeChild(notification);
                    }
                }, 300);
            }, 3000);
        }
        
        // CSS анимации для уведомлений
        const style = document.createElement('style');
        style.textContent = `
            @keyframes slideIn {
                from { transform: translateX(100%); opacity: 0; }
                to { transform: translateX(0); opacity: 1; }
            }
            @keyframes slideOut {
                from { transform: translateX(0); opacity: 1; }
                to { transform: translateX(100%); opacity: 0; }
            }
        `;
        document.head.appendChild(style);
        
        // Инициализация
        window.addEventListener('load', () => {
            initThreeJS();
            updateStatus(false);
            
            // Показываем приветственное сообщение
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
        if 'num_drones' in query_params:
            self.swarm_config['num_drones'] = int(query_params['num_drones'][0])
        if 'radius' in query_params:
            self.swarm_config['radius'] = float(query_params['radius'][0])
        if 'height' in query_params:
            self.swarm_config['height'] = float(query_params['height'][0])
        
        self.send_json_response({'status': 'updated'})
    
    def _simulation_loop(self):
        """Основной цикл симуляции"""
        dt = 0.1
        while self.simulation_running:
            if self.swarm:
                self.swarm.update(dt)
            time.sleep(dt / self.simulation_speed)
    
    def send_json_response(self, data):
        """Отправка JSON ответа"""
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()
        self.wfile.write(json.dumps(data, ensure_ascii=False).encode('utf-8'))


def run_ultra_precise_web_server(port=8080):
    """Запуск веб-сервера ультра-точной симуляции"""
    server_address = ('', port)
    httpd = HTTPServer(server_address, UltraPreciseWebHandler)
    
    print(f"🚀 Запуск Ultra Precise Web сервера на порту {port}")
    print(f"🌐 Откройте браузер: http://localhost:{port}")
    print("🔧 Ультра-точные алгоритмы для получения 10-100 наносекунд")
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
    run_ultra_precise_web_server()
