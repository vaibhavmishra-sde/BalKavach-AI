from flask import Blueprint, request, jsonify
from backend.services.auth_service import signup_user, login_user
from backend.utils.jwt_utils import create_token
from backend.utils.logger import configure_logger

logger = configure_logger()
auth_bp = Blueprint('auth', __name__, url_prefix='/api/auth')


@auth_bp.route('/signup', methods=['POST'])
def signup():
    data = request.json or {}
    email = data.get('email')
    password = data.get('password')
    display_name = data.get('display_name')
    role = data.get('role', 'parent')

    if not (email and password and display_name):
        return jsonify({'error': 'email, password and display_name are required'}), 400

    try:
        user = signup_user(email, password, display_name, role)
        token = create_token({'uid': user['user_id'], 'role': user['role']})
        return jsonify({'user': user, 'token': token}), 201
    except Exception as exc:
        logger.error('Signup error: %s', exc)
        return jsonify({'error': str(exc)}), 500


@auth_bp.route('/login', methods=['POST'])
def login():
    data = request.json or {}
    email = data.get('email')
    password = data.get('password')

    if not (email and password):
        return jsonify({'error': 'email and password are required'}), 400

    try:
        user = login_user(email, password)
        token = create_token({'uid': user['user_id'], 'role': user['role']})
        return jsonify({'user': user, 'token': token}), 200
    except Exception as exc:
        logger.error('Login error: %s', exc)
        return jsonify({'error': str(exc)}), 401
