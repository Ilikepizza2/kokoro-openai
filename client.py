from openai import OpenAI

client = OpenAI(
    base_url="http://localhost:8000/v1",
    api_key="dummy-key"
)

response = client.chat.completions.create(
    model="kokoro-tts",
    modalities=["text", "audio"],
    audio={
        "voice": "af_heart", 
        "format": "wav",
        "lang_code": "a",
        "speed": 1
    },
    messages=[
        {
            "role": "user",
            "content": [{"text": "This is the text to be converted to speech with a female voice.", "type": "text"}]
        }
    ]
)

# Save audio
import base64
with open("output.wav", "wb") as f:
    f.write(base64.b64decode(response.choices[0].message.audio.data))
