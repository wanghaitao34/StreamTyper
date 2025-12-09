#!/bin/bash

# Check if icon.png exists
if [ ! -f "icon.png" ]; then
    echo "Error: icon.png not found!"
    echo "Please save your icon image as 'icon.png' in this folder and try again."
    exit 1
fi

# Create virtual environment if it doesn't exist
if [ ! -d ".venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv .venv
fi

# Activate virtual environment
source .venv/bin/activate

# Install Pillow if not installed
if ! python3 -c "import PIL" &> /dev/null; then
    echo "Installing Pillow..."
    pip install Pillow
fi

# Run the generator script
echo "Running icon generator..."
python3 generate_icons.py

echo "Done!"
