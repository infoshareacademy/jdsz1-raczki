import cv2
import os
import numpy as np
import keras

class DataGenerator(keras.utils.Sequence):

    def __init__(self, list_IDs, filename, labels, batch_size=32, dim=(32, 32, 32), n_channels=1,
                 n_classes=10, shuffle=True):
        self.dim = dim
        self.batch_size = batch_size
        self.labels = labels
        self.filename = filename
        self.n_channels = n_channels
        self.n_classes = n_classes
        self.shuffle = shuffle
        self.list_IDs = list_IDs
        self.on_epoch_end()

    def __data_generation(self, list_IDs_temp):
        X = np.empty((self.batch_size, *self.dim, self.n_channels))
        y = np.empty((self.batch_size), dtype=object)

        for i, ID in enumerate(list_IDs_temp):
            img = cv2.imread(os.path.join(os.path.dirname(self.filename), ID))
            img = cv2.resize(img, (244, 244), interpolation=cv2.INTER_AREA)
            X[i,] = img
            y[i] = self.labels[ID]

        return X, np.matrix(list(y))

    def on_epoch_end(self):
        self.indexes = np.arange(len(self.list_IDs))
        if self.shuffle == True:
            np.random.shuffle(self.indexes)

    def __len__(self):
        return int(np.floor(len(self.list_IDs) / self.batch_size))

    def __getitem__(self, index):
        indexes = self.indexes[index * self.batch_size:(index + 1) * self.batch_size]
        list_IDs_temp = [self.list_IDs[k] for k in indexes]
        X, y = self.__data_generation(list_IDs_temp)
        return X, y