import os
from typing import Dict

MODEL_PATH = os.getenv('IMAGE_MODEL_PATH', 'ai_models/image_detection/cnn_image_detector.h5')


def import_pipeline():
    try:
        from transformers import pipeline
        return pipeline
    except Exception:
        return None


def import_tf():
    try:
        import tensorflow as tf
        from tensorflow.keras.models import load_model
        from tensorflow.keras.preprocessing import image as keras_image
        return tf, load_model, keras_image
    except Exception:
        return None, None, None


def get_toxicity_pipeline():
    pipeline = import_pipeline()
    if pipeline is None:
        raise RuntimeError('Transformers pipeline is unavailable. Install transformers and compatible dependencies.')

    try:
        return pipeline(
            'text-classification',
            model='unitary/toxic-bert',
            framework='tf',
            return_all_scores=True,
        )
    except Exception:
        return pipeline(
            'text-classification',
            model='unitary/toxic-bert',
            return_all_scores=True,
        )


def analyze_toxicity(text: str) -> Dict:
    classifier = get_toxicity_pipeline()
    results = classifier(text)
    if not results or not results[0]:
        return {'text': text, 'toxicity_percentage': 0.0, 'labels': {}}
    scores = {item['label']: float(item['score']) for item in results[0]}
    toxicity_score = scores.get('toxic', scores.get('TOXIC', 0.0))
    return {
        'text': text,
        'toxicity_percentage': round(toxicity_score * 100, 2),
        'labels': scores,
    }


def load_image_model():
    tf, load_model, _ = import_tf()
    if tf is None:
        return None
    if os.path.exists(MODEL_PATH):
        return load_model(MODEL_PATH)
    return None


def analyze_image(image_file) -> Dict:
    tf, _, keras_image = import_tf()
    if tf is None or keras_image is None:
        return {
            'unsafe_probability': 0.0,
            'label': 'unknown',
            'message': 'TensorFlow is unavailable. Image analysis cannot run.',
        }

    img = keras_image.load_img(image_file, target_size=(128, 128))
    img_array = keras_image.img_to_array(img) / 255.0
    img_batch = img_array.reshape((1, 128, 128, 3))
    model = load_image_model()
    if model is None:
        return {
            'unsafe_probability': 0.1,
            'label': 'safe',
            'message': 'Image model not trained - using default safety fallback.',
        }
    prediction = model.predict(img_batch)
    unsafe_probability = float(prediction[0][0])
    label = 'unsafe' if unsafe_probability > 0.5 else 'safe'
    return {
        'unsafe_probability': round(unsafe_probability * 100, 2),
        'label': label,
    }
