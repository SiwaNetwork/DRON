#!/usr/bin/env python3
"""
PNTP (Precision Network Time Protocol) - протокол синхронизации времени и частоты
"""
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

import numpy as np
import time
import random
from dataclasses import dataclass, field
from enum import Enum
from typing import Dict, List, Optional, Tuple, Any
from collections import defaultdict, deque
import math


class SyncMode(Enum):
    """Режимы синхронизации"""
    MASTER = "master"
    SLAVE = "slave"
    RELAY = "relay"
    GATEWAY = "gateway"


class RadioDomain(Enum):
    """Радиодомены связи"""
    WIFI_5 = "wifi_5"
    WIFI_6 = "wifi_6"
    WIFI_6E = "wifi_6e"
    LORA_SUBGHZ = "lora_subghz"
    WWVB_60KHZ = "wwvb_60khz"


@dataclass
class PNTPPacket:
    """PNTP пакет"""
    source_id: str
    destination_id: str
    timestamp_t1: float  # Время отправки
    timestamp_t2: float  # Время получения
    timestamp_t3: float  # Время ответа
    timestamp_t4: float  # Время получения ответа
    stratum: int = 0
    precision: float = 1e-6  # 1 мкс
    root_delay: float = 0.0
    root_dispersion: float = 0.0
    reference_id: str = ""
    reference_timestamp: float = 0.0
    origin_timestamp: float = 0.0
    receive_timestamp: float = 0.0
    transmit_timestamp: float = 0.0
    network_metrics: Dict[str, float] = field(default_factory=dict)


@dataclass
class ClockState:
    """Состояние часов узла"""
    offset: float = 0.0  # Смещение времени (мкс)
    frequency_offset: float = 0.0  # Смещение частоты (ppm)
    drift: float = 0.0  # Дрейф частоты (ppm/час)
    jitter: float = 0.0  # Джиттер (мкс)
    stability: float = 1e-6  # Стабильность (Allan deviation)
    temperature: float = 25.0  # Температура (°C)
    holdover_duration: float = 0.0  # Длительность holdover (с)
    last_update: float = 0.0  # Время последнего обновления


class PLLController:
    """PLL контроллер для фазовой синхронизации"""
    
    def __init__(self, kp: float = 0.1, ki: float = 0.01, kd: float = 0.001):
        self.kp = kp  # Пропорциональный коэффициент
        self.ki = ki  # Интегральный коэффициент
        self.kd = kd  # Дифференциальный коэффициент
        self.integral = 0.0
        self.last_error = 0.0
        self.last_time = 0.0
        
    def update(self, error: float, dt: float) -> float:
        """Обновление PLL контроллера"""
        if dt <= 0:
            return 0.0
            
        # Интегральная составляющая
        self.integral += error * dt
        
        # Дифференциальная составляющая
        derivative = (error - self.last_error) / dt if dt > 0 else 0.0
        
        # PID выход
        output = self.kp * error + self.ki * self.integral + self.kd * derivative
        
        # Ограничение интегральной составляющей
        self.integral = np.clip(self.integral, -1000, 1000)
        
        self.last_error = error
        self.last_time += dt
        
        return output


class FLLController:
    """FLL контроллер для частотной синхронизации"""
    
    def __init__(self, kp: float = 0.05, ki: float = 0.005):
        self.kp = kp
        self.ki = ki
        self.integral = 0.0
        self.last_error = 0.0
        
    def update(self, error: float, dt: float) -> float:
        """Обновление FLL контроллера"""
        if dt <= 0:
            return 0.0
            
        # Интегральная составляющая
        self.integral += error * dt
        
        # PI выход
        output = self.kp * error + self.ki * self.integral
        
        # Ограничение интегральной составляющей
        self.integral = np.clip(self.integral, -100, 100)
        
        self.last_error = error
        
        return output


