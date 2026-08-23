#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 /path/to/ComfyUI" >&2
  exit 2
fi

comfyui_dir="${1%/}"
custom_nodes_dir="$comfyui_dir/custom_nodes"
manager_dir="$custom_nodes_dir/ComfyUI-Manager"

if [[ ! -d "$comfyui_dir" ]]; then
  echo "ComfyUI directory does not exist: $comfyui_dir" >&2
  exit 1
fi

mkdir -p "$custom_nodes_dir"

if [[ -d "$manager_dir/.git" ]]; then
  echo "ComfyUI-Manager is already installed: $manager_dir"
  echo "Review local changes before updating it manually."
  exit 0
fi

if [[ -e "$manager_dir" ]]; then
  echo "Target exists but is not a Git checkout: $manager_dir" >&2
  exit 1
fi

git clone https://github.com/ltdrdata/ComfyUI-Manager.git "$manager_dir"
echo "Installed ComfyUI-Manager. Restart ComfyUI to load it."
