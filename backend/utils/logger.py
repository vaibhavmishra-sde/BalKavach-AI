import logging
import os


def configure_logger():
    logger = logging.getLogger('balkavach')
    if not logger.handlers:
        handler = logging.StreamHandler()
        formatter = logging.Formatter(
            '%(asctime)s - %(levelname)s - %(name)s - %(message)s'
        )
        handler.setFormatter(formatter)
        logger.setLevel(getattr(logging, os.getenv('LOG_LEVEL', 'INFO').upper(), logging.INFO))
        logger.addHandler(handler)
    return logger
