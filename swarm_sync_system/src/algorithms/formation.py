"""
Алгоритмы формирования и поддержания строя
"""
import numpy as np
from typing import Dict, List, Optional, Tuple, Callable
from dataclasses import dataclass
from enum import Enum


class FormationType(Enum):
    """Типы формаций"""
    LINE = "line"
    WEDGE = "wedge"
    CIRCLE = "circle"
    SQUARE = "square"
    DIAMOND = "diamond"
    SPHERE = "sphere"
    HELIX = "helix"
    CUSTOM = "custom"


@dataclass
class FormationConfig:
    """Конфигурация формации"""
    type: FormationType
    spacing: float  # Расстояние между агентами (м)
    scale: float = 1.0  # Масштаб формации
    rotation: np.ndarray = None  # Углы поворота формации [roll, pitch, yaw]
    center: np.ndarray = None  # Центр формации
    
    def __post_init__(self):
        if self.rotation is None:
            self.rotation = np.zeros(3)
        if self.center is None:
            self.center = np.zeros(3)


class FormationController:
    """
    Контроллер формирования и поддержания строя
    """
    
    def __init__(self, config: FormationConfig):
        """
        Args:
            config: Конфигурация формации
        """
        self.config = config
        self.agent_positions: Dict[str, np.ndarray] = {}
        self.reference_positions: Dict[str, np.ndarray] = {}
        self.formation_error = 0.0
        
        # Параметры управления
        self.kp = 2.0  # Пропорциональный коэффициент
        self.kd = 1.0  # Дифференциальный коэффициент
        self.ki = 0.1  # Интегральный коэффициент
        self.integral_errors: Dict[str, np.ndarray] = {}
    
    def generate_formation(self, num_agents: int) -> Dict[int, np.ndarray]:
        """
        Генерация позиций для заданной формации
        
        Args:
            num_agents: Количество агентов
            
        Returns:
            Словарь позиций {agent_index: position}
        """
        if self.config.type == FormationType.LINE:
            positions = self._generate_line(num_agents)
        elif self.config.type == FormationType.WEDGE:
            positions = self._generate_wedge(num_agents)
        elif self.config.type == FormationType.CIRCLE:
            positions = self._generate_circle(num_agents)
        elif self.config.type == FormationType.SQUARE:
            positions = self._generate_square(num_agents)
        elif self.config.type == FormationType.DIAMOND:
            positions = self._generate_diamond(num_agents)
        elif self.config.type == FormationType.SPHERE:
            positions = self._generate_sphere(num_agents)
        elif self.config.type == FormationType.HELIX:
            positions = self._generate_helix(num_agents)
        else:
            positions = self._generate_random(num_agents)
        
        # Применение трансформаций
        positions = self._apply_transformations(positions)
        
        return positions
    
    def _generate_line(self, n: int) -> Dict[int, np.ndarray]:
        """Линейная формация"""
        positions = {}
        for i in range(n):
            offset = (i - (n-1)/2) * self.config.spacing
            positions[i] = np.array([offset, 0, 0])
        return positions
    
    def _generate_wedge(self, n: int) -> Dict[int, np.ndarray]:
        """V-образная формация"""
        positions = {}
        angle = np.pi / 4  # 45 градусов
        
        positions[0] = np.array([0, 0, 0])  # Лидер впереди
        
        for i in range(1, n):
            side = 1 if i % 2 == 1 else -1
            row = (i + 1) // 2
            x = -row * self.config.spacing * np.cos(angle)
            y = side * row * self.config.spacing * np.sin(angle)
            positions[i] = np.array([x, y, 0])
        
        return positions
    
    def _generate_circle(self, n: int) -> Dict[int, np.ndarray]:
        """Круговая формация"""
        positions = {}
        radius = self.config.spacing * n / (2 * np.pi)
        
        for i in range(n):
            angle = 2 * np.pi * i / n
            x = radius * np.cos(angle)
            y = radius * np.sin(angle)
            positions[i] = np.array([x, y, 0])
        
        return positions
    
    def _generate_square(self, n: int) -> Dict[int, np.ndarray]:
        """Квадратная сетка"""
        positions = {}
        side = int(np.ceil(np.sqrt(n)))
        
        for i in range(n):
            row = i // side
            col = i % side
            x = (col - (side-1)/2) * self.config.spacing
            y = (row - (side-1)/2) * self.config.spacing
            positions[i] = np.array([x, y, 0])
        
        return positions
    
    def _generate_diamond(self, n: int) -> Dict[int, np.ndarray]:
        """Ромбовидная формация"""
        positions = {}
        
        if n == 1:
            positions[0] = np.array([0, 0, 0])
        elif n <= 5:
            # Простой ромб
            positions[0] = np.array([0, 0, 0])
            if n > 1:
                positions[1] = np.array([self.config.spacing, 0, 0])
            if n > 2:
                positions[2] = np.array([0, self.config.spacing, 0])
            if n > 3:
                positions[3] = np.array([-self.config.spacing, 0, 0])
            if n > 4:
                positions[4] = np.array([0, -self.config.spacing, 0])
        else:
            # Многослойный ромб
            idx = 0
            layer = 0
            while idx < n:
                if layer == 0:
                    positions[idx] = np.array([0, 0, 0])
                    idx += 1
                else:
                    # Точки на каждом слое
                    points_in_layer = min(4 * layer, n - idx)
                    for j in range(points_in_layer):
                        angle = 2 * np.pi * j / points_in_layer
                        r = layer * self.config.spacing
                        x = r * np.cos(angle + np.pi/4)  # Поворот на 45°
                        y = r * np.sin(angle + np.pi/4)
                        positions[idx] = np.array([x, y, 0])
                        idx += 1
                layer += 1
        
        return positions
    
    def _generate_sphere(self, n: int) -> Dict[int, np.ndarray]:
        """Сферическая формация"""
        positions = {}
        
        # Алгоритм спиральной укладки на сфере
        radius = self.config.spacing * np.cbrt(n)
        
        for i in range(n):
            # Золотой угол
            golden_angle = np.pi * (3 - np.sqrt(5))
            theta = golden_angle * i
            
            # Равномерное распределение по высоте
            y = 1 - (2 * i / (n - 1)) if n > 1 else 0
            radius_at_y = np.sqrt(1 - y * y)
            
            x = np.cos(theta) * radius_at_y
            z = np.sin(theta) * radius_at_y
            
            positions[i] = np.array([x, y, z]) * radius
        
        return positions
    
    def _generate_helix(self, n: int) -> Dict[int, np.ndarray]:
        """Спиральная формация"""
        positions = {}
        
        radius = self.config.spacing * 2
        pitch = self.config.spacing  # Шаг спирали
        
        for i in range(n):
            t = i * 2 * np.pi / 6  # 6 точек на виток
            x = radius * np.cos(t)
            y = radius * np.sin(t)
            z = pitch * t / (2 * np.pi)
            positions[i] = np.array([x, y, z])
        
        return positions
    
    def _generate_random(self, n: int) -> Dict[int, np.ndarray]:
        """Случайное распределение"""
        positions = {}
        for i in range(n):
            pos = np.random.randn(3) * self.config.spacing * 2
            positions[i] = pos
        return positions
    
    def _apply_transformations(self, positions: Dict[int, np.ndarray]) -> Dict[int, np.ndarray]:
        """
        Применение трансформаций к формации
        
        Args:
            positions: Исходные позиции
            
        Returns:
            Трансформированные позиции
        """
        # Матрица поворота
        R = self._rotation_matrix(self.config.rotation)
        
        transformed = {}
        for idx, pos in positions.items():
            # Масштабирование
            scaled = pos * self.config.scale
            # Поворот
            rotated = R @ scaled
            # Смещение
            transformed[idx] = rotated + self.config.center
        
        return transformed
    
    def _rotation_matrix(self, angles: np.ndarray) -> np.ndarray:
        """
        Создание матрицы поворота из углов Эйлера
        
        Args:
            angles: [roll, pitch, yaw] в радианах
            
        Returns:
            3x3 матрица поворота
        """
        roll, pitch, yaw = angles
        
        # Матрицы поворота вокруг осей
        Rx = np.array([
            [1, 0, 0],
            [0, np.cos(roll), -np.sin(roll)],
            [0, np.sin(roll), np.cos(roll)]
        ])
        
        Ry = np.array([
            [np.cos(pitch), 0, np.sin(pitch)],
            [0, 1, 0],
            [-np.sin(pitch), 0, np.cos(pitch)]
        ])
        
        Rz = np.array([
            [np.cos(yaw), -np.sin(yaw), 0],
            [np.sin(yaw), np.cos(yaw), 0],
            [0, 0, 1]
        ])
        
        # Композиция поворотов
        return Rz @ Ry @ Rx
    
    def compute_control(self, agent_id: str, 
                       current_pos: np.ndarray,
                       current_vel: np.ndarray,
                       reference_pos: np.ndarray) -> np.ndarray:
        """
        Вычисление управляющего воздействия для поддержания формации
        
        Args:
            agent_id: ID агента
            current_pos: Текущая позиция
            current_vel: Текущая скорость
            reference_pos: Целевая позиция в формации
            
        Returns:
            Управляющее ускорение
        """
        # Ошибка позиции
        position_error = reference_pos - current_pos
        
        # ПИД-регулятор
        # Пропорциональная составляющая
        p_term = self.kp * position_error
        
        # Дифференциальная составляющая (демпфирование)
        d_term = -self.kd * current_vel
        
        # Интегральная составляющая
        if agent_id not in self.integral_errors:
            self.integral_errors[agent_id] = np.zeros(3)
        
        self.integral_errors[agent_id] += position_error * 0.01  # dt = 0.01
        # Анти-windup
        self.integral_errors[agent_id] = np.clip(
            self.integral_errors[agent_id], -10, 10
        )
        i_term = self.ki * self.integral_errors[agent_id]
        
        # Суммарное управление
        control = p_term + d_term + i_term
        
        return control
    
    def maintain_formation(self, agent_positions: Dict[str, np.ndarray],
                          agent_velocities: Dict[str, np.ndarray]) -> Dict[str, np.ndarray]:
        """
        Поддержание формации для всех агентов
        
        Args:
            agent_positions: Текущие позиции агентов
            agent_velocities: Текущие скорости агентов
            
        Returns:
            Управляющие воздействия для каждого агента
        """
        controls = {}
        
        # Генерация референсных позиций если не заданы
        if not self.reference_positions:
            n = len(agent_positions)
            ref_positions = self.generate_formation(n)
            # Привязка к ID агентов
            for i, agent_id in enumerate(agent_positions.keys()):
                self.reference_positions[agent_id] = ref_positions[i]
        
        # Вычисление управления для каждого агента
        for agent_id in agent_positions:
            if agent_id in self.reference_positions:
                control = self.compute_control(
                    agent_id,
                    agent_positions[agent_id],
                    agent_velocities[agent_id],
                    self.reference_positions[agent_id]
                )
                controls[agent_id] = control
        
        # Обновление ошибки формации
        self._update_formation_error(agent_positions)
        
        return controls
    
    def _update_formation_error(self, agent_positions: Dict[str, np.ndarray]):
        """Обновление метрики ошибки формации"""
        if not self.reference_positions:
            self.formation_error = 0.0
            return
        
        total_error = 0.0
        count = 0
        
        for agent_id, current_pos in agent_positions.items():
            if agent_id in self.reference_positions:
                error = np.linalg.norm(
                    current_pos - self.reference_positions[agent_id]
                )
                total_error += error
                count += 1
        
        self.formation_error = total_error / count if count > 0 else 0.0
    
    def adapt_formation(self, obstacles: List[np.ndarray] = None,
                       target: np.ndarray = None):
        """
        Адаптация формации к препятствиям и целям
        
        Args:
            obstacles: Список позиций препятствий
            target: Целевая точка движения
        """
        if obstacles:
            # Деформация формации для обхода препятствий
            self._deform_for_obstacles(obstacles)
        
        if target is not None:
            # Ориентация формации к цели
            self._orient_to_target(target)
    
    def _deform_for_obstacles(self, obstacles: List[np.ndarray]):
        """Деформация формации для обхода препятствий"""
        for agent_id, ref_pos in self.reference_positions.items():
            for obstacle in obstacles:
                distance = np.linalg.norm(ref_pos - obstacle)
                if distance < self.config.spacing * 2:
                    # Отталкивание от препятствия
                    repulsion = (ref_pos - obstacle) / distance
                    self.reference_positions[agent_id] += repulsion * self.config.spacing
    
    def _orient_to_target(self, target: np.ndarray):
        """Ориентация формации к цели"""
        # Вычисление направления к цели
        center = np.mean(list(self.reference_positions.values()), axis=0)
        direction = target - center
        
        if np.linalg.norm(direction) > 0.01:
            # Вычисление угла поворота
            yaw = np.arctan2(direction[1], direction[0])
            self.config.rotation[2] = yaw
            
            # Перегенерация формации с новой ориентацией
            n = len(self.reference_positions)
            new_positions = self.generate_formation(n)
            for i, agent_id in enumerate(self.reference_positions.keys()):
                self.reference_positions[agent_id] = new_positions[i]
    
    def get_formation_quality(self) -> float:
        """
        Оценка качества формации
        
        Returns:
            Качество формации (0-1)
        """
        if self.formation_error < 0.1:
            return 1.0
        elif self.formation_error > self.config.spacing:
            return 0.0
        else:
            return 1.0 - (self.formation_error / self.config.spacing)