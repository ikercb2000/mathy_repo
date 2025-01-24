# Project Modules

from .interfaces import *

# Other Modules

import numpy as np
from enum import Enum

# Univariate Kernels

def gaussian_kernel(u: float):
    return np.exp(-0.5*(u**2))/np.sqrt(2*np.pi)

def epanechnikov_kernel(u: float):
    if abs(u) <= 1:
        return 0.75*(1-u**2)
    else:
        return 0
    
def boxcar_kernel(u: float):
    if abs(u) <= 1:
        return 0.5
    else:
        return 0
    
def triangular_kernel(u: float):
    if abs(u) <= 1:
        return 1 - np.abs(u)
    else:
        return 0
    
def tricube_kernel(u: float):
    if abs(u) <= 1:
        return (70/81)*(1-np.abs(u)**3)**3
    else:
        return 0
    
def quartic_kernel(u: float):
    if abs(u) <= 1:
        return (15/16)*(1-u**2)**2
    else:
        return 0
    
def triweight_kernel(u: float):
    if abs(u) <= 1:
        return (35/32)*(1-u**2)**3
    else:
        return 0
    
# Multivariate Kernels
    
def sigmoid_kernel(u1: np.ndarray, u2: np.ndarray, alpha: float = 1.0, c: float = 0.0):
    return np.tanh(alpha*np.dot(u1,u2)+c)

def rbf_kernel(u1: np.ndarray, u2: np.ndarray, sigma: float = 1.0):
    return np.exp(-np.linalg.norm(u1-u2, ord=2)**2 / (2*(sigma**2)))

def laplace_kernel(u1: np.ndarray, u2: np.ndarray, sigma: float = 1.0):
    return np.exp(-np.linalg.norm(u1-u2, ord=1) / sigma)

def polynomial_kernel(u1: np.ndarray, u2: np.ndarray, degree: int = 2, c: float = 1.0):
    return (np.dot(u1, u2) + c)**degree

def cosine_similarity_kernel(x1: np.ndarray, x2: np.ndarray):
    return np.dot(x1, x2) / (np.linalg.norm(x1, ord=2) * np.linalg.norm(x2, ord=2))

# Auxiliary Functions

class KernelType(Enum):

    GAUSSIAN = gaussian_kernel
    EPANECHNIKOV = epanechnikov_kernel
    BOXCAR = boxcar_kernel
    TRICUBE = tricube_kernel
    TRIANGULAR = triangular_kernel
    QUARTIC = quartic_kernel
    TRIWEIGHT = triweight_kernel

def kde_density(eval_points: np.ndarray, support: np.ndarray, bw: float, kernel: KernelType):

    n = eval_points.shape[0]
    densities = []
    kernel_function = kernel

    for x in support:
        kernel_values = [kernel_function((x - xi)/bw) for xi in eval_points]
        density = np.sum(kernel_values) / (n*bw)
        densities.append(density)

    return np.array(densities)

def kde_variance(eval_points: np.ndarray, support: np.ndarray, bw: float, kernel: KernelType, densities: np.ndarray):

    n = eval_points.shape[0]
    variances = []
    kernel_function = kernel

    for i, x in enumerate(support):

        kernel_values_2 = [kernel_function((x - xi)/bw)**2 for xi in eval_points]
        variance = (np.sum(kernel_values_2) / (n*bw)**2) - densities[i]**2/n
        variances.append(variance)

    return np.array(variances)

def kde_var_bootstrap(eval_points: np.ndarray, support: np.ndarray, bw: float, kernel: KernelType, densities: np.ndarray):

    n = eval_points.shape[0]
    variances = []
    kernel_function = kernel

    for i, x in enumerate(support):

        kernel_values_2 = [kernel_function((x - xi)/bw)**2 for xi in eval_points]
        variance = (np.sum(kernel_values_2) / n*(bw**2)) - densities[i]**2/n
        variances.append(variance)

    return np.array(variances)

