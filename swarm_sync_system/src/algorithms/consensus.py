"""
Алгоритмы распределенного консенсуса для синхронизации роя
"""
import numpy as np
from typing import Dict, List, Optional, Callable, Any
from abc import ABC, abstractmethod
import networkx as nx


class ConsensusAlgorithm(ABC):
    """
    Базовый класс для алгоритмов консенсуса
    """
    
    def __init__(self, convergence_threshold: float = 1e-6, max_iterations: int = 1000):
        """
        Args:
            convergence_threshold: Порог сходимости
            max_iterations: Максимальное число итераций
        """
        self.convergence_threshold = convergence_threshold
        self.max_iterations = max_iterations
        self.iteration = 0
        self.converged = False
    
    @abstractmethod
    def update(self, agent_id: str, current_value: Any, 
               neighbor_values: Dict[str, Any]) -> Any:
        """
        Обновление значения агента на основе значений соседей
        
        Args:
            agent_id: ID агента
            current_value: Текущее значение агента
            neighbor_values: Словарь значений соседей {id: value}
            
        Returns:
            Новое значение агента
        """
        pass
    
    def check_convergence(self, values: Dict[str, Any], 
                         prev_values: Dict[str, Any]) -> bool:
        """
        Проверка сходимости алгоритма
        
        Args:
            values: Текущие значения агентов
            prev_values: Предыдущие значения агентов
            
        Returns:
            True если алгоритм сошелся
        """
        if not prev_values:
            return False
        
        # Расчет максимального изменения
        max_change = 0
        for agent_id in values:
            if agent_id in prev_values:
                change = np.linalg.norm(
                    np.array(values[agent_id]) - np.array(prev_values[agent_id])
                )
                max_change = max(max_change, change)
        
        return max_change < self.convergence_threshold


class AverageConsensus(ConsensusAlgorithm):
    """
    Алгоритм усредняющего консенсуса
    
    Каждый агент обновляет свое значение как взвешенное среднее
    своего текущего значения и значений соседей.
    
    Математическая модель:
    x_i(t+1) = w_ii * x_i(t) + Σ(w_ij * x_j(t))
    где w_ij - веса связей
    """
    
    def __init__(self, weight: float = 0.5, **kwargs):
        """
        Args:
            weight: Вес собственного значения (0-1)
        """
        super().__init__(**kwargs)
        self.weight = weight
    
    def update(self, agent_id: str, current_value: np.ndarray,
               neighbor_values: Dict[str, np.ndarray]) -> np.ndarray:
        """
        Обновление значения методом усреднения
        """
        if not neighbor_values:
            return current_value
        
        # Взвешенная сумма
        n_neighbors = len(neighbor_values)
        neighbor_weight = (1 - self.weight) / n_neighbors if n_neighbors > 0 else 0
        
        new_value = self.weight * current_value
        for neighbor_value in neighbor_values.values():
            new_value += neighbor_weight * neighbor_value
        
        return new_value
    
    def compute_laplacian_matrix(self, graph: nx.Graph) -> np.ndarray:
        """
        Вычисление матрицы Лапласа для графа связей
        
        Args:
            graph: Граф связей между агентами
            
        Returns:
            Матрица Лапласа
        """
        return nx.laplacian_matrix(graph).toarray()
    
    def predict_convergence_rate(self, graph: nx.Graph) -> float:
        """
        Предсказание скорости сходимости на основе спектра графа
        
        Args:
            graph: Граф связей
            
        Returns:
            Оценка скорости сходимости (0-1, где 1 - мгновенная)
        """
        if not nx.is_connected(graph):
            return 0.0
        
        # Вычисление собственных значений матрицы Лапласа
        laplacian = self.compute_laplacian_matrix(graph)
        eigenvalues = np.linalg.eigvalsh(laplacian)
        
        # Второе наименьшее собственное значение (алгебраическая связность)
        eigenvalues.sort()
        if len(eigenvalues) > 1:
            algebraic_connectivity = eigenvalues[1]
            # Нормализация (чем больше, тем быстрее сходимость)
            return min(1.0, algebraic_connectivity / len(graph.nodes()))
        
        return 1.0


