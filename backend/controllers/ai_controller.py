# pyrefly: ignore [missing-import]
from flask import Blueprint, request, jsonify
from backend.services.ai_service import analyze_toxicity, analyze_image, analyze_behavior, detect_anomaly
from backend.services.firestore_service import save_activity_log, save_alert
from backend.utils.logger import configure_logger
from backend.utils.auth import require_auth
from datetime import datetime

logger = configure_logger()
ai_bp = Blueprint('ai', __name__, url_prefix='/api/ai')


@ai_bp.route('/toxicity', methods=['POST'])
@require_auth()
def toxicity():
    payload = request.json or {}
    text = payload.get('text', '')
    if not isinstance(text, str) or not text.strip():
        return jsonify({'error': 'text is required for toxicity analysis'}), 400
    if len(text) > 5_000:
        return jsonify({'error': 'text must not exceed 5,000 characters'}), 400

    try:
        result = analyze_toxicity(text)
        if result.get('should_alert'):
            save_alert({
                'type': result['classification'],
                'message': result['alert_message'],
                'text': text,
                'timestamp': datetime.utcnow().isoformat(),
            })
        save_activity_log({
            'type': 'toxicity_analysis',
            'text': text,
            'result': result,
            'timestamp': datetime.utcnow().isoformat(),
        })
        return jsonify(result), 200
    except Exception as exc:
        logger.error('Toxicity error: %s', exc)
        return jsonify({'error': str(exc)}), 500


@ai_bp.route('/image', methods=['POST'])
@require_auth()
def image():
    if 'image' not in request.files:
        return jsonify({'error': 'image file is required'}), 400

    image_file = request.files['image']
    if not image_file.filename:
        return jsonify({'error': 'image file is required'}), 400
    try:
        result = analyze_image(image_file)
        save_activity_log({
            'type': 'image_analysis',
            'filename': image_file.filename,
            'result': result,
            'timestamp': datetime.utcnow().isoformat(),
        })
        return jsonify(result), 200
    except Exception as exc:
        logger.error('Image error: %s', exc)
        return jsonify({'error': str(exc)}), 500


@ai_bp.route('/behavior', methods=['POST'])
@require_auth()
def behavior():
    payload = request.json or {}
    messages = payload.get('messages', [])
    if not isinstance(messages, list):
        return jsonify({'error': 'messages must be a list'}), 400
        
    try:
        result = analyze_behavior(messages)
        save_activity_log({
            'type': 'behavior_analysis',
            'messages_count': len(messages),
            'result': result,
            'timestamp': datetime.utcnow().isoformat(),
        })
        return jsonify(result), 200
    except Exception as exc:
        logger.error('Behavior analysis error: %s', exc)
        return jsonify({'error': str(exc)}), 500


@ai_bp.route('/anomaly', methods=['POST'])
@require_auth()
def anomaly():
    payload = request.json or {}
    try:
        result = detect_anomaly(payload)
        if result.get('is_anomaly'):
            save_alert({
                'type': 'anomaly',
                'message': result['description'],
                'timestamp': datetime.utcnow().isoformat(),
            })
        save_activity_log({
            'type': 'anomaly_detection',
            'result': result,
            'timestamp': datetime.utcnow().isoformat(),
        })
        return jsonify(result), 200
    except Exception as exc:
        logger.error('Anomaly detection error: %s', exc)
        return jsonify({'error': str(exc)}), 500
