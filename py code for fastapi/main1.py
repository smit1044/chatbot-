from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import mysql.connector
from pydantic import BaseModel
import random  # For randomized greetings

app = FastAPI()

# Enable CORS for frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  
    allow_credentials=True,
    allow_methods=["POST", "GET"],
    allow_headers=["*"],
)

# MySQL Database Connection
def get_db_connection():
    try:
        conn = mysql.connector.connect(
            host="localhost",
            user="root",  
            password="smit1044",  
            database="chatbot"  
        )
        return conn
    except mysql.connector.Error as e:
        raise HTTPException(status_code=500, detail=f"Database Connection Error: {e}")

# Request Model
class ChatRequest(BaseModel):
    message: str

# Predefined greetings with bot responses
greetings = {
    "hi": ["Hello!", "Hey there!", "Hi! How can I assist you?"],
    "hello": ["Hello!", "Hi! What can I help you with?", "Hey, how's your day?"],
    "hey": ["Hey!", "Hey there! Need help?", "Hi! How's it going?"],
    "hola": ["¡Hola!", "Hola! ¿Cómo puedo ayudarte?", "Hola! What can I do for you?"],
    "namaste": ["Namaste! 🙏", "Namaste! How can I assist?", "Namaste! What do you need?"],
    "bonjour": ["Bonjour!", "Bonjour! How can I help?", "Bonjour! Need assistance?"],
    "yo": ["Yo! What's up?", "Yo! How can I help?", "Yo! Need something?"],
    "ram ram": ["Ram Ram! 🙏", "Ram Ram! How can I assist?", "Ram Ram! What do you need?"],
}

@app.post("/chat")
def chat(request: ChatRequest):
    user_message = request.message.lower().strip()
    
    # Check if user message is a greeting
    if user_message in greetings:
        return {"reply": random.choice(greetings[user_message])}  

    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        # Search in database
        cursor.execute("SELECT bot_response FROM chatbot_responses WHERE user_question = %s", (user_message,))
        result = cursor.fetchone()

        if result:
            reply = result["bot_response"]
        else:
            reply = "Sorry, I don't understand. Please ask another question."

        return {"reply": reply}

    except mysql.connector.Error as e:
        raise HTTPException(status_code=500, detail=f"MySQL Error: {e}")

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

    finally:
        if 'cursor' in locals() and cursor:
            cursor.close()
        if 'conn' in locals() and conn:
            conn.close()
