# Руководство по установке

## Системные требования

### Минимальные требования
- **Операционная система**: Windows 10/11, macOS 10.14+, Ubuntu 18.04+
- **Python**: 3.7 или выше
- **RAM**: 4 GB
- **Видеокарта**: Поддержка WebGL 2.0
- **Браузер**: Chrome 80+, Firefox 75+, Safari 13+, Edge 80+

### Рекомендуемые требования
- **RAM**: 8 GB или больше
- **Видеокарта**: Современная GPU с поддержкой WebGL 2.0
- **Процессор**: 4+ ядра
- **Свободное место**: 1 GB

## Установка Python

### Windows

1. **Скачайте Python** с официального сайта: https://www.python.org/downloads/
2. **Запустите установщик** и отметьте "Add Python to PATH"
3. **Проверьте установку**:
   ```cmd
   python --version
   ```

### macOS

1. **Установите Homebrew** (если не установлен):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Установите Python**:
   ```bash
   brew install python
   ```

3. **Проверьте установку**:
   ```bash
   python3 --version
   ```

### Ubuntu/Debian

1. **Обновите пакеты**:
   ```bash
   sudo apt update
   sudo apt upgrade
   ```

2. **Установите Python**:
   ```bash
   sudo apt install python3 python3-pip
   ```

3. **Проверьте установку**:
   ```bash
   python3 --version
   ```

## Клонирование репозитория

### Через Git

```bash
# Клонирование репозитория
git clone https://github.com/your-username/drone-swarm-simulation.git

# Переход в папку проекта
cd drone-swarm-simulation
```

### Скачивание ZIP

1. Перейдите на страницу репозитория
2. Нажмите "Code" → "Download ZIP"
3. Распакуйте архив
4. Откройте терминал в папке проекта

## Проверка зависимостей

Проект использует только встроенные модули Python, поэтому дополнительная установка пакетов не требуется.

### Проверка доступности модулей

```python
# Создайте файл check_dependencies.py
import sys

required_modules = [
    'http.server',
    'json',
    'math',
    'random',
    'threading',
    'time',
    'urllib.parse'
]

missing_modules = []

for module in required_modules:
    try:
        __import__(module)
        print(f"✅ {module}")
    except ImportError:
        missing_modules.append(module)
        print(f"❌ {module}")

if missing_modules:
    print(f"\nОтсутствуют модули: {missing_modules}")
    sys.exit(1)
else:
    print("\n✅ Все зависимости доступны!")
```

Запустите проверку:
```bash
python check_dependencies.py
```

## Запуск симуляции

### Первый запуск

1. **Откройте терминал** в папке проекта
2. **Запустите симуляцию**:
   ```bash
   python final_drone_simulation.py
   ```

3. **Дождитесь сообщения**:
   ```
   ============================================================
   🚁 FINAL DRONE SWARM SIMULATION 🚁
   ============================================================
   🚀 Сервер запускается на порту 8080
   🌐 Откройте браузер: http://localhost:8080
   ```

4. **Откройте браузер** и перейдите по адресу: `http://localhost:8080`

### Автоматическое открытие браузера

На Windows браузер должен открыться автоматически. Если этого не произошло:

1. Откройте браузер вручную
2. Введите адрес: `http://localhost:8080`

## Устранение неполадок

### Ошибка "Port 8080 is already in use"

**Решение 1**: Остановите процесс на порту 8080
```bash
# Windows
netstat -ano | findstr :8080
taskkill /PID <PID> /F

# macOS/Linux
lsof -ti:8080 | xargs kill -9
```

**Решение 2**: Измените порт в коде
```python
# В файле final_drone_simulation.py найдите строку:
httpd = HTTPServer(('localhost', 8080), FinalWebHandler)

# Измените на:
httpd = HTTPServer(('localhost', 8081), FinalWebHandler)
```

### Ошибка "ModuleNotFoundError"

**Решение**: Убедитесь, что используете правильную версию Python
```bash
# Проверьте версию Python
python --version

# Если версия ниже 3.7, установите новую версию
```

### Браузер не открывается

**Решение 1**: Откройте браузер вручную
```bash
# Windows
start http://localhost:8080

# macOS
open http://localhost:8080

# Linux
xdg-open http://localhost:8080
```

**Решение 2**: Проверьте файрвол
- Убедитесь, что Python разрешен в файрволе
- Проверьте, что порт 8080 не заблокирован

### Проблемы с WebGL

**Решение 1**: Обновите драйверы видеокарты

**Решение 2**: Проверьте поддержку WebGL
1. Откройте: https://get.webgl.org/
2. Убедитесь, что WebGL поддерживается

**Решение 3**: Включите аппаратное ускорение в браузере
- Chrome: chrome://settings → Advanced → System → Use hardware acceleration
- Firefox: about:preferences → General → Performance → Use recommended performance settings

### Медленная работа

**Решение 1**: Уменьшите количество дронов
- В интерфейсе установите "Количество дронов" = 10-15

**Решение 2**: Закройте другие приложения
- Освободите RAM и CPU

**Решение 3**: Обновите браузер
- Используйте последнюю версию Chrome/Firefox

## Настройка для разработки

### Создание виртуального окружения

```bash
# Создание виртуального окружения
python -m venv venv

# Активация (Windows)
venv\Scripts\activate

# Активация (macOS/Linux)
source venv/bin/activate

# Установка зависимостей (если появятся в будущем)
pip install -r requirements.txt
```

### Настройка IDE

#### Visual Studio Code

1. **Установите расширения**:
   - Python
   - Python Extension Pack
   - Live Server (для отладки веб-части)

2. **Настройте отладку**:
   ```json
   // .vscode/launch.json
   {
       "version": "0.2.0",
       "configurations": [
           {
               "name": "Python: Current File",
               "type": "python",
               "request": "launch",
               "program": "${file}",
               "console": "integratedTerminal"
           }
       ]
   }
   ```

#### PyCharm

1. **Откройте проект** в PyCharm
2. **Настройте интерпретатор Python**
3. **Создайте конфигурацию запуска**:
   - Script path: `final_drone_simulation.py`
   - Working directory: папка проекта

## Обновление

### Обновление через Git

```bash
# Получение последних изменений
git pull origin main

# Если есть конфликты, решите их и сделайте commit
git add .
git commit -m "Resolve merge conflicts"
```

### Ручное обновление

1. Скачайте новую версию с GitHub
2. Замените файлы в папке проекта
3. Перезапустите симуляцию

## Удаление

### Удаление проекта

```bash
# Удаление папки проекта
rm -rf drone-swarm-simulation

# Windows
rmdir /s /q drone-swarm-simulation
```

### Удаление Python (если больше не нужен)

**Windows**:
- Панель управления → Программы → Удалить программу → Python

**macOS**:
```bash
brew uninstall python
```

**Ubuntu/Debian**:
```bash
sudo apt remove python3 python3-pip
```

## Поддержка

Если у вас возникли проблемы:

1. **Проверьте раздел "Устранение неполадок"**
2. **Создайте Issue** на GitHub с описанием проблемы
3. **Приложите логи** ошибок и информацию о системе

### Полезные команды для диагностики

```bash
# Информация о системе
python --version
pip --version
python -c "import sys; print(sys.platform)"

# Проверка портов
netstat -an | grep 8080

# Проверка процессов Python
ps aux | grep python
```
