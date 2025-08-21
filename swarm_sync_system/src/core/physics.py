"""
Физическая модель движения и окружающей среды
"""
import numpy as np
from typing import Tuple, Optional
from dataclasses import dataclass


@dataclass
class WindModel:
    """Модель ветра"""
    base_velocity: np.ndarray  # Постоянная составляющая [vx, vy, vz] м/с
    turbulence_intensity: float  # Интенсивность турбулентности (0-1)
    gust_probability: float  # Вероятность порыва ветра
    gust_strength: float  # Сила порыва (м/с)
    
    def get_wind_force(self, position: np.ndarray, time: float, drone_mass: float) -> np.ndarray:
        """
        Расчет силы ветра в заданной точке
        
        Args:
            position: Позиция [x, y, z]
            time: Текущее время
            drone_mass: Масса дрона
            
        Returns:
            Сила ветра [Fx, Fy, Fz] в Н
        """
        # Базовая составляющая
        wind_velocity = self.base_velocity.copy()
        
        # Турбулентность (используем синусоиды с разными частотами)
        if self.turbulence_intensity > 0:
            turbulence = np.array([
                np.sin(time * 2.1 + position[0] * 0.1) * self.turbulence_intensity * 2,
                np.cos(time * 1.7 + position[1] * 0.1) * self.turbulence_intensity * 2,
                np.sin(time * 3.3 + position[2] * 0.2) * self.turbulence_intensity * 1
            ])
            wind_velocity += turbulence
        
        # Случайные порывы
        if np.random.random() < self.gust_probability:
            gust_direction = np.random.randn(3)
            gust_direction /= np.linalg.norm(gust_direction)
            wind_velocity += gust_direction * self.gust_strength
        
        # Преобразование скорости ветра в силу
        # F = 0.5 * ρ * A * Cd * v²
        # Упрощенная модель: F ≈ k * m * v
        drag_coefficient = 0.5  # Коэффициент сопротивления
        wind_force = drag_coefficient * drone_mass * wind_velocity
        
        return wind_force