class MovingAverageFilter:
    """Фильтр скользящего среднего"""
    
    def __init__(self, window_size: int = 10):
        self.window_size = window_size
        self.values = deque(maxlen=window_size)
        
    def update(self, value: float) -> float:
        """Обновление фильтра"""
        self.values.append(value)
        return np.mean(self.values) if self.values else value


class ClockDiscipline:
    """Дисциплинирование часов"""
    
    def __init__(self, node_id: str, clock_type: str = "TCXO"):
        self.node_id = node_id
        self.clock_type = clock_type
        self.clock_state = ClockState()
        
        # Параметры часов в зависимости от типа
        self.setup_clock_parameters()
        
        # Контроллеры
        self.pll_controller = PLLController()
        self.fll_controller = FLLController()
        
        # Фильтры
        self.offset_filter = MovingAverageFilter(20)
        self.frequency_filter = MovingAverageFilter(10)
        
        # Температурная компенсация
        self.temperature_coefficient = self.get_temperature_coefficient()
        
    def setup_clock_parameters(self):
        """Настройка параметров часов"""
        if self.clock_type == "OCXO":
            # Оксиллированный кварцевый генератор
            self.clock_state.stability = 1e-8  # 10 ppb
            self.aging_rate = 1e-9  # 1 ppb/день
            self.temperature_coefficient = 1e-8  # 10 ppb/°C
        elif self.clock_type == "TCXO":
            # Термокомпенсированный кварцевый генератор
            self.clock_state.stability = 1e-6  # 1 ppm
            self.aging_rate = 1e-7  # 100 ppb/день
            self.temperature_coefficient = 1e-7  # 100 ppb/°C
        elif self.clock_type == "RB":
            # Рубидиевый стандарт частоты
            self.clock_state.stability = 1e-11  # 10^-11 относительная нестабильность
            self.aging_rate = 1e-12  # медленное старение
            self.temperature_coefficient = 1e-11  # высокая стабильность к температуре
        else:  # QUARTZ
            # Обычный кварцевый генератор
            self.clock_state.stability = 1e-5  # 10 ppm
            self.aging_rate = 1e-6  # 1 ppm/день
            self.temperature_coefficient = 1e-6  # 1 ppm/°C
            
    def get_temperature_coefficient(self) -> float:
        """Получение температурного коэффициента"""
        return self.temperature_coefficient
        
    def update_temperature_effects(self, temperature: float, dt: float):
        """Обновление температурных эффектов"""
        temp_change = temperature - self.clock_state.temperature
        self.clock_state.temperature = temperature
        
        # Температурный дрейф
        temp_drift = temp_change * self.temperature_coefficient
        self.clock_state.frequency_offset += temp_drift
        
        # Старение
        aging_drift = self.aging_rate * dt / 86400  # Конвертация в секунды
        self.clock_state.frequency_offset += aging_drift
        
    def apply_corrections(self, offset_correction: float, frequency_correction: float, dt: float):
        """Применение коррекций"""
        # Фильтрация измерений
        filtered_offset = self.offset_filter.update(offset_correction)
        filtered_frequency = self.frequency_filter.update(frequency_correction)
        
        # Применение PLL коррекции
        pll_output = self.pll_controller.update(filtered_offset, dt)
        self.clock_state.offset += pll_output * dt
        
        # Применение FLL коррекции
        fll_output = self.fll_controller.update(filtered_frequency, dt)
        self.clock_state.frequency_offset += fll_output * dt
        
        # Обновление времени
        self.clock_state.last_update += dt
        
        # Обновление holdover
        if abs(filtered_offset) < 100:  # 100 мкс порог
            self.clock_state.holdover_duration = 0.0
        else:
            self.clock_state.holdover_duration += dt
            
    def get_holdover_accuracy(self) -> float:
        """Получение точности holdover"""
        # Расчет ошибки holdover на основе типа часов и времени
        base_error = self.clock_state.stability * self.clock_state.holdover_duration * 3600  # мкс/час
        
        if self.clock_type == "OCXO":
            return min(base_error, 2000)  # 2 мс/час максимум
        elif self.clock_type == "TCXO":
            return min(base_error, 5000)  # 5 мс/час максимум
        elif self.clock_type == "RB":
            return min(base_error, 200)   # 0.2 мс/час максимум
        else:
            return min(base_error, 50000)  # 50 мс/час максимум