class WeightedConsensus(ConsensusAlgorithm):
    """
    Взвешенный консенсус с адаптивными весами
    
    Веса связей адаптируются на основе качества связи,
    расстояния или других метрик.
    """
    
    def __init__(self, weight_function: Optional[Callable] = None, **kwargs):
        """
        Args:
            weight_function: Функция для вычисления весов
        """
        super().__init__(**kwargs)
        self.weight_function = weight_function or self._default_weight
    
    def _default_weight(self, agent1_id: str, agent2_id: str,
                       distance: float = None) -> float:
        """
        Веса по умолчанию на основе расстояния
        """
        if distance is None:
            return 0.5
        
        # Экспоненциальное убывание с расстоянием
        max_range = 100.0  # м
        if distance > max_range:
            return 0.0
        return np.exp(-distance / 20.0)  # Характерная длина 20м
    
    def update(self, agent_id: str, current_value: np.ndarray,
               neighbor_values: Dict[str, np.ndarray],
               distances: Dict[str, float] = None) -> np.ndarray:
        """
        Обновление с адаптивными весами
        """
        if not neighbor_values:
            return current_value
        
        if distances is None:
            distances = {}
        
        # Вычисление весов
        weights = {}
        total_weight = 0
        for neighbor_id in neighbor_values:
            dist = distances.get(neighbor_id, None)
            weight = self.weight_function(agent_id, neighbor_id, dist)
            weights[neighbor_id] = weight
            total_weight += weight
        
        # Нормализация весов
        if total_weight > 0:
            for neighbor_id in weights:
                weights[neighbor_id] /= (total_weight + 1)  # +1 для собственного веса
        
        # Взвешенное усреднение
        self_weight = 1.0 / (total_weight + 1)
        new_value = self_weight * current_value
        
        for neighbor_id, neighbor_value in neighbor_values.items():
            new_value += weights[neighbor_id] * neighbor_value
        
        return new_value


class MaxConsensus(ConsensusAlgorithm):
    """
    Консенсус по максимуму
    
    Все агенты сходятся к максимальному значению в сети.
    Полезно для синхронизации времени и выбора лидера.
    """
    
    def __init__(self, damping: float = 0.9, **kwargs):
        """
        Args:
            damping: Коэффициент демпфирования (0-1)
        """
        super().__init__(**kwargs)
        self.damping = damping
    
    def update(self, agent_id: str, current_value: float,
               neighbor_values: Dict[str, float]) -> float:
        """
        Обновление значения по максимуму
        """
        if not neighbor_values:
            return current_value
        
        max_neighbor = max(neighbor_values.values())
        max_value = max(current_value, max_neighbor)
        
        # Демпфирование для плавного перехода
        new_value = self.damping * max_value + (1 - self.damping) * current_value
        
        return new_value


class MinConsensus(ConsensusAlgorithm):
    """
    Консенсус по минимуму
    
    Все агенты сходятся к минимальному значению в сети.
    """
    
    def __init__(self, damping: float = 0.9, **kwargs):
        """
        Args:
            damping: Коэффициент демпфирования (0-1)
        """
        super().__init__(**kwargs)
        self.damping = damping
    
    def update(self, agent_id: str, current_value: float,
               neighbor_values: Dict[str, float]) -> float:
        """
        Обновление значения по минимуму
        """
        if not neighbor_values:
            return current_value
        
        min_neighbor = min(neighbor_values.values())
        min_value = min(current_value, min_neighbor)
        
        # Демпфирование для плавного перехода
        new_value = self.damping * min_value + (1 - self.damping) * current_value
        
        return new_value


