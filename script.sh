#!/bin/bash

# Define available models and their corresponding GitHub repos & Hugging Face models
declare -A MODELS
MODELS["whisper"]="https://github.com/openai/whisper.git"
MODELS["wav2vec2"]="https://github.com/facebookresearch/wav2vec2.git"
MODELS["suno-bark"]="https://github.com/suno-ai/bark.git"
MODELS["kokoro-tts"]="https://github.com/hexgrad/kokoro.git"

declare -A HUGGINGFACE_MODELS
HUGGINGFACE_MODELS["whisper"]="openai/whisper-large-v3"
HUGGINGFACE_MODELS["wav2vec2"]="facebook/wav2vec2-large-960h"
HUGGINGFACE_MODELS["suno-bark"]="suno/bark"
HUGGINGFACE_MODELS["kokoro-tts"]="hexgrad/kokoro-v1_0"

declare -A START_COMMANDS
START_COMMANDS["whisper"]="python api-server.py"
START_COMMANDS["wav2vec2"]="python server.py"
START_COMMANDS["suno-bark"]="python run.py --port 8000"
START_COMMANDS["kokoro-tts"]="python api-server.py"

# Prompt user for model selection
echo "Available voice AI models:"
for model in "${!MODELS[@]}"; do
    echo "- $model"
done

read -p "Enter the model you want to use: " SELECTED_MODEL

# Validate user selection
if [[ -z "${MODELS[$SELECTED_MODEL]}" ]]; then
    echo "Invalid selection. Exiting..."
    exit 1
fi

# Variables
REPO_URL="${MODELS[$SELECTED_MODEL]}"
REPO_NAME=$(basename "$REPO_URL" .git)
ENV_NAME="${SELECTED_MODEL}_env"
PYTHON_VERSION="3.10"
MODEL_DIR="models"
HF_MODEL="${HUGGINGFACE_MODELS[$SELECTED_MODEL]}"
START_CMD="${START_COMMANDS[$SELECTED_MODEL]}"

# Clone the repository
echo "Cloning repository for $SELECTED_MODEL..."
# git clone "$REPO_URL"

# Enter repo directory
# cd "$REPO_NAME" || { echo "Failed to enter directory"; exit 1; }

# Create and activate Conda environment
echo "Setting up Conda environment..."
conda create -y -n "$ENV_NAME" python="$PYTHON_VERSION"
source activate "$ENV_NAME" || conda activate "$ENV_NAME"

# Install dependencies
echo "Installing dependencies..."
pip install -r requirements.txt


# Start the model server
echo "Starting $SELECTED_MODEL server..."
eval "$START_CMD"

