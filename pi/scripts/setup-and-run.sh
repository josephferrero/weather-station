#!/bin/bash

set -e  # Exit on error
cd "$(dirname "$0")"  # Ensure the script runs from `pi/`
PROJECT_ROOT=$(pwd)

echo "🚀 Starting setup for Weather Station from $PROJECT_ROOT..."

# ✅ 1. Install system dependencies
echo "📦 Installing system dependencies..."
sudo apt update && sudo apt install -y python3-venv python3-pip python3-full

# ✅ 2. Create a virtual environment (if not exists)
if [ ! -d "$PROJECT_ROOT/venv" ]; then
    echo "🌱 Creating virtual environment..."
    python3 -m venv "$PROJECT_ROOT/venv"
else
    echo "✅ Virtual environment already exists."
fi

# ✅ 3. Activate the virtual environment
echo "🔗 Activating virtual environment..."
source "$PROJECT_ROOT/venv/bin/activate"

# ✅ 4. Upgrade pip & install dependencies
echo "📦 Installing Python dependencies..."
pip install --upgrade pip
pip install -r "$PROJECT_ROOT/requirements.txt"

# ✅ 5. Run the weather station app from the correct path
echo "🌦️ Starting Weather Station..."
python "$PROJECT_ROOT/src/main.py"