class LeaderFollowerConsensus(ConsensusAlgorithm):
    """
    Консенсус типа лидер-ведомый
    
    Лидер задает целевое значение, остальные агенты следуют за ним
    через цепочку связей.
    """
    
    def __init__(self, leader_id: str, tracking_gain: float = 0.8, **kwargs):
        """
        Args:
            leader_id: ID агента-лидера
            tracking_gain: Коэффициент отслеживания (0-1)
        """
        super().__init__(**kwargs)
        self.leader_id = leader_id
        self.tracking_gain = tracking_gain
    
    def update(self, agent_id: str, current_value: np.ndarray,
               neighbor_values: Dict[str, np.ndarray],
               leader_value: Optional[np.ndarray] = None) -> np.ndarray:
        """
        Обновление значения с учетом лидера
        """
        if agent_id == self.leader_id:
            # Лидер не меняет свое значение
            return current_value
        
        # Проверка прямой связи с лидером
        if self.leader_id in neighbor_values:
            # Прямое следование за лидером
            target = neighbor_values[self.leader_id]
        elif leader_value is not None:
            # Использование переданного значения лидера
            target = leader_value
        elif neighbor_values:
            # Следование за средним значением соседей
            target = np.mean(list(neighbor_values.values()), axis=0)
        else:
            return current_value
        
        # Отслеживание с заданным коэффициентом
        new_value = current_value + self.tracking_gain * (target - current_value)
        
        return new_value
    
    def compute_influence_matrix(self, graph: nx.Graph) -> np.ndarray:
        """
        Вычисление матрицы влияния лидера на каждого агента
        
        Args:
            graph: Граф связей
            
        Returns:
            Матрица влияния
        """
        n = len(graph.nodes())
        influence = np.zeros((n, n))
        
        # Индексы узлов
        node_to_idx = {node: i for i, node in enumerate(graph.nodes())}
        
        if self.leader_id not in node_to_idx:
            return influence
        
        leader_idx = node_to_idx[self.leader_id]
        
        # Вычисление кратчайших путей от лидера
        if self.leader_id in graph:
            paths = nx.single_source_shortest_path_length(graph, self.leader_id)
            
            for node, distance in paths.items():
                if node in node_to_idx:
                    idx = node_to_idx[node]
                    # Влияние убывает с расстоянием
                    influence[leader_idx, idx] = 1.0 / (1.0 + distance)
        
        return influence


class FormationConsensus(ConsensusAlgorithm):
    """
    Консенсус для поддержания формации
    
    Агенты согласовывают свои позиции для поддержания
    заданной геометрической формации.
    """
    
    def __init__(self, formation_vectors: Dict[str, np.ndarray], 
                 stiffness: float = 2.0, **kwargs):
        """
        Args:
            formation_vectors: Желаемые относительные позиции {agent_id: vector}
            stiffness: Жесткость формации
        """
        super().__init__(**kwargs)
        self.formation_vectors = formation_vectors
        self.stiffness = stiffness
    
    def update(self, agent_id: str, current_position: np.ndarray,
               neighbor_positions: Dict[str, np.ndarray]) -> np.ndarray:
        """
        Обновление позиции для поддержания формации
        """
        if agent_id not in self.formation_vectors:
            return current_position
        
        desired_offset = self.formation_vectors[agent_id]
        correction = np.zeros_like(current_position)
        
        for neighbor_id, neighbor_pos in neighbor_positions.items():
            if neighbor_id in self.formation_vectors:
                # Желаемое относительное положение
                desired_relative = desired_offset - self.formation_vectors[neighbor_id]
                # Текущее относительное положение
                current_relative = current_position - neighbor_pos
                # Ошибка
                error = desired_relative - current_relative
                # Коррекция
                correction += self.stiffness * error
        
        # Усреднение коррекции
        if neighbor_positions:
            correction /= len(neighbor_positions)
        
        # Применение коррекции
        new_position = current_position + correction * 0.1  # Малый шаг
        
        return new_position