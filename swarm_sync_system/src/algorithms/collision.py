"""
Алгоритмы избегания столкновений для роя беспилотников
"""
import numpy as np
from typing import Dict, List, Tuple, Optional
from dataclasses import dataclass
from enum import Enum


class CollisionAvoidanceMethod(Enum):
    """Методы избегания столкновений"""
    POTENTIAL_FIELD = "potential_field"
    VELOCITY_OBSTACLE = "velocity_obstacle"
    ORCA = "orca"  # Optimal Reciprocal Collision Avoidance
    BARRIER_FUNCTION = "barrier_function"


@dataclass
class Obstacle:
    """Описание препятствия"""
    position: np.ndarray
    velocity: np.ndarray
    radius: float
    is_static: bool = False
    
    def __post_init__(self):
        self.position = np.asarray(self.position)
        self.velocity = np.asarray(self.velocity)


class CollisionAvoidance:
    """
    Базовый класс для алгоритмов избегания столкновений
    """
    
    def __init__(self, safety_radius: float = 2.0,
                 max_avoidance_force: float = 10.0):
        """
        Args:
            safety_radius: Безопасный радиус вокруг агента (м)
            max_avoidance_force: Максимальная сила избегания (Н)
        """
        self.safety_radius = safety_radius
        self.max_avoidance_force = max_avoidance_force
    
    def compute_avoidance(self, agent_pos: np.ndarray,
                         agent_vel: np.ndarray,
                         obstacles: List[Obstacle]) -> np.ndarray:
        """
        Вычисление силы избегания
        
        Args:
            agent_pos: Позиция агента
            agent_vel: Скорость агента
            obstacles: Список препятствий
            
        Returns:
            Вектор силы избегания
        """
        raise NotImplementedError


class PotentialFieldAvoidance(CollisionAvoidance):
    """
    Метод искусственных потенциальных полей
    
    Препятствия создают отталкивающие поля,
    цели - притягивающие.
    """
    
    def __init__(self, repulsive_gain: float = 100.0,
                 influence_distance: float = 5.0,
                 **kwargs):
        """
        Args:
            repulsive_gain: Коэффициент отталкивания
            influence_distance: Дистанция влияния препятствия
        """
        super().__init__(**kwargs)
        self.repulsive_gain = repulsive_gain
        self.influence_distance = influence_distance
    
    def compute_avoidance(self, agent_pos: np.ndarray,
                         agent_vel: np.ndarray,
                         obstacles: List[Obstacle]) -> np.ndarray:
        """
        Вычисление отталкивающей силы от препятствий
        """
        total_force = np.zeros(3)
        
        for obstacle in obstacles:
            force = self._repulsive_force(agent_pos, obstacle)
            total_force += force
        
        # Ограничение силы
        force_magnitude = np.linalg.norm(total_force)
        if force_magnitude > self.max_avoidance_force:
            total_force = total_force * (self.max_avoidance_force / force_magnitude)
        
        return total_force
    
    def _repulsive_force(self, agent_pos: np.ndarray,
                        obstacle: Obstacle) -> np.ndarray:
        """
        Расчет отталкивающей силы от одного препятствия
        
        Потенциал: U = 0.5 * k * (1/d - 1/d0)^2, если d < d0
        Сила: F = -∇U
        """
        # Вектор от препятствия к агенту
        diff = agent_pos - obstacle.position
        distance = np.linalg.norm(diff)
        
        # Учет радиусов
        effective_distance = distance - obstacle.radius - self.safety_radius
        
        if effective_distance <= 0:
            # Критическое сближение - максимальная сила
            if distance > 0:
                return (diff / distance) * self.max_avoidance_force
            else:
                # Случайное направление при совпадении позиций
                return np.random.randn(3) * self.max_avoidance_force
        
        if effective_distance < self.influence_distance:
            # В зоне влияния
            magnitude = self.repulsive_gain * (
                1.0 / effective_distance - 1.0 / self.influence_distance
            ) * (1.0 / (effective_distance ** 2))
            
            if distance > 0:
                force = magnitude * (diff / distance)
            else:
                force = np.zeros(3)
            
            return force
        
        return np.zeros(3)
    
    def compute_attractive_force(self, agent_pos: np.ndarray,
                                target_pos: np.ndarray,
                                attractive_gain: float = 1.0) -> np.ndarray:
        """
        Расчет притягивающей силы к цели
        
        Args:
            agent_pos: Позиция агента
            target_pos: Целевая позиция
            attractive_gain: Коэффициент притяжения
            
        Returns:
            Вектор притягивающей силы
        """
        diff = target_pos - agent_pos
        distance = np.linalg.norm(diff)
        
        if distance > 0:
            # Линейное притяжение
            force = attractive_gain * diff
            
            # Ограничение силы
            force_magnitude = np.linalg.norm(force)
            if force_magnitude > self.max_avoidance_force:
                force = force * (self.max_avoidance_force / force_magnitude)
            
            return force
        
        return np.zeros(3)