class PNTPNode:
    """PNTP узел"""
    
    def __init__(self, node_id: str, sync_mode: SyncMode, radio_domains: List[RadioDomain]):
        self.node_id = node_id
        self.sync_mode = sync_mode
        self.radio_domains = radio_domains
        
        # Состояние синхронизации
        self.stratum = 0 if sync_mode == SyncMode.MASTER else 16
        self.sync_quality = 0.0
        self.last_sync_time = 0.0
        self.sync_interval = 1.0  # секунды
        
        # Дисциплинирование часов
        self.clock_discipline = ClockDiscipline(node_id)
        
        # Сетевые параметры
        self.packet_loss_rate = 0.05  # 5% потерь по умолчанию
        self.signal_strength = -50.0  # dBm
        self.failure_probability = 0.001  # 0.1% вероятность отказа
        self.recovery_time = 60.0  # секунды
        self.failure_start_time = None
        self.is_failed = False
        
        # Многолучевость
        self.multipath_delay = 0.0  # секунды
        self.multipath_variance = 0.0  # секунды
        
        # Метрики синхронизации
        self.sync_metrics = {
            'offset': 0.0,
            'delay': 0.0,
            'jitter': 0.0,
            'sync_quality': 0.0,
            'packets_sent': 0,
            'packets_received': 0,
            'sync_errors': 0
        }
        
        # История измерений
        self.measurement_history = deque(maxlen=100)
        
    def generate_packet(self, destination_id: str) -> PNTPPacket:
        """Генерация PNTP пакета"""
        current_time = time.time()
        
        packet = PNTPPacket(
            source_id=self.node_id,
            destination_id=destination_id,
            timestamp_t1=current_time,
            timestamp_t2=0.0,
            timestamp_t3=0.0,
            timestamp_t4=0.0,
            stratum=self.stratum,
            precision=self.clock_discipline.clock_state.stability * 1e6,  # мкс
            reference_id=self.node_id if self.sync_mode == SyncMode.MASTER else "",
            reference_timestamp=current_time,
            origin_timestamp=current_time,
            receive_timestamp=current_time,
            transmit_timestamp=current_time,
            network_metrics={
                'signal_strength': self.signal_strength,
                'packet_loss_rate': self.packet_loss_rate,
                'multipath_delay': self.multipath_delay,
                'multipath_variance': self.multipath_variance
            }
        )
        
        return packet
        
    def process_packet(self, packet: PNTPPacket) -> Optional[Tuple[float, float]]:
        """Обработка PNTP пакета"""
        if self.is_failed:
            return None
            
        # Симуляция потерь пакетов
        if random.random() < self.packet_loss_rate:
            self.sync_metrics['packets_sent'] += 1
            return None
            
        current_time = time.time()
        
        # Расчет смещения и задержки
        if packet.timestamp_t2 > 0 and packet.timestamp_t3 > 0:
            # Двусторонний обмен
            delay = ((packet.timestamp_t4 - packet.timestamp_t1) - 
                    (packet.timestamp_t3 - packet.timestamp_t2)) / 2
            offset = ((packet.timestamp_t2 - packet.timestamp_t1) + 
                     (packet.timestamp_t3 - packet.timestamp_t4)) / 2
            
            # Коррекция на многолучевость
            multipath_correction = random.gauss(self.multipath_delay, self.multipath_variance)
            offset += multipath_correction
            
            # Обновление метрик
            self.sync_metrics['offset'] = offset
            self.sync_metrics['delay'] = delay
            self.sync_metrics['packets_received'] += 1
            
            # Сохранение измерения
            self.measurement_history.append({
                'timestamp': current_time,
                'offset': offset,
                'delay': delay,
                'stratum': packet.stratum
            })
            
            return offset, delay
            
        return None
        
    def update_sync_metrics(self):
        """Обновление метрик синхронизации"""
        if not self.measurement_history:
            return
            
        # Расчет джиттера
        recent_offsets = [m['offset'] for m in list(self.measurement_history)[-10:]]
        if len(recent_offsets) > 1:
            self.sync_metrics['jitter'] = np.std(recent_offsets)
            
        # Расчет качества синхронизации
        if self.sync_mode == SyncMode.MASTER:
            self.sync_quality = 1.0
        else:
            # Качество на основе стабильности и джиттера
            stability_factor = 1.0 / (1.0 + self.clock_discipline.clock_state.stability * 1e6)
            jitter_factor = 1.0 / (1.0 + self.sync_metrics['jitter'] * 1e-3)  # мкс -> мс
            self.sync_quality = stability_factor * jitter_factor
            
        self.sync_metrics['sync_quality'] = self.sync_quality
        
    def simulate_failure(self, dt: float):
        """Симуляция отказа узла"""
        if self.is_failed:
            # Проверка восстановления
            if time.time() - self.failure_start_time > self.recovery_time:
                self.is_failed = False
                self.failure_start_time = None
                print(f"Узел {self.node_id} восстановлен")
        else:
            # Проверка отказа
            if random.random() < self.failure_probability * dt:
                self.is_failed = True
                self.failure_start_time = time.time()
                print(f"Узел {self.node_id} отказал")


