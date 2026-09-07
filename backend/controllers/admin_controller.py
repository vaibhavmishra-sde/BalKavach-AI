from flask import Blueprint, jsonify
from backend.services.firestore_service import get_alerts
from backend.utils.logger import configure_logger
from backend.utils.auth import require_auth

logger = configure_logger()
admin_bp = Blueprint('admin', __name__, url_prefix='/api/admin')


@admin_bp.route('/reports', methods=['GET'])
@require_auth('admin')
def reports():
    try:
        alerts = get_alerts()
        return jsonify({'alerts': alerts}), 200
    except Exception as exc:
        logger.error('Admin reports error: %s', exc)
        return jsonify({'error': 'Unable to fetch admin reports'}), 500
