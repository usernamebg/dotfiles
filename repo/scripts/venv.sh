#!/usr/bin/env bash

# Script to check for .venv directory and create it if it doesn't exist

# Set the virtual environment directory name
VENV_DIR=".venv"

# Check if the virtual environment already exists
if [ -d "$VENV_DIR" ]; then
    echo "Virtual environment '$VENV_DIR' already exists."
else
    echo "Virtual environment '$VENV_DIR' does not exist. Creating it..."
    # Create the virtual environment
    python3 -m venv "$VENV_DIR"
    
    # Check if creation was successful
    if [ -d "$VENV_DIR" ]; then
        echo "Virtual environment '$VENV_DIR' created successfully."
    else
        echo "Error: Failed to create the virtual environment '$VENV_DIR'."
        exit 1
    fi
fi

echo "To activate the virtual environment, run: source $VENV_DIR/bin/activate"
