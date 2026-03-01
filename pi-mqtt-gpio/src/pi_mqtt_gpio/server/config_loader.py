"""
Configuration Loader.

Responsible for reading and validating the config.yaml file.
"""
import yaml
import logging
from pathlib import Path
from typing import Dict, Any

logger = logging.getLogger(__name__)

def load_config(config_path: str = "config.yaml") -> Dict[str, Any]:
    """
    Loads the YAML configuration file.
    """
    path = Path(config_path)
    if not path.exists():
        logger.warning(f"Config file not found at {path}. Using defaults.")
        return {}

    try:
        with open(path, 'r') as f:
            config = yaml.safe_load(f) or {}
            logger.info(f"Loaded configuration from {path}")
            return config
    except Exception as e:
        logger.error(f"Failed to parse config file: {e}")
        raise