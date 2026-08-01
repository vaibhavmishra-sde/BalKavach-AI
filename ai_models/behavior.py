from typing import Dict
import numpy as np

# Placeholder GRU model interface


def analyze_sequence(sequence) -> Dict:
    # sequence: list of tokenized messages or embedding vectors
    # Here we compute a simple heuristic risk score for demo purposes
    score = min(1.0, 0.01 * len(sequence))
    return {"risk_score": score, "details": {"sequence_length": len(sequence)}}
