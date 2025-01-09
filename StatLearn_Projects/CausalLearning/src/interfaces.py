# Other modules

from abc import ABC, abstractmethod
from enum import Enum

# Enums

DMLType = Enum("DMLType",["LinearDML","ForestDML","NonParamDML","KernelDML"])

# TODO: Hacer enums todos (para parámetros, aunque no se use en estimador)

# ML Estimators

class IEconMLEstimator(ABC):

    @abstractmethod
    def __init__(self, **kwargs):
        pass

    @abstractmethod
    def set_params(self, **kwargs):
        pass

    @abstractmethod
    def fit(self, **kwargs):
        pass

# Parameter Setter

class IEconMLParameters(ABC):

    @abstractmethod
    def __init__(self,**kwargs):
        pass

    @abstractmethod
    def get_params(self,**kwargs):
        pass

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