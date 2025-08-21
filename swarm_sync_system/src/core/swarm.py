"""
Модель роя беспилотников
"""
import numpy as np
from typing import List, Dict, Optional, Tuple, Callable
from .drone import Drone, DroneStatus
from .physics import PhysicsModel
import networkx as nx


class Swarm:
    """
    Управление роем беспилотников
    """
    
    def __init__(self, physics_model: Optional[PhysicsModel] = None):
        """
        Инициализация роя
        
        Args:
            physics_model: Физическая модель окружающей среды
        """
        self.drones: Dict[str, Drone] = {}
        self.physics = physics_model or PhysicsModel()
        self.time = 0.0
        self.communication_graph = nx.Graph()
        
        # Параметры роя
        self.formation_type = "none"  # Тип строя
        self.leader_id: Optional[str] = None  # ID лидера роя
        self.mission_waypoints: List[np.ndarray] = []  # Путевые точки миссии
        self.current_waypoint_index = 0
        
        # Статистика
        self.stats = {
            'total_distance': 0.0,
            'collisions': 0,
            'communication_breaks': 0,
            'mission_completed': False
        }
    
    def add_drone(self, drone: Drone):
        """
        Добавление дрона в рой
        
        Args:
            drone: Экземпляр дрона
        """
        self.drones[drone.id] = drone
        self.communication_graph.add_node(drone.id)
        
        # Первый дрон становится лидером по умолчанию
        if self.leader_id is None:
            self.leader_id = drone.id
    
    def remove_drone(self, drone_id: str):
        """
        Удаление дрона из роя
        
        Args:
            drone_id: ID дрона
        """
        if drone_id in self.drones:
            del self.drones[drone_id]
            self.communication_graph.remove_node(drone_id)
            
            # Выбор нового лидера при необходимости
            if self.leader_id == drone_id and self.drones:
                self.leader_id = list(self.drones.keys())[0]
    
    def update(self, dt: float):
        """
        Обновление состояния всего роя
        
        Args:
            dt: Временной шаг (с)
        """
        # Обновление графа связи
        self._update_communication_graph()
        
        # Обновление состояния каждого дрона
        for drone in self.drones.values():
            # Расчет внешних сил
            external_force = self.physics.calculate_external_forces(
                drone.state.position,
                drone.state.velocity,
                drone.mass,
                self.time
            )
            
            # Обновление состояния дрона
            drone.update_state(dt, external_force)
        
        # Проверка столкновений
        self._check_collisions()
        
        # Обновление статистики
        self._update_statistics(dt)
        
        # Увеличение времени симуляции
        self.time += dt
    
    def _update_communication_graph(self):
        """Обновление графа связи между дронами"""
        # Очистка существующих ребер
        self.communication_graph.clear_edges()
        
        # Добавление ребер для дронов в радиусе связи
        drone_list = list(self.drones.values())
        for i, drone1 in enumerate(drone_list):
            drone1.neighbors.clear()
            for drone2 in drone_list[i+1:]:
                if drone1.can_communicate_with(drone2):
                    self.communication_graph.add_edge(drone1.id, drone2.id)
                    drone1.neighbors.append(drone2.id)
                    drone2.neighbors.append(drone1.id)
    
    def _check_collisions(self):
        """Проверка столкновений между дронами"""
        drone_list = list(self.drones.values())
        collision_radius = 1.0  # м
        
        for i, drone1 in enumerate(drone_list):
            for drone2 in drone_list[i+1:]:
                if self.physics.check_collision(
                    drone1.state.position,
                    drone2.state.position,
                    collision_radius,
                    collision_radius
                ):
                    self.stats['collisions'] += 1
                    # Аварийная остановка при столкновении
                    drone1.status = DroneStatus.EMERGENCY
                    drone2.status = DroneStatus.EMERGENCY
    
    def _update_statistics(self, dt: float):
        """Обновление статистики роя"""
        for drone in self.drones.values():
            # Подсчет пройденного расстояния
            if len(drone.state_history) > 0:
                distance = np.linalg.norm(
                    drone.state.position - drone.state_history[-1].position
                )
                self.stats['total_distance'] += distance
        
        # Проверка связности графа
        if self.drones and not nx.is_connected(self.communication_graph):
            self.stats['communication_breaks'] += 1
    
    def set_formation(self, formation_type: str, spacing: float = 5.0):
        """
        Установка типа строя
        
        Args:
            formation_type: Тип строя ('line', 'v', 'circle', 'grid', 'diamond')
            spacing: Расстояние между дронами (м)
        """
        self.formation_type = formation_type
        positions = self._calculate_formation_positions(formation_type, spacing)
        
        # Назначение целевых позиций
        for drone, position in zip(self.drones.values(), positions):
            if self.leader_id and drone.id != self.leader_id:
                # Позиция относительно лидера
                leader = self.drones[self.leader_id]
                drone.set_target_position(leader.state.position + position)
            else:
                drone.set_target_position(position)
            drone.status = DroneStatus.FORMATION
    
    def _calculate_formation_positions(self, formation_type: str, 
                                      spacing: float) -> List[np.ndarray]:
        """
        Расчет позиций дронов в строю
        
        Args:
            formation_type: Тип строя
            spacing: Расстояние между дронами
            
        Returns:
            Список относительных позиций
        """
        n = len(self.drones)
        positions = []
        
        if formation_type == 'line':
            # Линейный строй
            for i in range(n):
                pos = np.array([i * spacing, 0, 0])
                positions.append(pos)
        
        elif formation_type == 'v':
            # V-образный строй
            angle = np.pi / 6  # 30 градусов
            for i in range(n):
                if i == 0:
                    pos = np.array([0, 0, 0])
                else:
                    side = 1 if i % 2 == 1 else -1
                    idx = (i + 1) // 2
                    pos = np.array([
                        idx * spacing * np.cos(angle),
                        side * idx * spacing * np.sin(angle),
                        0
                    ])
                positions.append(pos)
        
        elif formation_type == 'circle':
            # Круговой строй
            radius = spacing * n / (2 * np.pi)
            for i in range(n):
                angle = 2 * np.pi * i / n
                pos = np.array([
                    radius * np.cos(angle),
                    radius * np.sin(angle),
                    0
                ])
                positions.append(pos)
        
        elif formation_type == 'grid':
            # Сетка
            cols = int(np.ceil(np.sqrt(n)))
            for i in range(n):
                row = i // cols
                col = i % cols
                pos = np.array([row * spacing, col * spacing, 0])
                positions.append(pos)
        
        elif formation_type == 'diamond':
            # Ромб
            if n == 1:
                positions.append(np.array([0, 0, 0]))
            elif n <= 5:
                # Простой ромб для малого числа дронов
                positions.append(np.array([0, 0, 0]))  # Центр
                if n > 1:
                    positions.append(np.array([spacing, 0, 0]))  # Впереди
                if n > 2:
                    positions.append(np.array([0, spacing, 0]))  # Справа
                if n > 3:
                    positions.append(np.array([-spacing, 0, 0]))  # Сзади
                if n > 4:
                    positions.append(np.array([0, -spacing, 0]))  # Слева
            else:
                # Расширенный ромб для большого числа дронов
                layers = int(np.ceil(np.sqrt(n)))
                drone_idx = 0
                for layer in range(layers):
                    if drone_idx >= n:
                        break
                    if layer == 0:
                        positions.append(np.array([0, 0, 0]))
                        drone_idx += 1
                    else:
                        # Дроны на каждом слое
                        perimeter = 4 * layer
                        for i in range(min(perimeter, n - drone_idx)):
                            # Распределение по периметру ромба
                            side = i // layer
                            offset = i % layer
                            
                            if side == 0:  # Верхняя сторона
                                pos = np.array([
                                    (layer - offset) * spacing,
                                    offset * spacing,
                                    0
                                ])
                            elif side == 1:  # Правая сторона
                                pos = np.array([
                                    -offset * spacing,
                                    (layer - offset) * spacing,
                                    0
                                ])
                            elif side == 2:  # Нижняя сторона
                                pos = np.array([
                                    -(layer - offset) * spacing,
                                    -offset * spacing,
                                    0
                                ])
                            else:  # Левая сторона
                                pos = np.array([
                                    offset * spacing,
                                    -(layer - offset) * spacing,
                                    0
                                ])
                            
                            positions.append(pos)
                            drone_idx += 1
        
        else:
            # По умолчанию - случайное распределение
            for i in range(n):
                pos = np.random.randn(3) * spacing
                pos[2] = 0  # Держим на одной высоте
                positions.append(pos)
        
        return positions
    
    def move_swarm_to(self, target_position: np.ndarray):
        """
        Перемещение всего роя к целевой позиции
        
        Args:
            target_position: Целевая позиция [x, y, z]
        """
        if self.formation_type != 'none':
            # Движение в строю
            positions = self._calculate_formation_positions(
                self.formation_type, 
                5.0  # Стандартное расстояние
            )
            for drone, rel_pos in zip(self.drones.values(), positions):
                drone.set_target_position(target_position + rel_pos)
        else:
            # Свободное движение
            for drone in self.drones.values():
                drone.set_target_position(target_position)
    
    def set_mission(self, waypoints: List[np.ndarray]):
        """
        Установка миссии (последовательность путевых точек)
        
        Args:
            waypoints: Список путевых точек
        """
        self.mission_waypoints = waypoints
        self.current_waypoint_index = 0
        if waypoints:
            self.move_swarm_to(waypoints[0])
    
    def update_mission(self):
        """Обновление выполнения миссии"""
        if not self.mission_waypoints:
            return
        
        current_waypoint = self.mission_waypoints[self.current_waypoint_index]
        
        # Проверка достижения текущей путевой точки
        all_arrived = all(
            drone.get_distance_to(current_waypoint) < 2.0
            for drone in self.drones.values()
        )
        
        if all_arrived:
            self.current_waypoint_index += 1
            if self.current_waypoint_index < len(self.mission_waypoints):
                # Переход к следующей точке
                self.move_swarm_to(self.mission_waypoints[self.current_waypoint_index])
            else:
                # Миссия завершена
                self.stats['mission_completed'] = True
    
    def get_center_of_mass(self) -> np.ndarray:
        """
        Расчет центра масс роя
        
        Returns:
            Позиция центра масс [x, y, z]
        """
        if not self.drones:
            return np.zeros(3)
        
        total_mass = 0
        weighted_position = np.zeros(3)
        
        for drone in self.drones.values():
            weighted_position += drone.state.position * drone.mass
            total_mass += drone.mass
        
        return weighted_position / total_mass if total_mass > 0 else np.zeros(3)
    
    def get_swarm_radius(self) -> float:
        """
        Расчет радиуса роя (максимальное расстояние от центра)
        
        Returns:
            Радиус роя (м)
        """
        if not self.drones:
            return 0.0
        
        center = self.get_center_of_mass()
        max_distance = 0.0
        
        for drone in self.drones.values():
            distance = np.linalg.norm(drone.state.position - center)
            max_distance = max(max_distance, distance)
        
        return max_distance
    
    def get_connectivity(self) -> float:
        """
        Расчет связности роя (0-1)
        
        Returns:
            Коэффициент связности
        """
        if len(self.drones) <= 1:
            return 1.0
        
        # Проверка связности графа
        if nx.is_connected(self.communication_graph):
            # Расчет средней степени связности
            n = len(self.drones)
            max_edges = n * (n - 1) / 2
            current_edges = self.communication_graph.number_of_edges()
            return current_edges / max_edges if max_edges > 0 else 0.0
        else:
            # Граф не связный
            return 0.0
    
    def emergency_stop(self):
        """Аварийная остановка всех дронов"""
        for drone in self.drones.values():
            drone.status = DroneStatus.EMERGENCY
            drone.target_position = drone.state.position.copy()
            drone.state.velocity = np.zeros(3)
            drone.state.acceleration = np.zeros(3)
    
    def get_status_summary(self) -> Dict:
        """
        Получение сводки состояния роя
        
        Returns:
            Словарь с информацией о состоянии
        """
        status_counts = {}
        for drone in self.drones.values():
            status = drone.status.value
            status_counts[status] = status_counts.get(status, 0) + 1
        
        return {
            'total_drones': len(self.drones),
            'status_counts': status_counts,
            'connectivity': self.get_connectivity(),
            'swarm_radius': self.get_swarm_radius(),
            'center_of_mass': self.get_center_of_mass().tolist(),
            'leader_id': self.leader_id,
            'formation': self.formation_type,
            'mission_progress': f"{self.current_waypoint_index}/{len(self.mission_waypoints)}",
            'statistics': self.stats
        }
    
    def __repr__(self) -> str:
        return (f"Swarm(drones={len(self.drones)}, "
                f"formation={self.formation_type}, "
                f"connectivity={self.get_connectivity():.2f}, "
                f"time={self.time:.2f}s)")