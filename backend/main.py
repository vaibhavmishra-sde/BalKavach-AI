from fastapi import FastAPI, HTTPException, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from PIL import Image
import io
import sys
import os

# Add the parent directory to the path so we can import ai_models
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# Import toxicity detector
from ai_models.toxicity_detection.bert_toxicity import ToxicityDetector

# Initialize detector
toxicity_detector = ToxicityDetector()

app = FastAPI(title="BalKavach Backend", description="AI-based Child Security System")

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class TextInput(BaseModel):
    text: str

class BehaviorInput(BaseModel):
    messages: list[str]

class ActivityInput(BaseModel):
    messages_per_hour: float
    time_online_hours: float
    unique_contacts: int
    late_night_activity: float

@app.get("/")
async def health_check():
    return {"message": "BalKavach AI Backend is running"}

@app.post("/analyze_text")
async def analyze_text(input_data: TextInput):
    try:
        result = toxicity_detector.predict(input_data.text)
        toxicity_score = float(result.get('toxicity', 0))
        
        return {
            "text": input_data.text,
            "toxicity": "toxic" if toxicity_score > 50 else "safe",
            "confidence": min(toxicity_score / 100.0, 1.0),
            "risk_score": toxicity_score,
            "alert_level": "High" if toxicity_score > 50 else "Low",
            "details": result.get('scores', {})
        }
    except Exception as e:
        print(f"Error in analyze_text: {str(e)}")
        import traceback
        traceback.print_exc()
        return {
            "text": input_data.text,
            "toxicity": "error",
            "confidence": 0.0,
            "risk_score": 0.0,
            "alert_level": "Low",
            "error": str(e)
        }

@app.post("/analyze_image")
async def analyze_image(file: UploadFile = File(...)):
    try:
        image_data = await file.read()
        image = Image.open(io.BytesIO(image_data))
        width, height = image.size
        
        # Placeholder: simple heuristic for demo
        is_unsafe = width < 100 or height < 100
        confidence = 0.8 if is_unsafe else 0.9

        return {
            "filename": file.filename,
            "classification": "unsafe" if is_unsafe else "safe",
            "confidence": confidence,
            "risk_score": 80 if is_unsafe else 10,
            "alert_level": "High" if is_unsafe else "Low"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/analyze_behavior")
async def analyze_behavior_endpoint(input_data: BehaviorInput):
    try:
        # Placeholder: simple heuristic for demo
        suspicious_keywords = ['late night', 'unknown', 'secret', 'meet', 'personal info']
        
        risk_score = 0
        for message in input_data.messages[-10:]:
            if any(keyword in message.lower() for keyword in suspicious_keywords):
                risk_score += 10
        
        return {
            "messages_analyzed": len(input_data.messages),
            "behavior_risk": min(risk_score, 100),
            "pattern_detected": risk_score > 50,
            "recommendations": "Monitor closely" if risk_score > 50 else "Normal activity",
            "alert_level": "High" if risk_score > 50 else "Low"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/detect_anomaly")
async def detect_anomaly_endpoint(input_data: ActivityInput):
    try:
        # Placeholder: simple heuristic for demo
        normal_ranges = {
            'messages_per_hour': (0, 20),
            'time_online_hours': (0, 8),
            'unique_contacts': (0, 50),
            'late_night_activity': (0, 2)
        }
        
        anomaly_score = 0
        activity_data = {
            'messages_per_hour': input_data.messages_per_hour,
            'time_online_hours': input_data.time_online_hours,
            'unique_contacts': input_data.unique_contacts,
            'late_night_activity': input_data.late_night_activity
        }
        
        for feature, value in activity_data.items():
            if feature in normal_ranges:
                min_val, max_val = normal_ranges[feature]
                if value < min_val or value > max_val:
                    anomaly_score += (abs(value - (min_val + max_val)/2) / ((max_val - min_val)/2))
        
        is_anomaly = anomaly_score > 0.1
        
        return {
            "anomaly_score": min(anomaly_score, 1.0),
            "is_anomaly": is_anomaly,
            "confidence": 0.9 if is_anomaly else 0.7,
            "description": "Abnormal activity detected" if is_anomaly else "Normal activity",
            "alert_level": "High" if is_anomaly else "Low"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
