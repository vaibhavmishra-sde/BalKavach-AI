from flask import Blueprint, request, jsonify
from backend.services.ai_service import analyze_toxicity, analyze_image
from backend.services.firestore_service import save_activity_log
from backend.utils.logger import configure_logger
from datetime import datetime

logger = configure_logger()
ai_bp = Blueprint('ai', __name__, url_prefix='/api/ai')


@ai_bp.route('/toxicity', methods=['POST'])
def toxicity():
    payload = request.json or {}
    text = payload.get('text', '')
    if not text:
        return jsonify({'error': 'text is required for toxicity analysis'}), 400

    try:
        result = analyze_toxicity(text)
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
def image():
    if 'image' not in request.files:
        return jsonify({'error': 'image file is required'}), 400

    image_file = request.files['image']
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
