# Project modules

from interfaces import *

# Other modules

from dowhy import CausalModel
from dowhy.causal_estimator import CausalEstimate
from econml.dml import LinearDML, CausalForestDML
from econml.dr import DRLearner
import pandas as pd

# ML Model Classes


class LinearDMLEstimator(IEconMLEstimator):

    def get_params(self):

        method_params = {}
        method_params["init_params"] = {
            "model_y": "auto",
            "model_t": "auto",
        }
        method_params["econml_estimator"] = LinearDML

        return method_params


class CausalForestDMLEstimator(IEconMLEstimator):

    def get_params(self):

        method_params = {}
        method_params["init_params"] = {}
        method_params["econml_estimator"] = CausalForestDML

        return method_params


class OrthoForestEstimator(IEconMLEstimator):

    def get_params(self):

        method_params = {}
        method_params["init_params"] = {
            "model_y": "auto",
            "model_t": "auto",
        }
        method_params["econml_estimator"] = LinearDML

        return method_params


class DRLearnerEstimator(IEconMLEstimator):

    def get_params(self):

        method_params = {}
        method_params["init_params"] = {}
        method_params["econml_estimator"] = DRLearner

        return method_params


# Model Builder Class


class CausalModelBuilder(ICausalModelBuilder):

    def __init__(
        self,
        data: pd.DataFrame,
        treatment: str,
        outcome: str,
        common_causes: list = None,
    ):
        self.data = data
        self.treatment = treatment
        self.outcome = outcome
        self.common_causes = common_causes
        self.identif_estimand = None

    def builder(self):
        model = CausalModel(
            data=self.data,
            treatment=self.treatment,
            outcome=self.outcome,
            common_causes=self.common_causes,
        )

        return model

    def estimator(self, model: CausalModel, method: str = "backdoor.linear_regression"):
        self.identif_estimand = model.identify_effect()
        estimate = model.estimate_effect(
            identified_estimand=self.identif_estimand, method_name=method
        )
        return estimate

    def refuter(
        self,
        model: CausalModel,
        estimate: CausalEstimate,
        method: str = "placebo_treatment_refuter",
    ):
        if not self.identif_estimand:
            raise ValueError("Target estimand is not set. Run the estimator first.")
        refutation = model.refute_estimate(
            estimand=self.identif_estimand,
            estimate=estimate,
            method_name=method,
        )

        return refutation


# Causal Pipeline Class


class CausalPipeline(ICausalPipeline):

    def __init__(
        self,
        data: pd.DataFrame,
        treatment: str,
        outcome: str,
        effect_method: str = "backdoor.linear_regression",
        refuter_method: str = "placebo_treatment_refuter",
        common_causes: list = None,
    ):

        self.data = data
        self.treatment = treatment
        self.outcome = outcome
        self.effect_method = effect_method
        self.refuter_method = refuter_method
        self.common_causes = common_causes

    def run(self):
        print("Constructing causal model...\n")
        model_pipeline = CausalModelBuilder(
            self.data, self.treatment, self.outcome, self.common_causes
        )
        model = model_pipeline.builder()

        print("Estimating the causal effects...\n")
        estimate = model_pipeline.estimator(model=model, method=self.effect_method)
        print(
            f"Estimation Results\n------------------\n Estimated effect: {estimate.value}\n"
        )

        print("Refuting estimation...\n")
        refutation = model_pipeline.refuter(
            model=model, estimate=estimate, method=self.refuter_method
        )
        print(f"Refutation Results\n------------------\n{refutation}")

        return estimate, refutation
