#!/usr/bin/env python3
"""Merge matugen-generated color overrides into VSCodium settings.json.
Only updates workbench.colorCustomizations, preserves everything else."""
import json, os

SETTINGS = os.path.expanduser("~/.config/VSCodium/User/settings.json")
COLORS = os.path.expanduser("~/.cache/hypr-theme/vscode-colors.json")

try:
    with open(COLORS) as f:
        new_colors = json.load(f)
except (FileNotFoundError, json.JSONDecodeError):
    exit(0)

try:
    with open(SETTINGS) as f:
        settings = json.load(f)
except (FileNotFoundError, json.JSONDecodeError):
    settings = {}

# Only replace colorCustomizations, keep theme and other settings
settings["workbench.colorCustomizations"] = new_colors.get("workbench.colorCustomizations", {})

with open(SETTINGS, 'w') as f:
    json.dump(settings, f, indent=4)
