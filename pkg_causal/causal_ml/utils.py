# Method of estimator

# Propensity Score Matching: "backdoor.propensity_score_matching"
# Propensity Score Stratification: "backdoor.propensity_score_stratification"
# Propensity Score-based Inverse Weighting: "backdoor.propensity_score_weighting"
# Linear Regression: "backdoor.linear_regression"
# Generalized Linear Models (e.g., logistic regression): "backdoor.generalized_linear_model"
# Instrumental Variables: "iv.instrumental_variable"
# Regression Discontinuity: "iv.regression_discontinuity"
# Two Stage Regression: "frontdoor.two_stage_regression

# Method of refuter

# Adding a randomly-generated confounder: "random_common_cause"
# Adding a confounder that is associated with both treatment and outcome: "add_unobserved_common_cause"
# Replacing the treatment with a placebo (random) variable): "placebo_treatment_refuter"
# Removing a random subset of the data: "data_subset_refuter"