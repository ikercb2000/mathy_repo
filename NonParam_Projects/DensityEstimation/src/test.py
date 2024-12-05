import numpy as np
import matplotlib.pyplot as plt
from classes import KernelDensityEstimator, KernelType
from scipy.stats import t

# Generate data from a t-distribution (true density)
np.random.seed(42)
degrees_of_freedom = 5
n_samples = 500
data = np.random.standard_t(degrees_of_freedom, n_samples)

# Define support (x-axis for density estimation)
support = np.linspace(-5, 5, 200)

# Bandwidth for kernel density estimation
bandwidth = 0.6

# True Density
true_density = t.pdf(support, degrees_of_freedom)

# Kernels to test
kernels = [
    KernelType.GAUSSIAN,
    KernelType.EPANECHNIKOV,
    KernelType.BOXCAR,
    KernelType.TRIANGULAR,
    KernelType.QUARTIC,
    KernelType.TRICUBE,
    KernelType.TRIWEIGHT,
]

for kernel in kernels:
    kde = KernelDensityEstimator(kernel)
    result = kde.get_densities(eval_points=data, support=support, bw=bandwidth)
    upper_band, lower_band = kde.get_conf_bands(eval_points=data, support=support, bw=bandwidth)
    densities = result["densities"]
    kde.plot_results(true_density=true_density)