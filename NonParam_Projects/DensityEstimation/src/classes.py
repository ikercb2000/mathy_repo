# Project Modules

from interfaces import *
from utils import *

# Other Modules

import matplotlib.pyplot as plt
import numpy as np

# Class definition

class KernelDensityEstimator:

    def __init__(self, kde_type: KernelType):

        self.kde_type = kde_type

    def __str__(self):
        return "Density Estimator"
        
    def get_densities(self, eval_points: np.ndarray, support: np.ndarray, bw: float):

        self.support = support
        self.densities = kde_density(eval_points=eval_points,support=support,bw=bw,kernel=self.kde_type)
        self.variances = kde_variance(eval_points=eval_points,support=support,bw=bw,kernel=self.kde_type,densities=self.densities)
        
        return {"densities": self.densities,
                "variances": self.variances,
                "support": self.support}

    def get_conf_bands(self, eval_points: np.ndarray, support: np.ndarray, bw: float, alpha: float = 0.05):

        bootstrap_sample = np.random.choice(eval_points, size=eval_points.shape[0], replace=True)
        dens_bootstrap = kde_density(eval_points=bootstrap_sample,support=support,bw=bw,kernel=self.kde_type)
        var_bootstrap = kde_var_bootstrap(eval_points=bootstrap_sample,support=support,bw=bw,kernel=self.kde_type,densities=dens_bootstrap)
        var_bootstrap = np.maximum(var_bootstrap,1e-10)
        sigma = np.sqrt(var_bootstrap) 
        t = (dens_bootstrap-self.densities)/sigma
        upper_limit = self.densities - sigma * np.percentile(np.sort(t),(alpha/2)*100)
        lower_limit = self.densities - sigma * np.percentile(np.sort(t),(1-alpha/2)*100)

        self.up_conf = upper_limit
        self.low_conf = lower_limit

        return upper_limit, lower_limit
    
    def plot_results(self, true_density: np.ndarray = None):

        plt.plot(self.support, self.densities, label="Estimated Kernel Density")
        plt.fill_between(self.support, list(self.low_conf), list(self.up_conf), color="gray", alpha=0.3, label="95% Confidence Band")
        
        if true_density is not None:
            plt.plot(self.support, true_density, label="True Density")
        
        plt.title("Density Estimate with Confidence Bands")
        plt.xlabel("x")
        plt.ylabel("Density")
        plt.legend()
        plt.show()