class PNTPEnsemble:
    """PNTP ансамбль узлов"""
    
    def __init__(self, ensemble_id: str):
        self.ensemble_id = ensemble_id
        self.nodes: Dict[str, PNTPNode] = {}
        self.master_node: Optional[PNTPNode] = None
        self.sync_interval = 1.0  # секунды
        self.last_sync_time = 0.0
        
        # Метрики ансамбля
        self.ensemble_metrics = {
            'average_offset': 0.0,
            'max_offset': 0.0,
            'sync_coverage': 0.0,
            'network_diameter': 0,
            'failure_resilience': 1.0,
            'total_nodes': 0,
            'active_nodes': 0,
            'master_nodes': 0,
            'slave_nodes': 0,
            'relay_nodes': 0,
            'gateway_nodes': 0
        }
        
    def add_node(self, node: PNTPNode):
        """Добавление узла в ансамбль"""
        self.nodes[node.node_id] = node
        
        # Установка мастер-узла
        if node.sync_mode == SyncMode.MASTER and self.master_node is None:
            self.master_node = node
            node.stratum = 0
            
        self.update_ensemble_metrics()
        
    def remove_node(self, node_id: str):
        """Удаление узла из ансамбля"""
        if node_id in self.nodes:
            if self.nodes[node_id] == self.master_node:
                self.master_node = None
            del self.nodes[node_id]
            self.update_ensemble_metrics()
            
    def select_master(self):
        """Выбор мастер-узла"""
        if self.master_node is None or self.master_node.is_failed:
            # Выбор нового мастер-узла
            candidates = [node for node in self.nodes.values() 
                         if not node.is_failed and node.sync_quality > 0.8]
            
            if candidates:
                # Выбор узла с лучшим качеством синхронизации
                self.master_node = max(candidates, key=lambda n: n.sync_quality)
                self.master_node.sync_mode = SyncMode.MASTER
                self.master_node.stratum = 0
                print(f"Выбран новый мастер-узел: {self.master_node.node_id}")
                
    def run_sync_cycle(self, dt: float):
        """Запуск цикла синхронизации"""
        current_time = time.time()
        
        # Симуляция отказов
        for node in self.nodes.values():
            node.simulate_failure(dt)
            
        # Выбор мастер-узла
        self.select_master()
        
        if self.master_node is None:
            return
            
        # Синхронизация с мастер-узлом
        if current_time - self.last_sync_time >= self.sync_interval:
            self.perform_sync_exchanges()
            self.last_sync_time = current_time
            
        # Обновление метрик
        self.update_ensemble_metrics()
        
    def perform_sync_exchanges(self):
        """Выполнение обменов синхронизации"""
        if not self.master_node:
            return
            
        # Мастер-узел отправляет пакеты всем узлам
        for node in self.nodes.values():
            if node == self.master_node or node.is_failed:
                continue
                
            # Генерация пакета от мастера
            packet = self.master_node.generate_packet(node.node_id)
            
            # Симуляция передачи
            packet.timestamp_t2 = time.time()  # Время получения
            packet.timestamp_t3 = time.time()  # Время ответа
            packet.timestamp_t4 = time.time()  # Время получения ответа
            
            # Обработка пакета узлом
            result = node.process_packet(packet)
            
            if result:
                offset, delay = result
                # Применение коррекции к часам узла
                node.clock_discipline.apply_corrections(offset, 0.0, self.sync_interval)
                
                # Обновление stratum
                if node.stratum > self.master_node.stratum + 1:
                    node.stratum = self.master_node.stratum + 1
                    
    def update_ensemble_metrics(self):
        """Обновление метрик ансамбля"""
        active_nodes = [node for node in self.nodes.values() if not node.is_failed]
        
        if not active_nodes:
            return
            
        # Смещения
        offsets = [node.clock_discipline.clock_state.offset for node in active_nodes]
        self.ensemble_metrics['average_offset'] = np.mean(offsets)
        self.ensemble_metrics['max_offset'] = np.max(np.abs(offsets))
        
        # Покрытие синхронизации
        synced_nodes = [node for node in active_nodes if node.sync_quality > 0.5]
        self.ensemble_metrics['sync_coverage'] = len(synced_nodes) / len(active_nodes)
        
        # Диаметр сети
        self.ensemble_metrics['network_diameter'] = max(node.stratum for node in active_nodes)
        
        # Живучесть
        failed_nodes = [node for node in self.nodes.values() if node.is_failed]
        self.ensemble_metrics['failure_resilience'] = 1.0 - len(failed_nodes) / len(self.nodes)
        
        # Статистика узлов
        self.ensemble_metrics['total_nodes'] = len(self.nodes)
        self.ensemble_metrics['active_nodes'] = len(active_nodes)
        self.ensemble_metrics['master_nodes'] = len([n for n in active_nodes if n.sync_mode == SyncMode.MASTER])
        self.ensemble_metrics['slave_nodes'] = len([n for n in active_nodes if n.sync_mode == SyncMode.SLAVE])
        self.ensemble_metrics['relay_nodes'] = len([n for n in active_nodes if n.sync_mode == SyncMode.RELAY])
        self.ensemble_metrics['gateway_nodes'] = len([n for n in active_nodes if n.sync_mode == SyncMode.GATEWAY])


