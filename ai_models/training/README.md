# AI Model Training

This folder stores training utilities and guidance for BalKavach AI models.

## Toxicity Detection
- Uses the BERT transformer model `unitary/toxic-bert`.
- The model is loaded from Hugging Face in `ai_models/toxicity_detection/bert_toxicity.py`.
- Fine-tuning can be added by using the `transformers` Trainer API.

## Image Detection
- The CNN architecture is defined in `ai_models/image_detection/cnn_image_detector.py`.
- Train with labeled safe/unsafe images and save weights to `ai_models/image_detection/cnn_image_detector.h5`.
- Example training pipeline can be added using `tensorflow.keras.preprocessing.image_dataset_from_directory`.

## Quick Start
1. Install Python dependencies from `backend/requirements.txt`.
2. Run the script in the image detection folder to initialize the model.
3. Add training data and update the model training script for custom safety labels.
