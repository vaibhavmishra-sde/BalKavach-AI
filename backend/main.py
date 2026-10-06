import os
import uuid
from flask import Flask, jsonify
from flask_cors import CORS
from dotenv import load_dotenv
from backend.controllers.auth_controller import auth_bp
from backend.controllers.ai_controller import ai_bp
from backend.controllers.admin_controller import admin_bp


def create_app():
    load_dotenv(os.path.join(os.path.dirname(__file__), '.env'))
    app = Flask(__name__, static_folder=None)
    app.config['JSONIFY_PRETTYPRINT_REGULAR'] = False
    app.config['API_VERSION'] = os.getenv('API_VERSION', '1.0.0')
    app.config['MAX_CONTENT_LENGTH'] = int(os.getenv('MAX_UPLOAD_BYTES', 5 * 1024 * 1024))
    allowed_origins = [origin.strip() for origin in os.getenv('CORS_ORIGINS', '*').split(',')]
    CORS(app, resources={r'/*': {'origins': allowed_origins}})

    @app.before_request
    def add_request_id():
        from flask import g, request
        g.request_id = request.headers.get('X-Request-ID') or str(uuid.uuid4())

    @app.after_request
    def add_response_headers(response):
        from flask import g
        response.headers['X-Request-ID'] = g.request_id
        response.headers['X-Content-Type-Options'] = 'nosniff'
        response.headers['X-Frame-Options'] = 'DENY'
        response.headers['Referrer-Policy'] = 'no-referrer'
        return response

    app.register_blueprint(auth_bp)
    app.register_blueprint(ai_bp)
    app.register_blueprint(admin_bp)

    @app.route('/', methods=['GET'])
    def health_check():
        return jsonify({'message': 'BalKavach AI Backend is running', 'version': app.config['API_VERSION']}), 200

    @app.route('/health', methods=['GET'])
    def health_check_details():
        return jsonify({'status': 'ok', 'service': 'balkavach-api'}), 200

    @app.errorhandler(413)
    def upload_too_large(_error):
        return jsonify({'error': 'Upload exceeds the allowed size'}), 413

    @app.errorhandler(404)
    def route_not_found(_error):
        return jsonify({'error': 'Route not found'}), 404

    @app.errorhandler(400)
    def bad_request(_error):
        return jsonify({'error': 'Invalid request'}), 400

    @app.errorhandler(Exception)
    def unexpected_error(error):
        app.logger.exception('Unhandled request error: %s', error)
        return jsonify({'error': 'Internal server error'}), 500

    return app


if __name__ == '__main__':
    app = create_app()
    port = int(os.getenv('FLASK_PORT', 5000))
    debug = os.getenv('FLASK_DEBUG', 'false').lower() == 'true'
    app.run(host='0.0.0.0', port=port, debug=debug)