class VelocityObstacleAvoidance(CollisionAvoidance):
    """
    Метод Velocity Obstacle (VO)
    
    Определяет конус скоростей, ведущих к столкновению,
    и выбирает скорость вне этого конуса.
    """
    
    def __init__(self, time_horizon: float = 5.0,
                 preferred_speed: float = 10.0,
                 **kwargs):
        """
        Args:
            time_horizon: Горизонт планирования (с)
            preferred_speed: Предпочтительная скорость (м/с)
        """
        super().__init__(**kwargs)
        self.time_horizon = time_horizon
        self.preferred_speed = preferred_speed
    
    def compute_avoidance(self, agent_pos: np.ndarray,
                         agent_vel: np.ndarray,
                         obstacles: List[Obstacle],
                         preferred_velocity: np.ndarray = None) -> np.ndarray:
        """
        Вычисление скорости избегания методом VO
        """
        if preferred_velocity is None:
            preferred_velocity = agent_vel
        
        # Поиск допустимых скоростей
        best_velocity = preferred_velocity
        min_penalty = float('inf')
        
        # Дискретизация пространства скоростей
        samples = self._sample_velocities(agent_vel, 20)
        
        for sample_vel in samples:
            if self._is_collision_free(agent_pos, sample_vel, obstacles):
                penalty = np.linalg.norm(sample_vel - preferred_velocity)
                if penalty < min_penalty:
                    min_penalty = penalty
                    best_velocity = sample_vel
        
        # Вычисление силы для достижения целевой скорости
        force = (best_velocity - agent_vel) * 10.0  # Коэффициент усиления
        
        # Ограничение силы
        force_magnitude = np.linalg.norm(force)
        if force_magnitude > self.max_avoidance_force:
            force = force * (self.max_avoidance_force / force_magnitude)
        
        return force
    
    def _is_collision_free(self, agent_pos: np.ndarray,
                          agent_vel: np.ndarray,
                          obstacles: List[Obstacle]) -> bool:
        """
        Проверка отсутствия столкновений для заданной скорости
        """
        for obstacle in obstacles:
            if self._will_collide(agent_pos, agent_vel, obstacle):
                return False
        return True
    
    def _will_collide(self, agent_pos: np.ndarray,
                     agent_vel: np.ndarray,
                     obstacle: Obstacle) -> bool:
        """
        Проверка столкновения с препятствием
        """
        # Относительная позиция и скорость
        rel_pos = obstacle.position - agent_pos
        rel_vel = obstacle.velocity - agent_vel
        
        # Проверка на временном горизонте
        for t in np.linspace(0, self.time_horizon, 20):
            future_rel_pos = rel_pos + rel_vel * t
            distance = np.linalg.norm(future_rel_pos)
            
            if distance < (obstacle.radius + self.safety_radius):
                return True
        
        return False
    
    def _sample_velocities(self, current_vel: np.ndarray,
                          num_samples: int) -> List[np.ndarray]:
        """
        Генерация выборки возможных скоростей
        """
        samples = [current_vel]  # Включаем текущую скорость
        
        # Генерация случайных направлений
        for _ in range(num_samples - 1):
            # Случайное направление
            direction = np.random.randn(3)
            direction /= np.linalg.norm(direction)
            
            # Случайная скорость
            speed = np.random.uniform(0, self.preferred_speed * 1.5)
            
            samples.append(direction * speed)
        
        return samples


