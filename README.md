# kokoro-openai

A fastapi openai compliant server that converts written text into spoken audio using [Kokoro-82M][kokoro].

Usage:

1. `conda create -n "kokoro" python=3.10`
2. `conda activate kokoro`
2. `pip install -r requirements.txt`
3. `python api-server.py`
4. You can test this using client.py or through the frontend.


Inspired by https://github.com/bmgxyz/kokoro-server
[kokoro]: https://huggingface.co/hexgrad/Kokoro-82M