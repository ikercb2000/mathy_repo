# Other Modules

from abc import ABC, abstractmethod

# Interface Data Handler


class IDataHandler(ABC):

    @abstractmethod
    def __str__(self, **kwargs):
        return "Data Handler"

    ...


# Interface Neural Network Handler


class INeuralNetworkHandler(ABC):

    @abstractmethod
    def __str__(self, **kwargs):
        return "Neural Network Handler Class"

    @abstractmethod
    def nn_compile(self, **kwargs):
        pass

    @abstractmethod
    def nn_train(self, **kwargs):
        pass

    @abstractmethod
    def nn_evaluate(self, **kwargs):
        pass

    @abstractmethod
    def nn_predict(self, **kwargs):
        pass
