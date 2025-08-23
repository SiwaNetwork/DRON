# API Documentation

## Обзор

Drone Swarm Simulation предоставляет REST API для управления симуляцией роя дронов. API работает через HTTP и возвращает данные в формате JSON.

## Базовый URL

```
http://localhost:8080
```

## Endpoints

### 1. Запуск симуляции

**POST** `/api/start`

Запускает симуляцию роя дронов.

**Ответ:**
```json
{
  "status": "success",
  "message": "Симуляция запущена",
  "drones_count": 20
}
```

### 2. Остановка симуляции

**POST** `/api/stop`

Останавливает симуляцию.

**Ответ:**
```json
{
  "status": "success",
  "message": "Симуляция остановлена"
}
```

### 3. Получение статуса

**GET** `/api/status`

Возвращает текущий статус симуляции.

**Ответ:**
```json
{
  "simulation_running": true,
  "simulation_time": 45.2,
  "num_drones": 20,
  "current_master_id": 0,
  "master_changes_count": 2,
  "active_elections_count": 0,
  "avg_time_offset": 0.15,
  "avg_sync_quality": 0.85,
  "swarm_sync_accuracy": 12.5,
  "swarm_time_divergence": 8.3,
  "dpll_locked_count": 18,
  "wwvb_sync_count": 156,
  "avg_battery_level": 0.78,
  "avg_signal_strength": 0.72,
  "avg_temperature": 23.5
}
```

### 4. Получение данных дронов

**GET** `/api/drones`

Возвращает данные всех дронов в рое.

**Ответ:**
```json
[
  {
    "id": 0,
    "position": [0.0, 0.0, 100.0],
    "velocity": [1.2, -0.8, 0.1],
    "is_master": true,
    "battery_level": 0.95,
    "clock_type": "rubidium",
    "time_offset": 0.0,
    "frequency_offset": 0.0,
    "jitter": 0.001,
    "accuracy": 1e-9,
    "sync_quality": 1.0,
    "dpll_locked": true,
    "sync_events": 45,
    "connection_lost": false,
    "election_in_progress": false,
    "leader_priority": 100,
    "backup_master": false,
    "flight_mode": "normal",
    "wind_resistance": 1.0,
    "altitude_level": 2,
    "assigned_altitude": 100.0,
    "doppler_shift_hz": 0.0,
    "doppler_error_ns": 0.0,
    "multipath_jitter_ns": 0.5,
    "theoretical_accuracy_ns": 10.2,
    "snr_db": 25.6,
    "relative_velocity_ms": 0.0
  }
]
```

### 5. Получение конфигурации

**GET** `/api/config`

Возвращает текущую конфигурацию симуляции.

**Ответ:**
```json
{
  "num_drones": 20,
  "radius": 1000.0,
  "height": 100.0,
  "sync_frequency": 1.0,
  "sync_topology": "master_slave",
  "sync_range": 300.0,
  "sync_algorithm": "ptp",
  "master_clock": "rubidium",
  "slave_clock": "ocxo",
  "adaptive_sync": "enabled",
  "delay_compensation": "automatic",
  "failure_simulation": "enabled",
  "master_failure_rate": 0.1,
  "master_timeout": 5.0,
  "election_algorithm": "priority",
  "frequency_band": "2.4ghz",
  "channel_width": 20,
  "interference_model": "urban"
}
```

### 6. Обновление конфигурации

**POST** `/api/update_config`

Обновляет конфигурацию симуляции.

**Параметры запроса:**
```json
{
  "num_drones": 25,
  "radius": 1200.0,
  "height": 120.0,
  "sync_frequency": 2.0,
  "sync_topology": "mesh",
  "sync_range": 400.0,
  "sync_algorithm": "consensus",
  "master_clock": "cesium",
  "slave_clock": "tcxo",
  "adaptive_sync": "enabled",
  "delay_compensation": "automatic",
  "failure_simulation": "enabled",
  "master_failure_rate": 0.05,
  "master_timeout": 3.0,
  "election_algorithm": "raft",
  "frequency_band": "5ghz",
  "channel_width": 40,
  "interference_model": "suburban"
}
```

**Ответ:**
```json
{
  "status": "success",
  "message": "Конфигурация обновлена",
  "updated_params": ["num_drones", "radius", "height"]
}
```

## Коды ошибок

### HTTP Status Codes

