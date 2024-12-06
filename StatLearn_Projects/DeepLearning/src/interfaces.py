# Other Modules

from abc import ABC, abstractmethod

# Interface Neural Networks


class INeuralNetwork(ABC):

    @abstractmethod
    def __str__(self, **kwargs):
        pass
