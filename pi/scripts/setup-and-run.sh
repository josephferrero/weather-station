#!/bin/bash

set -e  # Exit on error
cd "$(dirname "$0")"  # Ensure script runs from `pi/`
PROJECT_ROOT=$(pwd)

echo "🚀 Starting setup for Weather Station from: $PROJECT_ROOT"

# ✅ Debugging output
echo "📂 Current working directory: $(pwd)"
ls -l src/  # List files inside `src/` to confirm `main.py` exists

# ✅ Install system dependencies
echo "📦 Installing system dependencies..."
sudo apt update && sudo apt install -y python3-venv python3-pip python3-full

# ✅ Create a virtual environment (if not exists)
if [ ! -d "$PROJECT_ROOT/venv" ]; then
    echo "🌱 Creating virtual environment..."
    python3 -m venv "$PROJECT_ROOT/venv"
else
    echo "✅ Virtual environment already exists."
fi

# ✅ Activate the virtual environment
echo "🔗 Activating virtual environment..."
source "$PROJECT_ROOT/venv/bin/activate"

# ✅ Upgrade pip & install dependencies
echo "📦 Installing Python dependencies..."
pip install --upgrade pip
pip install -r "$PROJECT_ROOT/requirements.txt"

# ✅ Ensure `main.py` is run from the correct path
if [ -f "$PROJECT_ROOT/src/main.py" ]; then
    echo "🌦️ Starting Weather Station..."
    python "$PROJECT_ROOT/src/main.py"
else
    echo "❌ ERROR: main.py not found in $PROJECT_ROOT/src/"
    exit 1
fi

