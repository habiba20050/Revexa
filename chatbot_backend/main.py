from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from google import genai
from google.genai import types
import uvicorn
import os
from dotenv import load_dotenv

# Load environment variables from .env file and override any system variables
load_dotenv(override=True)

app = FastAPI(title="REVEXA Bot Backend")

# Enable CORS for Flutter Web / Native clients
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

GEMINI_API_KEY = os.environ.get("GEMINI_API_KEY", "")
if not GEMINI_API_KEY:
    raise RuntimeError("GEMINI_API_KEY environment variable is not set. Please create a .env file.")

# Initialize the modern Gemini Client
client = genai.Client(api_key=GEMINI_API_KEY)

class ChatMessagePayload(BaseModel):
    role: str
    text: str

class ChatRequest(BaseModel):
    message: str
    history: list[ChatMessagePayload] = []

@app.post("/api/chat")
async def chat(request: ChatRequest):
    if not request.message.strip():
        raise HTTPException(status_code=400, detail="Message content cannot be empty")

    try:
        # Build conversational history
        formatted_history = []
        for msg in request.history:
            formatted_history.append(
                types.Content(
                    role="user" if msg.role == "user" else "model",
                    parts=[types.Part.from_text(text=msg.text)]
                )
            )

        # Start chat session with history and system instructions using the modern SDK
        chat_session = client.chats.create(
            model="gemini-2.5-flash",
            history=formatted_history,
            config=types.GenerateContentConfig(
                system_instruction=(
                    "You are REVEXA Bot, the premium AI assistant for the Revexa car service app. "
                    "Your mission is to help users with car-related questions, troubleshooting, maintenance tips, "
                    "and queries about Revexa services (mobile wash, expert maintenance, tire service, etc.). "
                    "Keep your responses extremely helpful, professional, friendly, and structured. "
                    "Answer in the same language the user uses (Arabic or English)."
                )
            )
        )
        
        # Send new message
        response = chat_session.send_message(request.message)
        
        return {
            "status": "success",
            "response": response.text.strip()
        }
    except Exception as e:
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