class PNTPTelemetry:
    """Сервис телеметрии и мониторинга"""
    
    def __init__(self):
        self.telemetry_data = []
        self.alerts = []
        self.performance_history = deque(maxlen=1000)
        
    def collect_telemetry(self, ensemble: PNTPEnsemble):
        """Сбор телеметрии"""
        current_time = time.time()
        
        # Сбор данных узлов
        node_telemetry = {}
        for node_id, node in ensemble.nodes.items():
            node_telemetry[node_id] = {
                'offset': node.clock_discipline.clock_state.offset,
                'frequency_offset': node.clock_discipline.clock_state.frequency_offset,
                'stratum': node.stratum,
                'sync_quality': node.sync_quality,
                'is_failed': node.is_failed,
                'sync_mode': node.sync_mode.value,
                'holdover_duration': node.clock_discipline.clock_state.holdover_duration,
                'packet_loss_rate': node.packet_loss_rate,
                'signal_strength': node.signal_strength
            }
            
        # Сохранение телеметрии
        telemetry_entry = {
            'timestamp': current_time,
            'ensemble_metrics': ensemble.ensemble_metrics.copy(),
            'node_telemetry': node_telemetry,
            'master_node': ensemble.master_node.node_id if ensemble.master_node else None
        }
        
        self.telemetry_data.append(telemetry_entry)
        self.performance_history.append(telemetry_entry)
        
        # Проверка алертов
        self.check_alerts(ensemble)
        
    def check_alerts(self, ensemble: PNTPEnsemble):
        """Проверка алертов"""
        for node_id, node in ensemble.nodes.items():
            # Алерт на высокое смещение
            if abs(node.clock_discipline.clock_state.offset) > 1000:  # 1 мс
                self.alerts.append({
                    'timestamp': time.time(),
                    'type': 'HIGH_OFFSET',
                    'node_id': node_id,
                    'value': node.clock_discipline.clock_state.offset
                })
                
            # Алерт на отказ узла
            if node.is_failed:
                self.alerts.append({
                    'timestamp': time.time(),
                    'type': 'NODE_FAILURE',
                    'node_id': node_id,
                    'value': 0.0
                })
                
            # Алерт на низкое качество синхронизации
            if node.sync_quality < 0.3:
                self.alerts.append({
                    'timestamp': time.time(),
                    'type': 'LOW_SYNC_QUALITY',
                    'node_id': node_id,
                    'value': node.sync_quality
                })
                
        # Алерт на низкое покрытие синхронизации
        if ensemble.ensemble_metrics['sync_coverage'] < 0.7:
            self.alerts.append({
                'timestamp': time.time(),
                'type': 'LOW_SYNC_COVERAGE',
                'node_id': 'ensemble',
                'value': ensemble.ensemble_metrics['sync_coverage']
            })
            
    def get_performance_report(self) -> Optional[Dict[str, Any]]:
        """Получение отчета о производительности"""
        if not self.performance_history:
            return None
            
        # Статистика
        all_offsets = []
        all_sync_qualities = []
        all_packet_losses = []
        recovery_times = []
        
        for entry in self.performance_history:
            all_offsets.extend([node['offset'] for node in entry['node_telemetry'].values()])
            all_sync_qualities.extend([node['sync_quality'] for node in entry['node_telemetry'].values()])
            all_packet_losses.extend([node['packet_loss_rate'] for node in entry['node_telemetry'].values()])
            
        # Анализ восстановления
        failure_alerts = [alert for alert in self.alerts if alert['type'] == 'NODE_FAILURE']
        if len(failure_alerts) > 1:
            for i in range(1, len(failure_alerts)):
                recovery_time = failure_alerts[i]['timestamp'] - failure_alerts[i-1]['timestamp']
                recovery_times.append(recovery_time)
                
        # Точность holdover
        holdover_accuracies = []
        for entry in self.performance_history:
            for node in entry['node_telemetry'].values():
                if node['holdover_duration'] > 0:
                    # Оценка точности holdover
                    accuracy = node['holdover_duration'] * 5000  # 5 мс/час для TCXO
                    holdover_accuracies.append(accuracy)
                    
        statistics = {
            'offset_rms': np.sqrt(np.mean(np.array(all_offsets)**2)) if all_offsets else 0,
            'max_offset': np.max(np.abs(all_offsets)) if all_offsets else 0,
            'average_sync_coverage': np.mean([entry['ensemble_metrics']['sync_coverage'] 
                                            for entry in self.performance_history]),
            'average_packet_loss': np.mean(all_packet_losses) if all_packet_losses else 0,
            'average_sync_quality': np.mean(all_sync_qualities) if all_sync_qualities else 0
        }
        
        compliance = {
            'gnss_denied': True,  # Система работает без GNSS
            'scalability': len(self.performance_history[-1]['node_telemetry']) <= 100,
            'recovery_time': np.mean(recovery_times) if recovery_times else 60.0,
            'holdover_accuracy': np.mean(holdover_accuracies) if holdover_accuracies else 5000.0
        }
        
        return {
            'statistics': statistics,
            'compliance': compliance,
            'alerts': self.alerts,
            'total_measurements': len(self.performance_history)
        } 