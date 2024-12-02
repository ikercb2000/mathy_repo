from abc import ABC, abstractmethod
from enum import Enum

# Enums

KernelTypes = Enum("KernelTypes", ["Gaussian", "Epanechikov", "Boxcar", "Tricube"])

# Interface


class IKernelEstimator(ABC):

    def __init__(self, **kwargs):
        pass

    @abstractmethod
    def __str__(self):
        pass

    @abstractmethod
    def get_density(self, **kwargs):
        pass

    @abstractmethod
    def get_conf_bands(self, **kwargs):
        pass
