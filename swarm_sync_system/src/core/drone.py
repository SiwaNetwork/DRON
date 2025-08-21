"""
Математическая модель беспилотника
"""
import numpy as np
from dataclasses import dataclass
from typing import Optional, List, Tuple
from enum import Enum


class DroneStatus(Enum):
    """Состояние беспилотника"""
    IDLE = "idle"
    FLYING = "flying"
    LANDING = "landing"
    EMERGENCY = "emergency"
    FORMATION = "formation"


@dataclass
class DroneState:
    """
    Состояние беспилотника в пространстве
    
    Использует систему координат NED (North-East-Down):
    - x: север (м)
    - y: восток (м)
    - z: вниз (м, отрицательные значения - высота)
    """
    position: np.ndarray  # [x, y, z] в метрах
    velocity: np.ndarray  # [vx, vy, vz] в м/с
    acceleration: np.ndarray  # [ax, ay, az] в м/с²
    orientation: np.ndarray  # [roll, pitch, yaw] в радианах (углы Эйлера)
    angular_velocity: np.ndarray  # [p, q, r] в рад/с
    timestamp: float  # время в секундах
    
    def __post_init__(self):
        """Преобразование в numpy массивы"""
        self.position = np.asarray(self.position, dtype=np.float64)
        self.velocity = np.asarray(self.velocity, dtype=np.float64)
        self.acceleration = np.asarray(self.acceleration, dtype=np.float64)
        self.orientation = np.asarray(self.orientation, dtype=np.float64)
        self.angular_velocity = np.asarray(self.angular_velocity, dtype=np.float64)
    
    def copy(self) -> 'DroneState':
        """Создание копии состояния"""
        return DroneState(
            position=self.position.copy(),
            velocity=self.velocity.copy(),
            acceleration=self.acceleration.copy(),
            orientation=self.orientation.copy(),
            angular_velocity=self.angular_velocity.copy(),
            timestamp=self.timestamp
        )