class ORCAAvoidance(CollisionAvoidance):
    """
    Optimal Reciprocal Collision Avoidance (ORCA)
    
    Расширение VO с учетом взаимного избегания.
    """
    
    def __init__(self, time_horizon: float = 5.0,
                 responsibility_factor: float = 0.5,
                 **kwargs):
        """
        Args:
            time_horizon: Горизонт планирования
            responsibility_factor: Доля ответственности за избегание (0.5 = равная)
        """
        super().__init__(**kwargs)
        self.time_horizon = time_horizon
        self.responsibility_factor = responsibility_factor
    
    def compute_avoidance(self, agent_pos: np.ndarray,
                         agent_vel: np.ndarray,
                         obstacles: List[Obstacle],
                         preferred_velocity: np.ndarray = None) -> np.ndarray:
        """
        Вычисление скорости методом ORCA
        """
        if preferred_velocity is None:
            preferred_velocity = agent_vel
        
        # Построение линейных ограничений ORCA
        constraints = []
        for obstacle in obstacles:
            constraint = self._compute_orca_constraint(
                agent_pos, agent_vel, obstacle
            )
            if constraint is not None:
                constraints.append(constraint)
        
        # Решение задачи линейного программирования
        if constraints:
            new_velocity = self._solve_linear_program(
                preferred_velocity, constraints
            )
        else:
            new_velocity = preferred_velocity
        
        # Вычисление силы
        force = (new_velocity - agent_vel) * 10.0
        
        # Ограничение
        force_magnitude = np.linalg.norm(force)
        if force_magnitude > self.max_avoidance_force:
            force = force * (self.max_avoidance_force / force_magnitude)
        
        return force
    
    def _compute_orca_constraint(self, agent_pos: np.ndarray,
                                agent_vel: np.ndarray,
                                obstacle: Obstacle) -> Optional[Tuple[np.ndarray, float]]:
        """
        Вычисление ORCA ограничения для препятствия
        
        Returns:
            (normal, distance) - нормаль и расстояние до полуплоскости
        """
        rel_pos = obstacle.position - agent_pos
        rel_vel = agent_vel - obstacle.velocity
        dist_sq = np.dot(rel_pos, rel_pos)
        combined_radius = obstacle.radius + self.safety_radius
        combined_radius_sq = combined_radius ** 2
        
        if dist_sq > combined_radius_sq:
            # Нет непосредственного столкновения
            # Проверка столкновения в будущем
            
            # Время до ближайшего сближения
            w = rel_pos + rel_vel * self.time_horizon
            w_length_sq = np.dot(w, w)
            dot_product = np.dot(w, rel_pos)
            
            if dot_product < 0 and dot_product ** 2 > combined_radius_sq * w_length_sq:
                # Нет столкновения
                return None
            
            # Вычисление ORCA линии
            w_length = np.sqrt(w_length_sq)
            unit_w = w / w_length if w_length > 0 else np.array([1, 0, 0])
            
            # Направление линии ORCA
            if np.dot(rel_vel, unit_w) > 0:
                normal = unit_w
            else:
                normal = -unit_w
            
            # Расстояние до линии
            u = (rel_vel - (combined_radius / self.time_horizon) * unit_w) * self.responsibility_factor
            distance = np.dot(u, normal)
            
            return (normal, distance)
        else:
            # Агенты уже пересекаются - экстренное избегание
            if np.linalg.norm(rel_pos) > 0:
                normal = -rel_pos / np.linalg.norm(rel_pos)
            else:
                normal = np.array([1, 0, 0])
            
            distance = self.max_avoidance_force
            return (normal, distance)
    
    def _solve_linear_program(self, preferred_velocity: np.ndarray,
                             constraints: List[Tuple[np.ndarray, float]]) -> np.ndarray:
        """
        Решение задачи линейного программирования для ORCA
        
        Находит ближайшую к preferred_velocity точку,
        удовлетворяющую всем ограничениям.
        """
        result = preferred_velocity.copy()
        
        for normal, distance in constraints:
            # Проекция на полуплоскость
            projection = np.dot(result, normal) - distance
            if projection < 0:
                # Нарушение ограничения - проекция на границу
                result = result - projection * normal
        
        return result


