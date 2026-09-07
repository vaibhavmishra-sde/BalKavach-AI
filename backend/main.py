import os
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
    app.config['MAX_CONTENT_LENGTH'] = int(os.getenv('MAX_UPLOAD_BYTES', 5 * 1024 * 1024))
    allowed_origins = [origin.strip() for origin in os.getenv('CORS_ORIGINS', '*').split(',')]
    CORS(app, resources={r'/*': {'origins': allowed_origins}})

    app.register_blueprint(auth_bp)
    app.register_blueprint(ai_bp)
    app.register_blueprint(admin_bp)

    @app.route('/', methods=['GET'])
    def health_check():
        return jsonify({'message': 'BalKavach AI Backend is running'}), 200

    @app.route('/health', methods=['GET'])
    def health_check_details():
        return jsonify({'status': 'ok', 'service': 'balkavach-api'}), 200

    @app.errorhandler(413)
    def upload_too_large(_error):
        return jsonify({'error': 'Upload exceeds the allowed size'}), 413

    return app


if __name__ == '__main__':
    app = create_app()
    port = int(os.getenv('FLASK_PORT', 5000))
    debug = os.getenv('FLASK_DEBUG', 'false').lower() == 'true'
    app.run(host='0.0.0.0', port=port, debug=debug)
