#!/bin/bash

set -e  # Exit on error

cd ..

# ✅ Install system dependencies
echo "📦 Installing system dependencies..."
sudo apt update && sudo apt install -y python3-venv python3-full

# ✅ Create a virtual environment (if not exists)
if [ ! -d "venv" ]; then
    echo "🌱 Creating virtual environment..."
    python3 -m venv venv
fi

# ✅ Use the absolute path for venv's Python & Pip
VENV_PYTHON="$(pwd)/venv/bin/python"
VENV_PIP="$(pwd)/venv/bin/pip"

# ✅ Ensure `pip` is installed inside the venv
if [ ! -f "$VENV_PIP" ]; then
    echo "⚠️ pip is missing, installing..."
    $VENV_PYTHON -m ensurepip --default-pip
fi

# ✅ Activate the virtual environment
echo "🔗 Activating virtual environment..."
source venv/bin/activate

# ✅ Upgrade pip & install dependencies
echo "📦 Installing Python dependencies..."
$VENV_PIP install --upgrade pip
$VENV_PIP install -r scripts/requirements.txt

# ✅ Run `main.py` using the correct Python
if [ -f src/main.py ]; then
    echo "🌦️ Starting Weather Station..."
    $VENV_PYTHON src/main.py
else
    echo "❌ ERROR: main.py not found in src/"
    exit 1
fi

