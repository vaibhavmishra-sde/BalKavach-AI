import os
import re
from functools import lru_cache
from typing import Dict

MODEL_PATH = os.getenv('IMAGE_MODEL_PATH', 'ai_models/image_detection/cnn_image_detector.h5')

# Remote Hugging Face models are opt-in because the first download can take
# minutes and should never make a safety check appear to hang.
USE_REMOTE_TOXICITY_MODEL = os.getenv('USE_REMOTE_TOXICITY_MODEL', 'false').lower() == 'true'

_HARMFUL_PATTERNS = (
    r'\b(kill|hurt|attack|stab|bomb|weapon|suicide|self[- ]?harm)\b',
    r'\b(nude|nudes|sexual|sex|porn)\b',
    r'\b(i will|gonna)\s+(kill|hurt|attack)\b',
)
_SPAM_PATTERNS = (
    r'https?://',
    r'\b(click here|free money|you won|urgent|limited offer|claim now)\b',
    r'\b(otp|password|bank details|gift card|crypto)\b',
)


def _classify_with_rules(text: str) -> Dict:
    normalized = text.lower().strip()
    harmful_matches = [pattern for pattern in _HARMFUL_PATTERNS if re.search(pattern, normalized)]
    spam_matches = [pattern for pattern in _SPAM_PATTERNS if re.search(pattern, normalized)]

    if harmful_matches:
        classification, score, message = (
            'harmful', 85.0,
            'Potentially harmful or age-inappropriate content detected. Review this message with a guardian.',
        )
    elif spam_matches:
        classification, score, message = (
            'spam', 72.0,
            'Possible spam or phishing content detected. Do not open links or share personal information.',
        )
    else:
        classification, score, message = ('safe', 4.0, 'No harmful or spam indicators were detected.')

    return {
        'text': text,
        'classification': classification,
        'is_suspicious': classification != 'safe',
        'should_alert': classification != 'safe',
        'alert_message': message,
        'toxicity_percentage': score,
        'labels': {classification: round(score / 100, 2)},
        'analysis_source': 'local safety rules',
    }


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


@lru_cache(maxsize=1)
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
    if not USE_REMOTE_TOXICITY_MODEL:
        return _classify_with_rules(text)

    classifier = get_toxicity_pipeline()
    results = classifier(text)
    if not results or not results[0]:
        return {'text': text, 'toxicity_percentage': 0.0, 'labels': {}}
    scores = {item['label']: float(item['score']) for item in results[0]}
    toxicity_score = scores.get('toxic', scores.get('TOXIC', 0.0))
    result = {
        'text': text,
        'classification': 'harmful' if toxicity_score >= 0.5 else 'safe',
        'is_suspicious': toxicity_score >= 0.5,
        'should_alert': toxicity_score >= 0.5,
        'alert_message': 'Potentially harmful content detected. Review this message with a guardian.' if toxicity_score >= 0.5 else 'No harmful content detected.',
        'toxicity_percentage': round(toxicity_score * 100, 2),
        'labels': scores,
        'analysis_source': 'remote toxicity model',
    }
    return result


@lru_cache(maxsize=1)
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


def analyze_behavior(messages: list) -> Dict:
    if not messages:
        return {'behavior_risk': 0.0, 'pattern_detected': False, 'messages_analyzed': 0, 'recommendations': 'Not enough data.', 'alert_level': 'low'}
    
    toxic_count = 0
    for msg in messages:
        res = _classify_with_rules(msg)
        if res['classification'] != 'safe':
            toxic_count += 1
            
    risk_score = min(100.0, (toxic_count / len(messages)) * 100.0 * 2.0)
    pattern_detected = risk_score > 30.0
    
    alert_level = 'high' if risk_score > 60 else ('medium' if risk_score > 30 else 'low')
    recs = 'Monitor closely' if pattern_detected else 'No immediate action required'
    if risk_score > 60:
        recs = 'Immediate intervention recommended'
        
    return {
        'behavior_risk': risk_score,
        'pattern_detected': pattern_detected,
        'messages_analyzed': len(messages),
        'recommendations': recs,
        'alert_level': alert_level
    }


def detect_anomaly(activity_data: Dict) -> Dict:
    messages_per_hour = float(activity_data.get('messages_per_hour', 0))
    time_online_hours = float(activity_data.get('time_online_hours', 0))
    unique_contacts = float(activity_data.get('unique_contacts', 0))
    late_night_activity = float(activity_data.get('late_night_activity', 0))
    
    anomaly_score = 0.0
    if messages_per_hour > 50:
        anomaly_score += 30
    if time_online_hours > 6:
        anomaly_score += 30
    if unique_contacts > 20:
        anomaly_score += 20
    if late_night_activity > 2:
        anomaly_score += 20
        
    anomaly_score = min(100.0, anomaly_score)
    is_anomaly = anomaly_score > 40
    alert_level = 'high' if anomaly_score > 60 else ('medium' if anomaly_score > 30 else 'low')
    
    return {
        'anomaly_score': anomaly_score / 100.0,
        'is_anomaly': is_anomaly,
        'confidence': 0.85,
        'description': 'Unusual activity detected based on usage patterns.' if is_anomaly else 'Normal activity pattern.',
        'alert_level': alert_level
    }
