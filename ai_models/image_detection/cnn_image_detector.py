import os
import tensorflow as tf
from tensorflow.keras import layers, models

MODEL_PATH = os.path.join(os.path.dirname(__file__), 'cnn_image_detector.h5')


def build_model():
    model = models.Sequential([
        layers.Input(shape=(128, 128, 3)),
        layers.Conv2D(32, (3, 3), activation='relu'),
        layers.MaxPooling2D((2, 2)),
        layers.Conv2D(64, (3, 3), activation='relu'),
        layers.MaxPooling2D((2, 2)),
        layers.Conv2D(128, (3, 3), activation='relu'),
        layers.MaxPooling2D((2, 2)),
        layers.Flatten(),
        layers.Dropout(0.4),
        layers.Dense(64, activation='relu'),
        layers.Dense(1, activation='sigmoid'),
    ])
    model.compile(optimizer='adam', loss='binary_crossentropy', metrics=['accuracy'])
    return model


def load_trained_model():
    if os.path.exists(MODEL_PATH):
        return tf.keras.models.load_model(MODEL_PATH)
    return build_model()


def save_model(model):
    model.save(MODEL_PATH)


if __name__ == '__main__':
    model = build_model()
    model.summary()
    save_model(model)
    print('Saved default CNN image detector to', MODEL_PATH)
