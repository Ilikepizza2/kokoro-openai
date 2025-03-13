#!/usr/bin/env python3

import io
import torch
import base64
import soundfile as sf
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from fastapi.responses import JSONResponse
from kokoro import KPipeline
import uvicorn
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()
origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
# Set up pipeline (loads Kokoro model once)
pipeline = KPipeline(lang_code="a")

# OpenAI-compatible request format
class TTSRequest(BaseModel):
    model: str = "kokoro-tts"
    modalities: list = ["text", "audio"]
    audio: dict
    messages: list

@app.post("/v1/chat/completions")
async def tts(request: TTSRequest):
    # Extract message content
    text = None
    for item in request.messages[-1]['content']:
        if item['type'] == "text":
            text = item['text']
    audio_config = request.audio

    voice = audio_config.get("voice", "af_heart")
    speed = audio_config.get("speed", 1)

    # Generate speech
    generator = pipeline(text, voice=voice, speed=speed)

    all_audio = []
    for _, _, audio in generator:
        all_audio.append(audio)
    all_audio = torch.cat(all_audio)

    # Convert to WAV
    buffer = io.BytesIO()
    sf.write(buffer, all_audio, 24000, format="WAV")
    buffer.seek(0)

    # Encode in base64
    audio_b64 = base64.b64encode(buffer.read()).decode("utf-8")

    # OpenAI-compatible response
    return JSONResponse({
        "choices": [
            {
                "message": {
                    "role": "assistant",
                    "audio": {
                        "data": audio_b64,
                        "format": "wav"
                    }
                }
            }
        ]
    })

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)