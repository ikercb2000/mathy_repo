# Other modules

from abc import ABC, abstractmethod

# Model Builder Interface


class ICausalModelBuilder(ABC):

    @abstractmethod
    def __init__(self, data, **kwargs):
        pass

    @abstractmethod
    def builder(self, **kwargs):
        pass

    @abstractmethod
    def estimator(self, **kwargs):
        pass

    @abstractmethod
    def refuter(self, **kwargs):
        pass


# Causal Pipeline Interface


class ICausalPipeline(ABC):

    @abstractmethod
    def __init__(self, data, **kwargs):
        pass

    @abstractmethod
    def run(self):
        pass


# Causal Estimator Interface


class IEconMLEstimator(ABC):

    @abstractmethod
    def __init__(self, **kwargs):
        pass

    @abstractmethod
    def get_params(self, **kwargs):
        pass


# TODO: Integrate sklearn models and other features for optimization and validation.
# See https://econml.azurewebsites.net/spec/estimation.html for examples