- **200 OK** - Успешный запрос
- **400 Bad Request** - Неверные параметры
- **404 Not Found** - Endpoint не найден
- **500 Internal Server Error** - Внутренняя ошибка сервера

### Примеры ошибок

```json
{
  "error": "validation_error",
  "message": "Количество дронов должно быть от 5 до 50",
  "field": "num_drones",
  "value": 100
}
```

```json
{
  "error": "simulation_error",
  "message": "Симуляция уже запущена",
  "current_status": "running"
}
```

## Параметры конфигурации

### Основные параметры

| Параметр | Тип | Диапазон | Описание |
|----------|-----|----------|----------|
| `num_drones` | int | 5-50 | Количество дронов в рое |
| `radius` | float | 100-2000 | Радиус роя в метрах |
| `height` | float | 50-300 | Базовая высота полета в метрах |

### Параметры синхронизации

| Параметр | Тип | Значения | Описание |
|----------|-----|----------|----------|
| `sync_frequency` | float | 0.1-10.0 | Частота синхронизации в Гц |
| `sync_topology` | string | master_slave, peer_to_peer, hierarchical, mesh | Топология синхронизации |
| `sync_range` | float | 50-1000 | Дальность синхронизации в метрах |
| `sync_algorithm` | string | ptp, ntp, consensus, distributed | Алгоритм синхронизации |

### Типы генераторов тактовых импульсов

| Параметр | Тип | Значения | Описание |
|----------|-----|----------|----------|
| `master_clock` | string | rubidium, cesium, ocxo, hydrogen_maser | Тип часов мастер-дрона |
| `slave_clock` | string | ocxo, tcxo, quartz, crystal | Тип часов ведомых дронов |

### Параметры отказоустойчивости

| Параметр | Тип | Диапазон | Описание |
|----------|-----|----------|----------|
| `failure_simulation` | string | enabled, disabled | Включение симуляции отказов |
| `master_failure_rate` | float | 0.0-1.0 | Вероятность отказа мастер-дрона |
| `master_timeout` | float | 1.0-30.0 | Таймаут ожидания мастера в секундах |
| `election_algorithm` | string | priority, raft, byzantine | Алгоритм выборов лидера |

### Радиочастотные параметры

| Параметр | Тип | Значения | Описание |
|----------|-----|----------|----------|
| `frequency_band` | string | 433mhz, 900mhz, 1.2ghz, 2.4ghz, 5ghz, 5.8ghz | Частотный диапазон |
| `channel_width` | int | 20, 40, 80, 160 | Ширина канала в МГц |
| `interference_model` | string | rural, suburban, urban, indoor, industrial | Модель помех |

## Примеры использования

### Python

```python
import requests
import json

# Запуск симуляции
response = requests.post('http://localhost:8080/api/start')
print(response.json())

# Получение статуса
response = requests.get('http://localhost:8080/api/status')
status = response.json()
print(f"Симуляция работает: {status['simulation_running']}")

# Обновление конфигурации
config = {
    "num_drones": 30,
    "radius": 1500.0,
    "sync_algorithm": "ptp"
}
response = requests.post('http://localhost:8080/api/update_config', json=config)
print(response.json())
```

### JavaScript

```javascript
// Запуск симуляции
fetch('/api/start', { method: 'POST' })
    .then(response => response.json())
    .then(data => console.log(data));

// Получение данных дронов
fetch('/api/drones')
    .then(response => response.json())
    .then(drones => {
        drones.forEach(drone => {
            console.log(`Дрон ${drone.id}: ${drone.position}`);
        });
    });

// Обновление конфигурации
const config = {
    num_drones: 25,
    sync_topology: 'mesh'
};

fetch('/api/update_config', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(config)
})
.then(response => response.json())
.then(data => console.log(data));
```

### cURL

```bash
# Запуск симуляции
curl -X POST http://localhost:8080/api/start

# Получение статуса
curl http://localhost:8080/api/status

# Получение данных дронов
curl http://localhost:8080/api/drones

# Обновление конфигурации
curl -X POST http://localhost:8080/api/update_config \
  -H "Content-Type: application/json" \
  -d '{"num_drones": 30, "radius": 1500.0}'
```

## WebSocket API (планируется)

В будущих версиях планируется добавление WebSocket API для real-time обновлений:

```javascript
const ws = new WebSocket('ws://localhost:8080/ws');

ws.onmessage = function(event) {
    const data = JSON.parse(event.data);
    if (data.type === 'drone_update') {
        updateDroneVisualization(data.drones);
    }
};
```
