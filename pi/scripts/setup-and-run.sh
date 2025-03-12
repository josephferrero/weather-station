#!/bin/bash

set -e  # Exit on error

# ✅ Install system dependencies
echo "📦 Installing system dependencies..."
sudo apt update && sudo apt install -y python3-venv python3-pip python3-full

# ✅ Create a virtual environment (if not exists)
if [ ! -d "../venv" ]; then
    echo "🌱 Creating virtual environment..."
    python3 -m venv "../venv"
else
    echo "✅ Virtual environment already exists."
fi

# ✅ Activate the virtual environment
echo "🔗 Activating virtual environment..."
source "$../venv/bin/activate"

# ✅ Upgrade pip & install dependencies
echo "📦 Installing Python dependencies..."
pip install --upgrade pip
pip install -r "./requirements.txt"

# ✅ Ensure `main.py` is run from the correct path
if [ -f "$../src/main.py" ]; then
    echo "🌦️ Starting Weather Station..."
    python "../src/main.py"
else
    echo "❌ ERROR: main.py not found in $../src/"
    exit 1
fi

