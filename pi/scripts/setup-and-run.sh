#!/bin/bash

set -e  # Exit on error

cd ..

# # ✅ Install system dependencies
# echo "📦 Installing system dependencies..."
# sudo apt update && sudo apt install -y python3-venv python3-pip python3-full

# ✅ Create a virtual environment (if not exists)
if [ ! -d "venv" ]; then
    echo "🌱 Creating virtual environment..."
    python3 -m venv venv
else
    echo "✅ Virtual environment already exists."
fi

# ✅ Use the absolute path for venv's Python & Pip
VENV_PYTHON="$(pwd)/venv/bin/python"
VENV_PIP="$(pwd)/venv/bin/pip"

# ✅ Activate the virtual environment
echo "🔗 Activating virtual environment..."
source venv/bin/activate

# ✅ Upgrade pip & install dependencies using venv pip
echo "📦 Installing Python dependencies..."
$VENV_PIP install --upgrade pip
$VENV_PIP install -r requirements.txt

# ✅ Ensure `main.py` is run from the correct path
if [ -f src/main.py ]; then
    echo "🌦️ Starting Weather Station..."
    $VENV_PYTHON src/main.py  # ✅ Use the venv Python explicitly
else
    echo "❌ ERROR: main.py not found in src/"
    exit 1
fi

