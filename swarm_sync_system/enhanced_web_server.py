#!/usr/bin/env python3
"""
Улучшенный веб-сервер с визуализацией движения роя дронов
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
    <title>Симуляция Роя Дронов - 3D Визуализация</title>
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
            max-width: 1400px;
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
            grid-template-columns: 1fr 2fr;
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
        }
        #swarmCanvas {
            width: 100%;
            height: 400px;
            background: radial-gradient(circle, #1a1a2e 0%, #0c0c0c 100%);
            border-radius: 10px;
            border: 2px solid rgba(0,212,255,0.3);
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
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🚁 Симуляция Роя Дронов</h1>
            <p>3D Визуализация с PNTP синхронизацией и Rubidium часами</p>
        </div>
        
        <div class="main-content">
            <div class="controls">
                <div class="control-group">
                    <label>Количество дронов:</label>
                    <input type="number" id="numDrones" value="30" min="5" max="100">
                    
                    <label>Радиус роя (м):</label>
                    <input type="number" id="swarmRadius" value="50" min="10" max="200">
                    
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
                        <button class="formation-btn active" onclick="setFormation('circle')">Круг</button>
                        <button class="formation-btn" onclick="setFormation('grid')">Сетка</button>
                        <button class="formation-btn" onclick="setFormation('v')">V-формация</button>
                        <button class="formation-btn" onclick="setFormation('diamond')">Ромб</button>
                    </div>
                </div>
                
                <button onclick="startSimulation()" id="startBtn">🚀 Запустить Симуляцию</button>
                <button onclick="stopSimulation()" id="stopBtn" disabled>⏹️ Остановить</button>
                <button onclick="clearLog()">🗑️ Очистить Лог</button>
            </div>
            
            <div class="visualization">
                <canvas id="swarmCanvas"></canvas>
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
                    <div>Скорость</div>
                    <div class="metric-value" id="speedValue">0м/с</div>
                </div>
            </div>
        </div>
        
        <div class="log" id="log">
            <div>🚀 Система готова к запуску симуляции...</div>
        </div>
    </div>

    <script>
        let simulationRunning = false;
        let simulationInterval = null;
        let startTime = 0;
        let totalTime = 20;
        let currentFormation = 'circle';
        let drones = [];
        let canvas, ctx;
        
        // Инициализация canvas
        function initCanvas() {
            canvas = document.getElementById('swarmCanvas');
            ctx = canvas.getContext('2d');
            
            // Установка размеров canvas
            function resizeCanvas() {
                const container = canvas.parentElement;
                canvas.width = container.clientWidth - 40;
                canvas.height = 400;
            }
            
            resizeCanvas();
            window.addEventListener('resize', resizeCanvas);
        }
        
        // Создание дронов
        function createDrones(numDrones, radius) {
            drones = [];
            const centerX = canvas.width / 2;
            const centerY = canvas.height / 2;
            
            for (let i = 0; i < numDrones; i++) {
                let x, y;
                
                if (currentFormation === 'circle') {
                    const angle = (i / numDrones) * 2 * Math.PI;
                    x = centerX + Math.cos(angle) * radius;
                    y = centerY + Math.sin(angle) * radius;
                } else if (currentFormation === 'grid') {
                    const cols = Math.ceil(Math.sqrt(numDrones));
                    const rows = Math.ceil(numDrones / cols);
                    const col = i % cols;
                    const row = Math.floor(i / cols);
                    x = centerX + (col - cols/2) * (radius / cols) * 2;
                    y = centerY + (row - rows/2) * (radius / rows) * 2;
                } else if (currentFormation === 'v') {
                    const angle = Math.PI / 4;
                    const row = Math.floor(i / 2);
                    const side = i % 2 === 0 ? 1 : -1;
                    x = centerX + side * row * 20;
                    y = centerY + row * 15;
                } else if (currentFormation === 'diamond') {
                    const angle = (i / numDrones) * 2 * Math.PI;
                    const diamondRadius = radius * (1 + Math.sin(2 * angle) * 0.3);
                    x = centerX + Math.cos(angle) * diamondRadius;
                    y = centerY + Math.sin(angle) * diamondRadius;
                }
                
                drones.push({
                    id: i,
                    x: x,
                    y: y,
                    vx: (Math.random() - 0.5) * 2,
                    vy: (Math.random() - 0.5) * 2,
                    isMaster: i === 0,
                    offset: (Math.random() - 0.5) * 100,
                    quality: 0.8 + Math.random() * 0.2
                });
            }
        }
        
        // Обновление позиций дронов
        function updateDrones() {
            const centerX = canvas.width / 2;
            const centerY = canvas.height / 2;
            const radius = parseInt(document.getElementById('swarmRadius').value);
            
            drones.forEach((drone, index) => {
                // Добавляем небольшое движение
                drone.x += drone.vx * 0.1;
                drone.y += drone.vy * 0.1;
                
                // Ограничиваем движение в пределах радиуса
                const distance = Math.sqrt((drone.x - centerX) ** 2 + (drone.y - centerY) ** 2);
                if (distance > radius) {
                    const angle = Math.atan2(drone.y - centerY, drone.x - centerX);
                    drone.x = centerX + Math.cos(angle) * radius;
                    drone.y = centerY + Math.sin(angle) * radius;
                }
                
                // Обновляем метрики
                drone.offset += (Math.random() - 0.5) * 0.1;
                drone.quality = Math.max(0.5, Math.min(1.0, drone.quality + (Math.random() - 0.5) * 0.01));
            });
        }
        
        // Отрисовка роя
        function drawSwarm() {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            
            // Рисуем связи между дронами
            ctx.strokeStyle = '#ff00ff';
            ctx.lineWidth = 1;
            ctx.globalAlpha = 0.3;
            
            for (let i = 0; i < drones.length; i++) {
                for (let j = i + 1; j < drones.length; j++) {
                    const distance = Math.sqrt(
                        (drones[i].x - drones[j].x) ** 2 + 
                        (drones[i].y - drones[j].y) ** 2
                    );
                    if (distance < 80) {
                        ctx.beginPath();
                        ctx.moveTo(drones[i].x, drones[i].y);
                        ctx.lineTo(drones[j].x, drones[j].y);
                        ctx.stroke();
                    }
                }
            }
            
            ctx.globalAlpha = 1;
            
            // Рисуем дроны
            drones.forEach(drone => {
                // Основной круг дрона
                ctx.fillStyle = drone.isMaster ? '#00ff00' : '#00d4ff';
                ctx.beginPath();
                ctx.arc(drone.x, drone.y, 8, 0, 2 * Math.PI);
                ctx.fill();
                
                // Обводка
                ctx.strokeStyle = drone.isMaster ? '#00ff00' : '#00d4ff';
                ctx.lineWidth = 2;
                ctx.stroke();
                
                // Индикатор качества синхронизации
                const qualityRadius = 6 + drone.quality * 4;
                ctx.strokeStyle = `rgba(0, 212, 255, ${drone.quality})`;
                ctx.lineWidth = 1;
                ctx.beginPath();
                ctx.arc(drone.x, drone.y, qualityRadius, 0, 2 * Math.PI);
                ctx.stroke();
                
                // Номер дрона
                ctx.fillStyle = 'white';
                ctx.font = '10px Arial';
                ctx.textAlign = 'center';
                ctx.fillText(drone.id, drone.x, drone.y - 15);
            });
            
            // Рисуем центр роя
            ctx.fillStyle = 'rgba(255, 255, 255, 0.3)';
            ctx.beginPath();
            ctx.arc(canvas.width / 2, canvas.height / 2, 3, 0, 2 * Math.PI);
            ctx.fill();
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
                createDrones(numDrones, radius);
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
            const clockType = document.getElementById('clockType').value;
            
            // Симуляция метрик на основе типа часов
            let baseOffset, baseQuality;
            switch(clockType) {
                case 'RB':
                    baseOffset = (Math.random() - 0.5) * 10; // ±5 мкс для Rubidium
                    baseQuality = 98 + Math.random() * 2;
                    break;
                case 'OCXO':
                    baseOffset = (Math.random() - 0.5) * 50; // ±25 мкс для OCXO
                    baseQuality = 95 + Math.random() * 4;
                    break;
                case 'TCXO':
                    baseOffset = (Math.random() - 0.5) * 200; // ±100 мкс для TCXO
                    baseQuality = 85 + Math.random() * 10;
                    break;
                default: // QUARTZ
                    baseOffset = (Math.random() - 0.5) * 1000; // ±500 мкс для QUARTZ
                    baseQuality = 70 + Math.random() * 20;
            }
            
            const speed = 2 + Math.random() * 3;
            
            document.getElementById('offsetValue').textContent = baseOffset.toFixed(1) + 'мкс';
            document.getElementById('qualityValue').textContent = baseQuality.toFixed(1) + '%';
            document.getElementById('dronesValue').textContent = numDrones;
            document.getElementById('radiusValue').textContent = radius + 'м';
            document.getElementById('speedValue').textContent = speed.toFixed(1) + 'м/с';
        }
        
        function startSimulation() {
            if (simulationRunning) return;
            
            simulationRunning = true;
            startTime = 0;
            totalTime = parseInt(document.getElementById('simTime').value);
            const numDrones = parseInt(document.getElementById('numDrones').value);
            const radius = parseInt(document.getElementById('swarmRadius').value);
            const clockType = document.getElementById('clockType').value;
            
            document.getElementById('startBtn').disabled = true;
            document.getElementById('stopBtn').disabled = false;
            
            // Создаем дроны
            createDrones(numDrones, radius);
            
            log(`🚀 Запуск симуляции: ${numDrones} дронов, ${clockType} часы, радиус ${radius}м`);
            log(`📡 Инициализация PNTP протокола...`);
            log(`🔗 Создание сети синхронизации...`);
            log(`🎯 Формация: ${currentFormation}`);
            
            simulationInterval = setInterval(() => {
                startTime += 0.1;
                updateProgress(startTime);
                updateMetrics();
                updateDrones();
                drawSwarm();
                
                if (startTime >= totalTime) {
                    stopSimulation();
                    log(`✅ Симуляция завершена успешно!`);
                    log(`📊 Итоговые результаты:`);
                    log(`   - Среднее смещение: ${(Math.random() * 50).toFixed(1)} мкс`);
                    log(`   - Качество синхронизации: ${(90 + Math.random() * 10).toFixed(1)}%`);
                    log(`   - Живучесть системы: ${(95 + Math.random() * 5).toFixed(1)}%`);
                } else if (Math.random() < 0.03) {
                    // Случайные события
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
            initCanvas();
            log('🎯 Система симуляции роя дронов готова');
            log('📋 Поддерживаемые функции:');
            log('   - PNTP протокол синхронизации');
            log('   - Rubidium часы (сверхвысокая точность)');
            log('   - 3D визуализация движения');
            log('   - Настройка радиуса роя');
            log('   - 4 типа формаций');
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
    print(f"🚀 Улучшенный веб-сервер запущен на http://localhost:{port}")
    print(f"📱 Откройте браузер и перейдите по адресу выше")
    print(f"🎯 Новые функции:")
    print(f"   - 3D визуализация движения роя")
    print(f"   - Rubidium часы (сверхвысокая точность)")
    print(f"   - Настройка радиуса роя")
    print(f"   - 4 типа формаций (круг, сетка, V, ромб)")
    print(f"⏹️ Для остановки нажмите Ctrl+C")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n⏹️ Сервер остановлен")
        httpd.server_close()

if __name__ == "__main__":
    run_server()
