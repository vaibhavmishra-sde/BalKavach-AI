from flask import Blueprint, request, jsonify
from backend.services.auth_service import signup_user, login_user
from backend.utils.jwt_utils import create_token
from backend.utils.logger import configure_logger
import re

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
    if not re.fullmatch(r'[^@\s]+@[^@\s]+\.[^@\s]+', email) or len(password) < 8:
        return jsonify({'error': 'Provide a valid email and a password of at least 8 characters'}), 400
    if role not in ('parent', 'child'):
        return jsonify({'error': 'role must be parent or child'}), 400

    try:
        user = signup_user(email, password, display_name, role)
        token = create_token({'uid': user['user_id'], 'role': user['role']})
        return jsonify({'user': user, 'token': token}), 201
    except ValueError as exc:
        return jsonify({'error': str(exc)}), 409
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
    except ValueError as exc:
        logger.info('Failed login attempt for %s', email)
        return jsonify({'error': str(exc)}), 401
    except Exception as exc:
        logger.error('Login error: %s', exc)
        return jsonify({'error': str(exc)}), 401
