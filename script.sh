#!/bin/bash

START_COMMAND="python api-server.py"


# Create and activate Conda environment
echo "Setting up Conda environment..."
conda create -y -n "kokoro" python="3.10"
source activate "kokoro" || conda activate "kokoro"

# Install dependencies
echo "Installing dependencies..."
pip install -r requirements.txt


# Start the model server
echo "Starting kokoro server..."
eval "$START_COMMAND"