class Drone:
    """
    Модель беспилотника с динамикой движения
    
    Параметры физической модели основаны на типичном квадрокоптере
    """
    
    def __init__(self, 
                 drone_id: str,
                 initial_position: np.ndarray = None,
                 mass: float = 1.5,  # кг
                 max_velocity: float = 20.0,  # м/с
                 max_acceleration: float = 10.0,  # м/с²
                 max_angular_velocity: float = np.pi,  # рад/с
                 communication_range: float = 100.0,  # м
                 battery_capacity: float = 100.0):  # %
        """
        Инициализация беспилотника
        
        Args:
            drone_id: Уникальный идентификатор
            initial_position: Начальная позиция [x, y, z]
            mass: Масса беспилотника (кг)
            max_velocity: Максимальная скорость (м/с)
            max_acceleration: Максимальное ускорение (м/с²)
            max_angular_velocity: Максимальная угловая скорость (рад/с)
            communication_range: Дальность связи (м)
            battery_capacity: Емкость батареи (%)
        """
        self.id = drone_id
        self.mass = mass
        self.max_velocity = max_velocity
        self.max_acceleration = max_acceleration
        self.max_angular_velocity = max_angular_velocity
        self.communication_range = communication_range
        self.battery_capacity = battery_capacity
        self.battery_level = battery_capacity
        
        # Инициализация состояния
        if initial_position is None:
            initial_position = np.zeros(3)
        
        self.state = DroneState(
            position=initial_position,
            velocity=np.zeros(3),
            acceleration=np.zeros(3),
            orientation=np.zeros(3),
            angular_velocity=np.zeros(3),
            timestamp=0.0
        )
        
        self.status = DroneStatus.IDLE
        self.target_position: Optional[np.ndarray] = None
        self.neighbors: List[str] = []  # ID соседних дронов в радиусе связи
        
        # Параметры ПИД-регулятора для управления
        self.pid_position = {
            'kp': np.array([2.0, 2.0, 3.0]),  # Пропорциональный коэффициент
            'ki': np.array([0.1, 0.1, 0.2]),  # Интегральный коэффициент
            'kd': np.array([1.0, 1.0, 1.5]),  # Дифференциальный коэффициент
            'integral': np.zeros(3),
            'prev_error': np.zeros(3)
        }
        
        # История состояний для анализа
        self.state_history: List[DroneState] = []
        self.max_history_size = 1000
    
    def update_state(self, dt: float, external_force: np.ndarray = None):
        """
        Обновление состояния беспилотника на основе динамической модели
        
        Args:
            dt: Временной шаг (с)
            external_force: Внешняя сила (ветер, возмущения) [Fx, Fy, Fz] в Н
        """
        if external_force is None:
            external_force = np.zeros(3)
        
        # Расчет управляющего воздействия
        if self.target_position is not None and self.status == DroneStatus.FLYING:
            control_acceleration = self._calculate_control(dt)
        else:
            control_acceleration = np.zeros(3)
        
        # Ограничение ускорения
        control_acceleration = self._limit_acceleration(control_acceleration)
        
        # Обновление динамики с учетом внешних сил
        total_acceleration = control_acceleration + external_force / self.mass
        
        # Интегрирование уравнений движения (метод Эйлера)
        new_velocity = self.state.velocity + total_acceleration * dt
        new_velocity = self._limit_velocity(new_velocity)
        
        new_position = self.state.position + self.state.velocity * dt + \
                      0.5 * total_acceleration * dt**2
        
        # Обновление ориентации (упрощенная модель)
        if np.linalg.norm(new_velocity[:2]) > 0.1:  # Если есть горизонтальное движение
            # Yaw направлен по вектору скорости
            self.state.orientation[2] = np.arctan2(new_velocity[1], new_velocity[0])
        
        # Обновление состояния
        self.state.position = new_position
        self.state.velocity = new_velocity
        self.state.acceleration = total_acceleration
        self.state.timestamp += dt
        
        # Расход батареи (упрощенная модель)
        power_consumption = self._calculate_power_consumption()
        self.battery_level -= power_consumption * dt / 3600  # Расход в %/час
        self.battery_level = max(0, self.battery_level)
        
        # Сохранение истории
        self._update_history()
    
    def _calculate_control(self, dt: float) -> np.ndarray:
        """
        Расчет управляющего ускорения с помощью ПИД-регулятора
        
        Args:
            dt: Временной шаг
            
        Returns:
            Управляющее ускорение [ax, ay, az]
        """
        if self.target_position is None:
            return np.zeros(3)
        
        # Ошибка позиции
        error = self.target_position - self.state.position
        
        # П-составляющая
        p_term = self.pid_position['kp'] * error
        
        # И-составляющая
        self.pid_position['integral'] += error * dt
        # Анти-windup: ограничение интегральной составляющей
        self.pid_position['integral'] = np.clip(
            self.pid_position['integral'], -10, 10
        )
        i_term = self.pid_position['ki'] * self.pid_position['integral']
        
        # Д-составляющая
        if dt > 0:
            d_term = self.pid_position['kd'] * (error - self.pid_position['prev_error']) / dt
        else:
            d_term = np.zeros(3)
        
        self.pid_position['prev_error'] = error
        
        # Суммарное управление
        control = p_term + i_term + d_term
        
        # Компенсация гравитации для оси Z
        control[2] += 9.81  # g = 9.81 м/с²
        
        return control
    
    def _limit_velocity(self, velocity: np.ndarray) -> np.ndarray:
        """Ограничение скорости"""
        speed = np.linalg.norm(velocity)
        if speed > self.max_velocity:
            return velocity * (self.max_velocity / speed)
        return velocity
    
    def _limit_acceleration(self, acceleration: np.ndarray) -> np.ndarray:
        """Ограничение ускорения"""
        acc_magnitude = np.linalg.norm(acceleration)
        if acc_magnitude > self.max_acceleration:
            return acceleration * (self.max_acceleration / acc_magnitude)
        return acceleration
    
    def _calculate_power_consumption(self) -> float:
        """
        Расчет потребления энергии (упрощенная модель)
        
        Returns:
            Потребление в %/час
        """
        # Базовое потребление
        base_consumption = 5.0  # %/час
        
        # Потребление от движения (пропорционально ускорению)
        motion_consumption = np.linalg.norm(self.state.acceleration) * 0.5
        
        # Потребление от высоты (борьба с гравитацией)
        altitude_consumption = max(0, -self.state.position[2]) * 0.01
        
        return base_consumption + motion_consumption + altitude_consumption
    
    def _update_history(self):
        """Обновление истории состояний"""
        self.state_history.append(self.state.copy())
        if len(self.state_history) > self.max_history_size:
            self.state_history.pop(0)
    
    def set_target_position(self, target: np.ndarray):
        """
        Установка целевой позиции
        
        Args:
            target: Целевая позиция [x, y, z]
        """
        self.target_position = np.asarray(target, dtype=np.float64)
        if self.status == DroneStatus.IDLE:
            self.status = DroneStatus.FLYING
    
    def get_distance_to(self, other_position: np.ndarray) -> float:
        """
        Расчет расстояния до точки
        
        Args:
            other_position: Позиция точки [x, y, z]
            
        Returns:
            Расстояние в метрах
        """
        return np.linalg.norm(self.state.position - other_position)
    
    def is_at_target(self, tolerance: float = 0.5) -> bool:
        """
        Проверка достижения целевой позиции
        
        Args:
            tolerance: Допустимое отклонение (м)
            
        Returns:
            True если дрон достиг цели
        """
        if self.target_position is None:
            return False
        return self.get_distance_to(self.target_position) < tolerance
    
    def can_communicate_with(self, other_drone: 'Drone') -> bool:
        """
        Проверка возможности связи с другим дроном
        
        Args:
            other_drone: Другой дрон
            
        Returns:
            True если дроны в радиусе связи
        """
        distance = self.get_distance_to(other_drone.state.position)
        return distance <= min(self.communication_range, other_drone.communication_range)
    
    def get_relative_position(self, other_drone: 'Drone') -> np.ndarray:
        """
        Получение относительной позиции другого дрона
        
        Args:
            other_drone: Другой дрон
            
        Returns:
            Вектор относительной позиции [dx, dy, dz]
        """
        return other_drone.state.position - self.state.position
    
    def reset(self):
        """Сброс состояния дрона"""
        self.state = DroneState(
            position=np.zeros(3),
            velocity=np.zeros(3),
            acceleration=np.zeros(3),
            orientation=np.zeros(3),
            angular_velocity=np.zeros(3),
            timestamp=0.0
        )
        self.status = DroneStatus.IDLE
        self.target_position = None
        self.battery_level = self.battery_capacity
        self.pid_position['integral'] = np.zeros(3)
        self.pid_position['prev_error'] = np.zeros(3)
        self.state_history.clear()
    
    def __repr__(self) -> str:
        return (f"Drone(id={self.id}, "
                f"pos={self.state.position}, "
                f"vel={np.linalg.norm(self.state.velocity):.2f} m/s, "
                f"status={self.status.value}, "
                f"battery={self.battery_level:.1f}%)")