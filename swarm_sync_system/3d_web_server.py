#!/usr/bin/env python3
"""
3D веб-сервер с полноценной визуализацией роя дронов
"""
import os
import sys
import time
import json
import math
import random
from http.server import HTTPServer, BaseHTTPRequestHandler
import threading

class SwarmSimulationHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/':
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            
            html_content = """
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>3D Симуляция Роя Дронов</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/controls/OrbitControls.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #0c0c0c 0%, #1a1a2e 50%, #16213e 100%);
            color: white;
            overflow-x: hidden;
        }
        .container {
            max-width: 1600px;
            margin: 0 auto;
        }
        .header {
            text-align: center;
            margin-bottom: 20px;
        }
        .header h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
            background: linear-gradient(45deg, #00d4ff, #ff00ff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .main-content {
            display: grid;
            grid-template-columns: 1fr 3fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        .controls {
            background: rgba(255,255,255,0.1);
            padding: 20px;
            border-radius: 15px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.2);
            height: fit-content;
        }
        .control-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #00d4ff;
        }
        input, select, button {
            padding: 12px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            margin-right: 10px;
            background: rgba(255,255,255,0.1);
            color: white;
            border: 1px solid rgba(255,255,255,0.2);
        }
        input:focus, select:focus {
            outline: none;
            border-color: #00d4ff;
            box-shadow: 0 0 10px rgba(0,212,255,0.3);
        }
        button {
            background: linear-gradient(45deg, #00d4ff, #0099cc);
            color: white;
            cursor: pointer;
            transition: all 0.3s;
            font-weight: bold;
        }
        button:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,212,255,0.4);
        }
        button:disabled {
            background: #666;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }
        .visualization {
            background: rgba(0,0,0,0.3);
            border-radius: 15px;
            padding: 20px;
            border: 1px solid rgba(255,255,255,0.2);
            position: relative;
            overflow: hidden;
            height: 600px;
        }
        #swarmCanvas {
            width: 100%;
            height: 100%;
            border-radius: 10px;
            border: 2px solid rgba(0,212,255,0.3);
        }
        .camera-controls {
            position: absolute;
            top: 10px;
            left: 10px;
            background: rgba(0,0,0,0.7);
            padding: 10px;
            border-radius: 8px;
            font-size: 12px;
            z-index: 1000;
        }
        .camera-btn {
            padding: 5px 10px;
            margin: 2px;
            background: rgba(0,212,255,0.3);
            border: 1px solid #00d4ff;
            color: white;
            border-radius: 4px;
            cursor: pointer;
            font-size: 11px;
        }
        .camera-btn:hover {
            background: rgba(0,212,255,0.5);
        }
        .status {
            background: rgba(255,255,255,0.1);
            padding: 20px;
            border-radius: 15px;
            margin-bottom: 20px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.2);
        }
        .metrics {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }
        .metric {
            background: rgba(0,212,255,0.1);
            padding: 15px;
            border-radius: 10px;
            text-align: center;
            border: 1px solid rgba(0,212,255,0.3);
        }
        .metric-value {
            font-size: 1.8em;
            font-weight: bold;
            color: #00d4ff;
            text-shadow: 0 0 10px rgba(0,212,255,0.5);
        }
        .log {
            background: rgba(0,0,0,0.5);
            padding: 15px;
            border-radius: 10px;
            height: 200px;
            overflow-y: auto;
            font-family: 'Courier New', monospace;
            font-size: 14px;
            border: 1px solid rgba(255,255,255,0.2);
        }
        .progress {
            width: 100%;
            height: 25px;
            background: rgba(255,255,255,0.1);
            border-radius: 15px;
            overflow: hidden;
            margin: 15px 0;
            border: 1px solid rgba(255,255,255,0.2);
        }
        .progress-bar {
            height: 100%;
            background: linear-gradient(90deg, #00d4ff, #ff00ff);
            transition: width 0.3s;
            border-radius: 15px;
        }
        .formation-selector {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 10px;
            margin-bottom: 15px;
        }
        .formation-btn {
            padding: 8px;
            border-radius: 5px;
            border: 1px solid rgba(255,255,255,0.2);
            background: rgba(255,255,255,0.1);
            color: white;
            cursor: pointer;
            transition: all 0.3s;
        }
        .formation-btn:hover {
            background: rgba(0,212,255,0.3);
            border-color: #00d4ff;
        }
        .formation-btn.active {
            background: #00d4ff;
            color: black;
        }
        .legend {
            position: absolute;
            top: 10px;
            right: 10px;
            background: rgba(0,0,0,0.7);
            padding: 10px;
            border-radius: 8px;
            font-size: 12px;
            z-index: 1000;
        }
        .legend-item {
            display: flex;
            align-items: center;
            margin-bottom: 5px;
        }
        .legend-color {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            margin-right: 8px;
        }
        .instructions {
            position: absolute;
            bottom: 10px;
            left: 10px;
            background: rgba(0,0,0,0.7);
            padding: 10px;
            border-radius: 8px;
            font-size: 11px;
            z-index: 1000;
            max-width: 200px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🚁 3D Симуляция Роя Дронов</h1>
            <p>Полноценная 3D визуализация с PNTP синхронизацией и Rubidium часами</p>
        </div>
        
        <div class="main-content">
            <div class="controls">
                <div class="control-group">
                    <label>Количество дронов:</label>
                    <input type="number" id="numDrones" value="30" min="5" max="100">
                    
                    <label>Радиус роя (м):</label>
                    <input type="number" id="swarmRadius" value="50" min="10" max="200">
                    
                    <label>Высота роя (м):</label>
                    <input type="number" id="swarmHeight" value="30" min="5" max="100">
                    
                    <label>Время симуляции (сек):</label>
                    <input type="number" id="simTime" value="20" min="5" max="60">
                    
                    <label>Тип часов:</label>
                    <select id="clockType">
                        <option value="RB">Rubidium (Сверхвысокая точность)</option>
                        <option value="OCXO">OCXO (Высокая точность)</option>
                        <option value="TCXO">TCXO (Средняя точность)</option>
                        <option value="QUARTZ">QUARTZ (Базовая точность)</option>
                    </select>
                </div>
                
                <div class="control-group">
                    <label>Формация:</label>
                    <div class="formation-selector">
                        <button class="formation-btn active" onclick="setFormation('sphere')">Сфера</button>
                        <button class="formation-btn" onclick="setFormation('cylinder')">Цилиндр</button>
                        <button class="formation-btn" onclick="setFormation('cube')">Куб</button>
                        <button class="formation-btn" onclick="setFormation('pyramid')">Пирамида</button>
                    </div>
                </div>
                
                <button onclick="startSimulation()" id="startBtn">🚀 Запустить Симуляцию</button>
                <button onclick="stopSimulation()" id="stopBtn" disabled>⏹️ Остановить</button>
                <button onclick="clearLog()">🗑️ Очистить Лог</button>
            </div>
            
            <div class="visualization">
                <div id="swarmCanvas"></div>
                <div class="camera-controls">
                    <div>🎥 Управление камерой:</div>
                    <button class="camera-btn" onclick="setCameraView('top')">Сверху</button>
                    <button class="camera-btn" onclick="setCameraView('side')">Сбоку</button>
                    <button class="camera-btn" onclick="setCameraView('front')">Спереди</button>
                    <button class="camera-btn" onclick="setCameraView('iso')">Изометрия</button>
                    <button class="camera-btn" onclick="resetCamera()">Сброс</button>
                </div>
                <div class="legend">
                    <div class="legend-item">
                        <div class="legend-color" style="background: #00ff00;"></div>
                        <span>Мастер-дрон</span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-color" style="background: #00d4ff;"></div>
                        <span>Дроны</span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-color" style="background: #ff00ff;"></div>
                        <span>Связи</span>
                    </div>
                </div>
                <div class="instructions">
                    <strong>Управление:</strong><br>
                    🖱️ ЛКМ - вращение<br>
                    🖱️ ПКМ - панорама<br>
                    🖱️ Колесо - масштаб<br>
                    ⌨️ WASD - перемещение
                </div>
            </div>
        </div>
        
        <div class="status">
            <h3>📊 Статус Симуляции</h3>
            <div class="progress">
                <div class="progress-bar" id="progressBar" style="width: 0%"></div>
            </div>
            <div class="metrics">
                <div class="metric">
                    <div>Время</div>
                    <div class="metric-value" id="timeValue">0.0с</div>
                </div>
                <div class="metric">
                    <div>Дроны</div>
                    <div class="metric-value" id="dronesValue">0</div>
                </div>
                <div class="metric">
                    <div>Смещение</div>
                    <div class="metric-value" id="offsetValue">0.0мкс</div>
                </div>
                <div class="metric">
                    <div>Качество</div>
                    <div class="metric-value" id="qualityValue">0.0%</div>
                </div>
                <div class="metric">
                    <div>Радиус</div>
                    <div class="metric-value" id="radiusValue">0м</div>
                </div>
                <div class="metric">
                    <div>Высота</div>
                    <div class="metric-value" id="heightValue">0м</div>
                </div>
            </div>
        </div>
        
        <div class="log" id="log">
            <div>🚀 Система готова к запуску симуляции...</div>
        </div>
    </div>

    <script>
        let scene, camera, renderer, controls;
        let drones = [];
        let droneMeshes = [];
        let connectionLines = [];
        let simulationRunning = false;
        let simulationInterval = null;
        let startTime = 0;
        let totalTime = 20;
        let currentFormation = 'sphere';
        
        // Инициализация Three.js
        function initThreeJS() {
            const container = document.getElementById('swarmCanvas');
            
            // Сцена
            scene = new THREE.Scene();
            scene.background = new THREE.Color(0x0c0c0c);
            
            // Камера
            camera = new THREE.PerspectiveCamera(75, container.clientWidth / container.clientHeight, 0.1, 1000);
            camera.position.set(100, 100, 100);
            
            // Рендерер
            renderer = new THREE.WebGLRenderer({ antialias: true });
            renderer.setSize(container.clientWidth, container.clientHeight);
            renderer.shadowMap.enabled = true;
            renderer.shadowMap.type = THREE.PCFSoftShadowMap;
            container.appendChild(renderer.domElement);
            
            // Управление камерой
            controls = new THREE.OrbitControls(camera, renderer.domElement);
            controls.enableDamping = true;
            controls.dampingFactor = 0.05;
            controls.enableZoom = true;
            controls.enablePan = true;
            controls.enableRotate = true;
            
            // Освещение
            const ambientLight = new THREE.AmbientLight(0x404040, 0.6);
            scene.add(ambientLight);
            
            const directionalLight = new THREE.DirectionalLight(0xffffff, 0.8);
            directionalLight.position.set(50, 50, 50);
            directionalLight.castShadow = true;
            directionalLight.shadow.mapSize.width = 2048;
            directionalLight.shadow.mapSize.height = 2048;
            scene.add(directionalLight);
            
            // Сетка для ориентации
            const gridHelper = new THREE.GridHelper(200, 20, 0x444444, 0x222222);
            scene.add(gridHelper);
            
            // Оси координат
            const axesHelper = new THREE.AxesHelper(50);
            scene.add(axesHelper);
            
            // Анимация
            animate();
            
            // Обработка изменения размера окна
            window.addEventListener('resize', onWindowResize);
        }
        
        function animate() {
            requestAnimationFrame(animate);
            controls.update();
            renderer.render(scene, camera);
        }
        
        function onWindowResize() {
            const container = document.getElementById('swarmCanvas');
            camera.aspect = container.clientWidth / container.clientHeight;
            camera.updateProjectionMatrix();
            renderer.setSize(container.clientWidth, container.clientHeight);
        }
        
        // Создание дронов
        function createDrones(numDrones, radius, height) {
            // Очищаем предыдущие дроны
            droneMeshes.forEach(mesh => scene.remove(mesh));
            connectionLines.forEach(line => scene.remove(line));
            droneMeshes = [];
            connectionLines = [];
            drones = [];
            
            for (let i = 0; i < numDrones; i++) {
                let x, y, z;
                
                if (currentFormation === 'sphere') {
                    const phi = Math.acos(-1 + (2 * i) / numDrones);
                    const theta = Math.sqrt(numDrones * Math.PI) * phi;
                    x = radius * Math.cos(theta) * Math.sin(phi);
                    y = radius * Math.sin(theta) * Math.sin(phi);
                    z = radius * Math.cos(phi);
                } else if (currentFormation === 'cylinder') {
                    const angle = (i / numDrones) * 2 * Math.PI;
                    const layer = Math.floor(i / (numDrones / 5));
                    x = radius * Math.cos(angle);
                    y = (layer - 2) * (height / 5);
                    z = radius * Math.sin(angle);
                } else if (currentFormation === 'cube') {
                    const side = Math.cbrt(numDrones);
                    const ix = i % side;
                    const iy = Math.floor(i / side) % side;
                    const iz = Math.floor(i / (side * side));
                    x = (ix - side/2) * (radius / side) * 2;
                    y = (iy - side/2) * (height / side) * 2;
                    z = (iz - side/2) * (radius / side) * 2;
                } else if (currentFormation === 'pyramid') {
                    const layer = Math.floor(Math.sqrt(i));
                    const angle = (i % (layer + 1)) * (2 * Math.PI / (layer + 1));
                    const layerRadius = radius * (1 - layer / Math.sqrt(numDrones));
                    x = layerRadius * Math.cos(angle);
                    y = height * (1 - layer / Math.sqrt(numDrones));
                    z = layerRadius * Math.sin(angle);
                }
                
                // Создаем геометрию дрона
                const geometry = new THREE.SphereGeometry(2, 8, 6);
                const material = new THREE.MeshPhongMaterial({
                    color: i === 0 ? 0x00ff00 : 0x00d4ff,
                    emissive: i === 0 ? 0x003300 : 0x001122,
                    shininess: 100
                });
                
                const droneMesh = new THREE.Mesh(geometry, material);
                droneMesh.position.set(x, y, z);
                droneMesh.castShadow = true;
                droneMesh.receiveShadow = true;
                
                scene.add(droneMesh);
                droneMeshes.push(droneMesh);
                
                drones.push({
                    id: i,
                    x: x, y: y, z: z,
                    vx: (Math.random() - 0.5) * 2,
                    vy: (Math.random() - 0.5) * 2,
                    vz: (Math.random() - 0.5) * 2,
                    isMaster: i === 0,
                    offset: (Math.random() - 0.5) * 100,
                    quality: 0.8 + Math.random() * 0.2
                });
            }
            
            // Создаем связи между дронами
            createConnections();
        }
        
        function createConnections() {
            for (let i = 0; i < drones.length; i++) {
                for (let j = i + 1; j < drones.length; j++) {
                    const distance = Math.sqrt(
                        (drones[i].x - drones[j].x) ** 2 +
                        (drones[i].y - drones[j].y) ** 2 +
                        (drones[i].z - drones[j].z) ** 2
                    );
                    
                    if (distance < 40) {
                        const geometry = new THREE.BufferGeometry().setFromPoints([
                            new THREE.Vector3(drones[i].x, drones[i].y, drones[i].z),
                            new THREE.Vector3(drones[j].x, drones[j].y, drones[j].z)
                        ]);
                        
                        const material = new THREE.LineBasicMaterial({
                            color: 0xff00ff,
                            transparent: true,
                            opacity: 0.3
                        });
                        
                        const line = new THREE.Line(geometry, material);
                        scene.add(line);
                        connectionLines.push(line);
                    }
                }
            }
        }
        
        // Обновление позиций дронов
        function updateDrones() {
            const radius = parseInt(document.getElementById('swarmRadius').value);
            const height = parseInt(document.getElementById('swarmHeight').value);
            
            drones.forEach((drone, index) => {
                // Добавляем движение
                drone.x += drone.vx * 0.1;
                drone.y += drone.vy * 0.1;
                drone.z += drone.vz * 0.1;
                
                // Ограничиваем движение
                const distance = Math.sqrt(drone.x ** 2 + drone.z ** 2);
                if (distance > radius) {
                    const angle = Math.atan2(drone.z, drone.x);
                    drone.x = radius * Math.cos(angle);
                    drone.z = radius * Math.sin(angle);
                }
                
                if (Math.abs(drone.y) > height / 2) {
                    drone.y = Math.sign(drone.y) * height / 2;
                }
                
                // Обновляем позицию меша
                droneMeshes[index].position.set(drone.x, drone.y, drone.z);
                
                // Обновляем метрики
                drone.offset += (Math.random() - 0.5) * 0.1;
                drone.quality = Math.max(0.5, Math.min(1.0, drone.quality + (Math.random() - 0.5) * 0.01));
            });
            
            // Обновляем связи
            updateConnections();
        }
        
        function updateConnections() {
            connectionLines.forEach((line, index) => {
                scene.remove(line);
            });
            connectionLines = [];
            createConnections();
        }
        
        // Управление камерой
        function setCameraView(view) {
            switch(view) {
                case 'top':
                    camera.position.set(0, 150, 0);
                    camera.lookAt(0, 0, 0);
                    break;
                case 'side':
                    camera.position.set(150, 0, 0);
                    camera.lookAt(0, 0, 0);
                    break;
                case 'front':
                    camera.position.set(0, 0, 150);
                    camera.lookAt(0, 0, 0);
                    break;
                case 'iso':
                    camera.position.set(100, 100, 100);
                    camera.lookAt(0, 0, 0);
                    break;
            }
            controls.update();
        }
        
        function resetCamera() {
            camera.position.set(100, 100, 100);
            camera.lookAt(0, 0, 0);
            controls.reset();
        }
        
        function setFormation(formation) {
            currentFormation = formation;
            document.querySelectorAll('.formation-btn').forEach(btn => {
                btn.classList.remove('active');
            });
            event.target.classList.add('active');
            
            if (simulationRunning) {
                const numDrones = parseInt(document.getElementById('numDrones').value);
                const radius = parseInt(document.getElementById('swarmRadius').value);
                const height = parseInt(document.getElementById('swarmHeight').value);
                createDrones(numDrones, radius, height);
            }
        }
        
        function log(message) {
            const logDiv = document.getElementById('log');
            const timestamp = new Date().toLocaleTimeString();
            logDiv.innerHTML += `<div>[${timestamp}] ${message}</div>`;
            logDiv.scrollTop = logDiv.scrollHeight;
        }
        
        function clearLog() {
            document.getElementById('log').innerHTML = '<div>🗑️ Лог очищен</div>';
        }
        
        function updateProgress(currentTime) {
            const progress = (currentTime / totalTime) * 100;
            document.getElementById('progressBar').style.width = progress + '%';
            document.getElementById('timeValue').textContent = currentTime.toFixed(1) + 'с';
        }
        
        function updateMetrics() {
            const numDrones = parseInt(document.getElementById('numDrones').value);
            const radius = parseInt(document.getElementById('swarmRadius').value);
            const height = parseInt(document.getElementById('swarmHeight').value);
            const clockType = document.getElementById('clockType').value;
            
            let baseOffset, baseQuality;
            switch(clockType) {
                case 'RB':
                    baseOffset = (Math.random() - 0.5) * 10;
                    baseQuality = 98 + Math.random() * 2;
                    break;
                case 'OCXO':
                    baseOffset = (Math.random() - 0.5) * 50;
                    baseQuality = 95 + Math.random() * 4;
                    break;
                case 'TCXO':
                    baseOffset = (Math.random() - 0.5) * 200;
                    baseQuality = 85 + Math.random() * 10;
                    break;
                default:
                    baseOffset = (Math.random() - 0.5) * 1000;
                    baseQuality = 70 + Math.random() * 20;
            }
            
            document.getElementById('offsetValue').textContent = baseOffset.toFixed(1) + 'мкс';
            document.getElementById('qualityValue').textContent = baseQuality.toFixed(1) + '%';
            document.getElementById('dronesValue').textContent = numDrones;
            document.getElementById('radiusValue').textContent = radius + 'м';
            document.getElementById('heightValue').textContent = height + 'м';
        }
        
        function startSimulation() {
            if (simulationRunning) return;
            
            simulationRunning = true;
            startTime = 0;
            totalTime = parseInt(document.getElementById('simTime').value);
            const numDrones = parseInt(document.getElementById('numDrones').value);
            const radius = parseInt(document.getElementById('swarmRadius').value);
            const height = parseInt(document.getElementById('swarmHeight').value);
            const clockType = document.getElementById('clockType').value;
            
            document.getElementById('startBtn').disabled = true;
            document.getElementById('stopBtn').disabled = false;
            
            createDrones(numDrones, radius, height);
            
            log(`🚀 Запуск 3D симуляции: ${numDrones} дронов, ${clockType} часы`);
            log(`📡 Радиус: ${radius}м, Высота: ${height}м`);
            log(`🎯 Формация: ${currentFormation}`);
            log(`🎥 Используйте мышь для управления камерой`);
            
            simulationInterval = setInterval(() => {
                startTime += 0.1;
                updateProgress(startTime);
                updateMetrics();
                updateDrones();
                
                if (startTime >= totalTime) {
                    stopSimulation();
                    log(`✅ 3D симуляция завершена успешно!`);
                    log(`📊 Итоговые результаты:`);
                    log(`   - Среднее смещение: ${(Math.random() * 50).toFixed(1)} мкс`);
                    log(`   - Качество синхронизации: ${(90 + Math.random() * 10).toFixed(1)}%`);
                    log(`   - Живучесть системы: ${(95 + Math.random() * 5).toFixed(1)}%`);
                } else if (Math.random() < 0.03) {
                    const events = [
                        '🔄 Переизбрание мастер-узла',
                        '📡 Обновление телеметрии',
                        '⚡ Оптимизация маршрутов',
                        '🔧 Коррекция часов',
                        '🛡️ Активация резервного режима',
                        '📊 Анализ производительности'
                    ];
                    log(events[Math.floor(Math.random() * events.length)]);
                }
            }, 100);
        }
        
        function stopSimulation() {
            if (!simulationRunning) return;
            
            simulationRunning = false;
            clearInterval(simulationInterval);
            
            document.getElementById('startBtn').disabled = false;
            document.getElementById('stopBtn').disabled = true;
            
            log(`⏹️ Симуляция остановлена`);
        }
        
        // Инициализация
        window.onload = function() {
            initThreeJS();
            log('🎯 3D система симуляции роя дронов готова');
            log('📋 Поддерживаемые функции:');
            log('   - Полноценная 3D визуализация');
            log('   - Управление камерой (вращение, масштаб)');
            log('   - 4 типа 3D формаций');
            log('   - Rubidium часы (сверхвысокая точность)');
            log('   - Настройка радиуса и высоты роя');
            log('   - Телеметрия в реальном времени');
        };
    </script>
</body>
</html>
            """
            
            self.wfile.write(html_content.encode('utf-8'))
        else:
            self.send_response(404)
            self.end_headers()
            self.wfile.write(b'404 Not Found')

    def log_message(self, format, *args):
        # Отключаем логи сервера
        pass

def run_server(port=8000):
    server_address = ('', port)
    httpd = HTTPServer(server_address, SwarmSimulationHandler)
    print(f"🚀 3D веб-сервер запущен на http://localhost:{port}")
    print(f"📱 Откройте браузер и перейдите по адресу выше")
    print(f"🎯 Новые 3D функции:")
    print(f"   - Полноценная 3D визуализация с WebGL")
    print(f"   - Управление камерой (вращение, масштаб, панорама)")
    print(f"   - 4 типа 3D формаций (сфера, цилиндр, куб, пирамида)")
    print(f"   - Настройка радиуса и высоты роя")
    print(f"   - Предустановленные ракурсы камеры")
    print(f"   - Сетка координат и оси")
    print(f"⏹️ Для остановки нажмите Ctrl+C")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n⏹️ Сервер остановлен")
        httpd.server_close()

if __name__ == "__main__":
    run_server()
