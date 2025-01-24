# Project Modules

from .classes import *

# Other modules

import warnings

# Parameters

data = pd.DataFrame(
    {
        "treatment": [
            1,
            0,
            1,
            0,
            1,
            0,
            1,
            0,
            1,
            0,
            1,
            0,
            1,
            0,
            1,
            0,
            1,
            0,
            1,
            0,
            1,
            0,
            1,
            0,
            1,
            0,
            1,
            0,
            1,
            0,
        ],
        "outcome": [
            10,
            7,
            15,
            5,
            20,
            7,
            12,
            6,
            18,
            8,
            11,
            9,
            13,
            7,
            19,
            8,
            21,
            6,
            14,
            10,
            22,
            5,
            16,
            9,
            24,
            6,
            25,
            10,
            20,
            7,
        ],
        "age": [
            25,
            30,
            45,
            35,
            50,
            28,
            38,
            42,
            34,
            29,
            32,
            37,
            43,
            31,
            36,
            41,
            39,
            33,
            48,
            27,
            40,
            28,
            46,
            31,
            47,
            30,
            50,
            35,
            44,
            26,
        ],
        "gender": ["Male", "Female"] * 15,
        "income": [
            50000,
            40000,
            60000,
            30000,
            80000,
            45000,
            55000,
            35000,
            70000,
            38000,
            52000,
            42000,
            58000,
            36000,
            75000,
            47000,
            60000,
            39000,
            71000,
            40000,
            81000,
            41000,
            73000,
            45000,
            85000,
            46000,
            62000,
            43000,
            79000,
            48000,
        ],
    }
)

treatment = "treatment"
outcome = "outcome"
effect_method = "backdoor.linear_regression"
refuter_method = "placebo_treatment_refuter"
common_causes = ["age", "gender", "income"]

# Create and execute pipeline

warnings.filterwarnings("ignore")

pipeline = CausalPipeline(
    data, treatment, outcome, effect_method, refuter_method, common_causes
)
estimate, refutation = pipeline.run()

#TODO: Make Enums to choose effect_method in DoWhy and estimator in EconML
#TODO: Make Enums to choose refuter method
#TODO: Make logic to show the attributes via website if there are none or establish dictionary