class BarrierFunctionAvoidance(CollisionAvoidance):
    """
    Метод барьерных функций (Control Barrier Functions)
    
    Гарантирует безопасность через ограничения на управление.
    """
    
    def __init__(self, barrier_gain: float = 10.0,
                 min_distance: float = 1.0,
                 **kwargs):
        """
        Args:
            barrier_gain: Коэффициент барьерной функции
            min_distance: Минимально допустимое расстояние
        """
        super().__init__(**kwargs)
        self.barrier_gain = barrier_gain
        self.min_distance = min_distance
    
    def compute_avoidance(self, agent_pos: np.ndarray,
                         agent_vel: np.ndarray,
                         obstacles: List[Obstacle],
                         desired_control: np.ndarray = None) -> np.ndarray:
        """
        Вычисление безопасного управления с барьерными функциями
        """
        if desired_control is None:
            desired_control = np.zeros(3)
        
        safe_control = desired_control.copy()
        
        for obstacle in obstacles:
            # Барьерная функция h(x) = ||x_agent - x_obs||^2 - r^2
            rel_pos = agent_pos - obstacle.position
            distance = np.linalg.norm(rel_pos)
            safe_distance = obstacle.radius + self.safety_radius + self.min_distance
            
            h = distance ** 2 - safe_distance ** 2
            
            if h < self.barrier_gain:
                # Активация барьера
                # ∂h/∂x
                dh_dx = 2 * rel_pos
                
                # Условие безопасности: ḣ + α(h) ≥ 0
                # где α(h) = barrier_gain * h
                
                rel_vel = agent_vel - obstacle.velocity
                h_dot = 2 * np.dot(rel_pos, rel_vel)
                
                # Требуемое ограничение на управление
                constraint = -h_dot - self.barrier_gain * h
                
                if constraint > 0:
                    # Модификация управления
                    if np.linalg.norm(dh_dx) > 0:
                        # Проекция на безопасное направление
                        unsafe_component = np.dot(safe_control, dh_dx) / np.dot(dh_dx, dh_dx)
                        if unsafe_component < 0:
                            safe_control -= unsafe_component * dh_dx
        
        # Ограничение управления
        control_magnitude = np.linalg.norm(safe_control)
        if control_magnitude > self.max_avoidance_force:
            safe_control = safe_control * (self.max_avoidance_force / control_magnitude)
        
        return safe_control
    
    def verify_safety(self, agent_pos: np.ndarray,
                     agent_vel: np.ndarray,
                     control: np.ndarray,
                     obstacles: List[Obstacle]) -> bool:
        """
        Проверка безопасности управления
        
        Args:
            agent_pos: Позиция агента
            agent_vel: Скорость агента
            control: Предлагаемое управление
            obstacles: Препятствия
            
        Returns:
            True если управление безопасно
        """
        for obstacle in obstacles:
            rel_pos = agent_pos - obstacle.position
            distance = np.linalg.norm(rel_pos)
            safe_distance = obstacle.radius + self.safety_radius + self.min_distance
            
            h = distance ** 2 - safe_distance ** 2
            
            # Прогноз изменения барьерной функции
            rel_vel = agent_vel - obstacle.velocity
            new_rel_vel = rel_vel + control * 0.1  # dt = 0.1
            h_dot = 2 * np.dot(rel_pos, new_rel_vel)
            
            # Проверка условия безопасности
            if h_dot + self.barrier_gain * h < 0:
                return False
        
        return True


class HybridCollisionAvoidance:
    """
    Гибридный метод, комбинирующий несколько алгоритмов
    """
    
    def __init__(self, methods: List[CollisionAvoidanceMethod] = None):
        """
        Args:
            methods: Список используемых методов
        """
        if methods is None:
            methods = [
                CollisionAvoidanceMethod.POTENTIAL_FIELD,
                CollisionAvoidanceMethod.VELOCITY_OBSTACLE
            ]
        
        self.methods = {}
        for method in methods:
            if method == CollisionAvoidanceMethod.POTENTIAL_FIELD:
                self.methods[method] = PotentialFieldAvoidance()
            elif method == CollisionAvoidanceMethod.VELOCITY_OBSTACLE:
                self.methods[method] = VelocityObstacleAvoidance()
            elif method == CollisionAvoidanceMethod.ORCA:
                self.methods[method] = ORCAAvoidance()
            elif method == CollisionAvoidanceMethod.BARRIER_FUNCTION:
                self.methods[method] = BarrierFunctionAvoidance()
    
    def compute_avoidance(self, agent_pos: np.ndarray,
                         agent_vel: np.ndarray,
                         obstacles: List[Obstacle],
                         weights: Dict[CollisionAvoidanceMethod, float] = None) -> np.ndarray:
        """
        Вычисление комбинированной силы избегания
        
        Args:
            agent_pos: Позиция агента
            agent_vel: Скорость агента
            obstacles: Препятствия
            weights: Веса для каждого метода
            
        Returns:
            Комбинированная сила избегания
        """
        if weights is None:
            # Равные веса по умолчанию
            weights = {method: 1.0 / len(self.methods) for method in self.methods}
        
        total_force = np.zeros(3)
        
        for method, algorithm in self.methods.items():
            weight = weights.get(method, 1.0)
            force = algorithm.compute_avoidance(agent_pos, agent_vel, obstacles)
            total_force += weight * force
        
        return total_force