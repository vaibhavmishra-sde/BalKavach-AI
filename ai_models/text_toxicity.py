from transformers import pipeline
from typing import Dict

_classifier = None


def get_classifier():
    global _classifier
    if _classifier is None:
        # In production, use a fine-tuned BERT model trained for toxicity detection.
        _classifier = pipeline("text-classification", model="unitary/toxic-bert")
    return _classifier


def analyze_text(text: str) -> Dict:
    clf = get_classifier()
    resp = clf(text, truncation=True)
    # resp example: [{'label': 'toxic', 'score': 0.98}]
    label = resp[0]["label"]
    score = float(resp[0]["score"])
    if score > 0.85:
        risk = "high"
    elif score > 0.6:
        risk = "medium"
    else:
        risk = "low"
    return {"label": label, "confidence": score, "risk_level": risk}
