#!/bin/bash

APPIMAGE_PATH="$HOME/repo/appimages/viber.AppImage"

if [[ -f "$APPIMAGE_PATH" ]]; then
  "$APPIMAGE_PATH"
else
  echo "Error: Viber AppImage not found at $APPIMAGE_PATH" >&2
  exit 1
fi
