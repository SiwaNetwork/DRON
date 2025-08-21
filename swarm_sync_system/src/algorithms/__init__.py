"""
Алгоритмы для роевой системы
"""
from .consensus import (
    AverageConsensus,
    WeightedConsensus,
    MaxConsensus,
    MinConsensus,
    LeaderFollowerConsensus
)
from .synchronization import (
    TimeSynchronization,
    ClockSync,
    PhaseSync
)

__all__ = [
    'AverageConsensus',
    'WeightedConsensus',
    'MaxConsensus',
    'MinConsensus',
    'LeaderFollowerConsensus',
    'TimeSynchronization',
    'ClockSync',
    'PhaseSync'
]