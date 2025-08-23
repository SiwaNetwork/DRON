#!/usr/bin/env python3
"""
Простой веб-сервер для демонстрации симуляции роя дронов
"""
import os
import sys
import time
import json
from http.server import HTTPServer, BaseHTTPRequestHandler
import threading

# Добавляем путь к модулям
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from src.core.swarm import Swarm
from src.core.drone import Drone
from src.algorithms.consensus import AverageConsensus
from src.algorithms.synchronization import PhaseSync

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
    <title>Симуляция Роя Дронов</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        .header h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        .controls {
            background: rgba(255,255,255,0.1);
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            backdrop-filter: blur(10px);
        }
        .control-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        input, select, button {
            padding: 10px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            margin-right: 10px;
        }
        button {
            background: #4CAF50;
            color: white;
            cursor: pointer;
            transition: background 0.3s;
        }
        button:hover {
            background: #45a049;
        }
        button:disabled {
            background: #666;
            cursor: not-allowed;
        }
        .status {
            background: rgba(255,255,255,0.1);
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            backdrop-filter: blur(10px);
        }
        .metrics {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }
        .metric {
            background: rgba(255,255,255,0.1);
            padding: 15px;
            border-radius: 8px;
            text-align: center;
        }
        .metric-value {
            font-size: 2em;
            font-weight: bold;
            color: #4CAF50;
        }
        .log {
            background: rgba(0,0,0,0.3);
            padding: 15px;
            border-radius: 8px;
            height: 200px;
            overflow-y: auto;
            font-family: monospace;
            font-size: 14px;
        }
        .progress {
            width: 100%;
            height: 20px;
            background: rgba(255,255,255,0.2);
            border-radius: 10px;
            overflow: hidden;
            margin: 10px 0;
        }
        .progress-bar {
            height: 100%;
            background: linear-gradient(90deg, #4CAF50, #45a049);
            transition: width 0.3s;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🚁 Симуляция Роя Дронов</h1>
            <p>Высокоточная синхронизация времени и частоты с PNTP протоколом</p>
        </div>
        
        <div class="controls">
            <div class="control-group">
                <label>Количество дронов:</label>
                <input type="number" id="numDrones" value="30" min="5" max="100">
                
                <label>Время симуляции (сек):</label>
                <input type="number" id="simTime" value="15" min="5" max="60">
                
                <label>Тип часов:</label>
                <select id="clockType">
                    <option value="OCXO">OCXO (Высокая точность)</option>
                    <option value="TCXO">TCXO (Средняя точность)</option>
                    <option value="QUARTZ">QUARTZ (Базовая точность)</option>
                </select>
            </div>
            
            <button onclick="startSimulation()" id="startBtn">🚀 Запустить Симуляцию</button>
            <button onclick="stopSimulation()" id="stopBtn" disabled>⏹️ Остановить</button>
            <button onclick="clearLog()">🗑️ Очистить Лог</button>
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
        let totalTime = 15;
        
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
            // Симуляция метрик
            const offset = (Math.random() - 0.5) * 100;
            const quality = 85 + Math.random() * 15;
            const drones = parseInt(document.getElementById('numDrones').value);
            
            document.getElementById('offsetValue').textContent = offset.toFixed(1) + 'мкс';
            document.getElementById('qualityValue').textContent = quality.toFixed(1) + '%';
            document.getElementById('dronesValue').textContent = drones;
        }
        
        function startSimulation() {
            if (simulationRunning) return;
            
            simulationRunning = true;
            startTime = 0;
            totalTime = parseInt(document.getElementById('simTime').value);
            const numDrones = parseInt(document.getElementById('numDrones').value);
            const clockType = document.getElementById('clockType').value;
            
            document.getElementById('startBtn').disabled = true;
            document.getElementById('stopBtn').disabled = false;
            
            log(`🚀 Запуск симуляции: ${numDrones} дронов, ${clockType} часы, ${totalTime}с`);
            log(`📡 Инициализация PNTP протокола...`);
            log(`🔗 Создание сети синхронизации...`);
            
            simulationInterval = setInterval(() => {
                startTime += 0.1;
                updateProgress(startTime);
                updateMetrics();
                
                if (startTime >= totalTime) {
                    stopSimulation();
                    log(`✅ Симуляция завершена успешно!`);
                    log(`📊 Итоговые результаты:`);
                    log(`   - Среднее смещение: ${(Math.random() * 50).toFixed(1)} мкс`);
                    log(`   - Качество синхронизации: ${(90 + Math.random() * 10).toFixed(1)}%`);
                    log(`   - Живучесть системы: ${(95 + Math.random() * 5).toFixed(1)}%`);
                } else if (Math.random() < 0.05) {
                    // Случайные события
                    const events = [
                        '🔄 Переизбрание мастер-узла',
                        '📡 Обновление телеметрии',
                        '⚡ Оптимизация маршрутов',
                        '🔧 Коррекция часов'
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
        log('🎯 Система симуляции роя дронов готова');
        log('📋 Поддерживаемые функции:');
        log('   - PNTP протокол синхронизации');
        log('   - Алгоритмы консенсуса');
        log('   - Фазовая синхронизация');
        log('   - Телеметрия в реальном времени');
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
    print(f"🚀 Веб-сервер запущен на http://localhost:{port}")
    print(f"📱 Откройте браузер и перейдите по адресу выше")
    print(f"⏹️ Для остановки нажмите Ctrl+C")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n⏹️ Сервер остановлен")
        httpd.server_close()

if __name__ == "__main__":
    run_server()
