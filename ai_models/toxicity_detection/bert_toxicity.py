from transformers import pipeline


class ToxicityDetector:
    def __init__(self):
        self.classifier = pipeline(
            'text-classification',
            model='unitary/toxic-bert',
            return_all_scores=True,
        )

    
    def predict(self, text: str):
        results = self.classifier(text)
        if not results or not results[0]:
            return {'toxicity': 0.0, 'labels': {}}

        
        scores = {item['label']: float(item['score']) for item in results[0]}
        toxic_score = scores.get('toxic', scores.get('TOXIC', 0.0))
        return {
            'text': text,
            'toxicity': round(toxic_score * 100, 2),
            'scores': scores,
        }
