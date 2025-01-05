# Other modules

from abc import ABC, abstractmethod

# Interface


class IKernelEstimator(ABC):

    def __init__(self, **kwargs):
        pass

    @abstractmethod
    def __str__(self):
        pass

    @abstractmethod
    def get_densities(self, **kwargs):
        pass

    @abstractmethod
    def plot_results(self, **kwargs):
        pass
