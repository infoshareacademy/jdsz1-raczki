import keras.utils as np_utils
from keras.callbacks import ModelCheckpoint, EarlyStopping, TensorBoard
from keras.models import Sequential
from keras.layers import Dense, Dropout, Flatten, regularizers
from keras.layers import Conv2D, MaxPooling2D, BatchNormalization, Activation
import numpy as np
import cv2
import os

from keras.utils import to_categorical

from Generator import DataGenerator

#FILE = r"dresses\\train\\labels.txt"
#FILE_VAL = r"dresses\\val\\labels.txt"
#FILE_TEST = r"dresses\\test\\labels.txt"

FILE = r"dresses/train/labels.txt"
FILE_VAL = r"dresses/val/labels.txt"

def create_images_labels(filename):
    images = []
    labels = []

    with open(filename) as f:
        lines = f.read().splitlines()

    for line in lines:
        temp = line.split()
        path = temp[0]
        images.append(path)
        string_label = temp[1:]
        label = list(map(int, string_label))
        label = np.array(label)
        labels.append(label)

    labels_dictionary = dict()
    for img_id, label_val in zip(images, labels):
        labels_dictionary.update({img_id: label_val})

    return images, labels_dictionary

def show(images, labels):
    for i in range(0, 100):
        cv2.imshow('img', images[i])
        print(labels[i])
        cv2.waitKey()

def create_models():
    model = Sequential()
    model.add(Conv2D(16, (3, 3), input_shape=(244, 244, 3)))
    model.add(BatchNormalization())
    model.add(Activation('relu'))
    model.add(Conv2D(16, (3, 3)))
    model.add(MaxPooling2D())
    model.add(Conv2D(32, (3,3)))
    model.add(BatchNormalization())
    model.add(Activation('relu'))
    model.add(Conv2D(32, (3, 3)))
    model.add(BatchNormalization())
    model.add(Activation('relu'))
    model.add(MaxPooling2D())
    model.add(Flatten())
    model.add(Dense(128, kernel_regularizer=regularizers.l2(0.01)))
    model.add(BatchNormalization())
    model.add(Activation('relu'))
    model.add(Dense(14, activation='softmax'))
    model.compile(optimizer="adam", loss="categorical_crossentropy", metrics=['categorical_accuracy'])
    #model.load_weights("model.hdf5")

    return model

def main():
    images, labels = create_images_labels(FILE)
    images_val, labels_val = create_images_labels(FILE_VAL)
    generator = DataGenerator(images, FILE, labels, batch_size=4, dim=(244,244), n_channels=3)
    generator_val = DataGenerator(images_val, FILE_VAL, labels_val, batch_size=8, dim=(244,244), n_channels=3)

    #show(images, labels)
    model = create_models()
    callback = ModelCheckpoint(filepath=r"./model.hdf5", save_best_only=True, verbose=1)
    early_stop = EarlyStopping(monitor='val_loss', patience=2, verbose=1)
    tensorboard = TensorBoard()
    model.summary()
    model.fit_generator(generator=generator,
                        validation_data=generator_val,
                        epochs=10,
                        verbose=1,
                        callbacks=[callback, early_stop, tensorboard],
                        use_multiprocessing=False)

    #metrics = model.evaluate(images_test, labels_test, batch_size=10, verbose=1)
    #print(metrics)

if __name__ == '__main__':
    main()