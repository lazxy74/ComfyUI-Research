#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  DOWNLOAD_COMFYUI_MODELS=1 bash scripts/download-models.sh /path/to/ComfyUI [set]

Sets:
  lora        Pixel-art SDXL LoRA
  controlnet  OpenPose, Scribble, and Canny SDXL ControlNet models
  ipadapter   IPAdapter SDXL and CLIP Vision models
  all         All models listed above (default)

The script is intentionally locked because model downloads are large.
URLs come from the original research notes. Verify source, license, and hashes first.
EOF
}

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  usage
  exit 0
fi

if [[ $# -lt 1 || $# -gt 2 ]]; then
  usage >&2
  exit 2
fi

if [[ "${DOWNLOAD_COMFYUI_MODELS:-}" != "1" ]]; then
  echo "Download lock is active. Review this script, then set DOWNLOAD_COMFYUI_MODELS=1." >&2
  exit 1
fi

if ! command -v wget >/dev/null 2>&1; then
  echo "wget is required." >&2
  exit 1
fi

comfyui_dir="${1%/}"
model_set="${2:-all}"

if [[ ! -d "$comfyui_dir/models" ]]; then
  echo "ComfyUI models directory does not exist: $comfyui_dir/models" >&2
  exit 1
fi

download() {
  local url="$1"
  local destination="$2"
  mkdir -p "$(dirname "$destination")"
  if [[ -s "$destination" ]]; then
    echo "Skip existing file: $destination"
    return
  fi
  wget --continue "$url" -O "$destination"
}

download_lora() {
  download \
    "https://hf-mirror.com/nerijs/pixel-art-xl/resolve/main/pixel-art-xl.safetensors" \
    "$comfyui_dir/models/loras/pixel-art-xl.safetensors"
}

download_controlnet() {
  download \
    "https://hf-mirror.com/xinsir/controlnet-openpose-sdxl-1.0/resolve/main/diffusion_pytorch_model.safetensors" \
    "$comfyui_dir/models/controlnet/controlnet-openpose-sdxl.safetensors"
  download \
    "https://hf-mirror.com/xinsir/controlnet-scribble-sdxl-1.0/resolve/main/diffusion_pytorch_model.safetensors" \
    "$comfyui_dir/models/controlnet/controlnet-scribble-sdxl.safetensors"
  download \
    "https://hf-mirror.com/xinsir/controlnet-canny-sdxl-1.0/resolve/main/diffusion_pytorch_model.safetensors" \
    "$comfyui_dir/models/controlnet/controlnet-canny-sdxl.safetensors"
}

download_ipadapter() {
  download \
    "https://hf-mirror.com/h94/IP-Adapter/resolve/main/sdxl_models/ip-adapter_sdxl_vit-h.safetensors" \
    "$comfyui_dir/models/ipadapter/ip-adapter_sdxl_vit-h.safetensors"
  download \
    "https://hf-mirror.com/h94/IP-Adapter/resolve/main/models/image_encoder/model.safetensors" \
    "$comfyui_dir/models/clip_vision/CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors"
}

case "$model_set" in
  lora) download_lora ;;
  controlnet) download_controlnet ;;
  ipadapter) download_ipadapter ;;
  all)
    download_lora
    download_controlnet
    download_ipadapter
    ;;
  *)
    echo "Unknown set: $model_set" >&2
    usage >&2
    exit 2
    ;;
esac

echo "Downloads completed. Restart ComfyUI and verify that each loader can see the files."