class PhysicsModel:
    """
    Физическая модель окружающей среды и динамики
    """
    
    # Физические константы
    GRAVITY = 9.81  # м/с²
    AIR_DENSITY = 1.225  # кг/м³ на уровне моря
    
    def __init__(self,
                 enable_wind: bool = False,
                 enable_gravity: bool = True,
                 wind_model: Optional[WindModel] = None):
        """
        Инициализация физической модели
        
        Args:
            enable_wind: Включить моделирование ветра
            enable_gravity: Включить гравитацию
            wind_model: Модель ветра
        """
        self.enable_wind = enable_wind
        self.enable_gravity = enable_gravity
        
        if wind_model is None and enable_wind:
            # Модель ветра по умолчанию
            self.wind_model = WindModel(
                base_velocity=np.array([2.0, 1.0, 0.0]),  # Легкий ветер
                turbulence_intensity=0.2,
                gust_probability=0.01,
                gust_strength=5.0
            )
        else:
            self.wind_model = wind_model
    
    def calculate_thrust_required(self, mass: float, 
                                 desired_acceleration: np.ndarray,
                                 current_velocity: np.ndarray = None) -> np.ndarray:
        """
        Расчет требуемой тяги для достижения желаемого ускорения
        
        Args:
            mass: Масса дрона (кг)
            desired_acceleration: Желаемое ускорение [ax, ay, az] (м/с²)
            current_velocity: Текущая скорость (для учета сопротивления воздуха)
            
        Returns:
            Требуемая тяга [Fx, Fy, Fz] в Н
        """
        thrust = mass * desired_acceleration
        
        # Компенсация гравитации
        if self.enable_gravity:
            thrust[2] += mass * self.GRAVITY
        
        # Учет сопротивления воздуха
        if current_velocity is not None:
            drag_force = self.calculate_drag_force(current_velocity, mass)
            thrust += drag_force
        
        return thrust
    
    def calculate_drag_force(self, velocity: np.ndarray, mass: float) -> np.ndarray:
        """
        Расчет силы сопротивления воздуха
        
        Args:
            velocity: Скорость [vx, vy, vz] (м/с)
            mass: Масса дрона (кг)
            
        Returns:
            Сила сопротивления [Fx, Fy, Fz] в Н
        """
        # Упрощенная модель: F_drag = -k * v * |v|
        # где k зависит от формы и размера дрона
        drag_coefficient = 0.1 * mass  # Эмпирический коэффициент
        speed = np.linalg.norm(velocity)
        
        if speed > 0.01:  # Избегаем деления на ноль
            drag_force = -drag_coefficient * velocity * speed
        else:
            drag_force = np.zeros(3)
        
        return drag_force
    
    def calculate_external_forces(self, position: np.ndarray,
                                 velocity: np.ndarray,
                                 mass: float,
                                 time: float) -> np.ndarray:
        """
        Расчет всех внешних сил, действующих на дрон
        
        Args:
            position: Позиция дрона [x, y, z]
            velocity: Скорость дрона [vx, vy, vz]
            mass: Масса дрона
            time: Текущее время симуляции
            
        Returns:
            Суммарная внешняя сила [Fx, Fy, Fz] в Н
        """
        total_force = np.zeros(3)
        
        # Гравитация
        if self.enable_gravity:
            total_force[2] += mass * self.GRAVITY
        
        # Ветер
        if self.enable_wind and self.wind_model:
            wind_force = self.wind_model.get_wind_force(position, time, mass)
            total_force += wind_force
        
        # Сопротивление воздуха
        drag_force = self.calculate_drag_force(velocity, mass)
        total_force += drag_force
        
        return total_force
    
    def calculate_energy_consumption(self, thrust: np.ndarray, 
                                    velocity: np.ndarray,
                                    efficiency: float = 0.7) -> float:
        """
        Расчет потребления энергии
        
        Args:
            thrust: Вектор тяги [Fx, Fy, Fz] в Н
            velocity: Скорость дрона [vx, vy, vz] в м/с
            efficiency: КПД двигателей (0-1)
            
        Returns:
            Потребляемая мощность в Вт
        """
        # Механическая мощность: P = F · v
        mechanical_power = np.abs(np.dot(thrust, velocity))
        
        # Мощность на поддержание высоты
        hover_power = np.abs(thrust[2]) * 2.0  # Эмпирический коэффициент
        
        # Общая электрическая мощность с учетом КПД
        if efficiency > 0:
            total_power = (mechanical_power + hover_power) / efficiency
        else:
            total_power = 0
        
        return total_power
    
    def check_collision(self, pos1: np.ndarray, pos2: np.ndarray,
                       radius1: float = 0.5, radius2: float = 0.5) -> bool:
        """
        Проверка столкновения между двумя объектами
        
        Args:
            pos1: Позиция первого объекта
            pos2: Позиция второго объекта
            radius1: Радиус первого объекта (м)
            radius2: Радиус второго объекта (м)
            
        Returns:
            True если объекты сталкиваются
        """
        distance = np.linalg.norm(pos1 - pos2)
        return distance < (radius1 + radius2)
    
    def calculate_safe_distance(self, velocity1: np.ndarray,
                               velocity2: np.ndarray,
                               reaction_time: float = 1.0,
                               safety_margin: float = 2.0) -> float:
        """
        Расчет безопасной дистанции между дронами
        
        Args:
            velocity1: Скорость первого дрона
            velocity2: Скорость второго дрона
            reaction_time: Время реакции (с)
            safety_margin: Запас безопасности (м)
            
        Returns:
            Минимальная безопасная дистанция (м)
        """
        # Относительная скорость
        relative_velocity = np.linalg.norm(velocity1 - velocity2)
        
        # Дистанция = скорость * время реакции + запас
        safe_distance = relative_velocity * reaction_time + safety_margin
        
        return safe_distance
    
    def atmospheric_pressure(self, altitude: float) -> float:
        """
        Расчет атмосферного давления на заданной высоте
        
        Args:
            altitude: Высота над уровнем моря (м)
            
        Returns:
            Давление (Па)
        """
        # Барометрическая формула
        sea_level_pressure = 101325  # Па
        temperature_lapse = 0.0065  # К/м
        sea_level_temp = 288.15  # К
        
        if altitude < 11000:  # Тропосфера
            pressure = sea_level_pressure * (
                1 - temperature_lapse * altitude / sea_level_temp
            ) ** 5.255
        else:
            pressure = sea_level_pressure * 0.223  # Упрощение для стратосферы
        
        return pressure
    
    def air_density(self, altitude: float) -> float:
        """
        Расчет плотности воздуха на заданной высоте
        
        Args:
            altitude: Высота над уровнем моря (м)
            
        Returns:
            Плотность воздуха (кг/м³)
        """
        pressure = self.atmospheric_pressure(altitude)
        temperature = 288.15 - 0.0065 * altitude  # Упрощенная модель
        gas_constant = 287.05  # Дж/(кг·К)
        
        density = pressure / (gas_constant * temperature)
        return density