# Other modules

import numpy as np

import tensorflow as tf
from typing import Union

# Tensor creation

def vector_to_tensor(vector: Union[list, np.ndarray]):

    return tf.constant(vector)


def matrix_to_tensor(matrix: np.ndarray):

    return tf.constant(matrix)


def list_matrix_to_tensor(list_mat: list):

    return tf.constant(list_mat)

def tensor_to_array(tensor: tf.Tensor):

    return tensor.