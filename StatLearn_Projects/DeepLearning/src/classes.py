# Project Modules

from interfaces import *

# Other Modules

import keras

# Classes


class NeuralNetworkHandler(INeuralNetworkHandler):

    def __init__(self, model: keras.Model):

        self.model = model

    def __str__(self, **kwargs):
        return super().__str__(**kwargs)

    def nn_compile(
        self,
        optimizer: keras.optimizers,
        loss: keras.Loss,
        metrics: list,
        n_batches: int,
    ):

        self.model.compile(
            optimizer=optimizer,
            loss=loss,
            metrics=metrics,
            steps_per_execution=n_batches,
        )

    def nn_train(
        self,
        train_x,
        train_y,
        batch_size: int,
        epochs: int,
        callback: keras.callbacks,
        shuffle: bool,
        y_weights: dict,
        x_weights,
    ):

        self.model.fit(
            x=train_x,
            y=train_y,
            batch_size=batch_size,
            epochs=epochs,
            callbacks=callback,
            shuffle=shuffle,
            class_weight=y_weights,
            sample_weight=x_weights,
        )

    def nn_evaluate(
        self,
        train_x,
        train_y,
        batch_size: int,
        x_weights,
        callbacks: keras.callbacks,
    ):

        return self.model.evaluate(
            x=train_x,
            y=train_y,
            batch_size=batch_size,
            sample_weight=x_weights,
            callbacks=callbacks,
            return_dict=True,
        )

    def nn_predict(self, test_x, batch_size: int, callbacks: keras.callbacks):

        self.model.predict(
            x=test_x,
            batch_size=batch_size,
            callbacks=callbacks,
        )
