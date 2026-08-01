from typing import Dict
from tensorflow.keras.models import load_model

_model = None


def load_image_model(path: str = "models/image_cnn.h5"):
    global _model
    if _model is None:
        # Placeholder: load a pre-trained Keras CNN for harmful image detection
        _model = load_model(path)
    return _model


def analyze_image(image_array) -> Dict:
    # image_array is expected to be a preprocessed numpy array
    model = load_image_model()
    preds = model.predict(image_array)
    # Interpret preds per your output format
    return {"predictions": preds.tolist(), "confidence": float(preds.max())}
