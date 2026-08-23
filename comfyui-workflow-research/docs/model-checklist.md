# 模型与依赖清单

[返回首页](../README.md)

## 模型目录

以下表格按原始调研记录整理。路径均相对于 `ComfyUI/`：

| 文件 | 存放路径 | 用途 | 必需性 |
| --- | --- | --- | --- |
| `sd_xl_base_1.0.safetensors` | `models/checkpoints/` | SDXL 基础模型 | 基础工作流必需 |
| `sd_xl_refiner_1.0.safetensors` | `models/checkpoints/` | SDXL Refiner | 两阶段工作流必需 |
| `pixel-art-xl.safetensors` | `models/loras/` | LoRA：像素艺术风格 | LoRA 示例必需 |
| `controlnet-scribble-sdxl.safetensors` | `models/controlnet/` | ControlNet：涂鸦控制 | Scribble 示例必需 |
| `controlnet-openpose-sdxl.safetensors` | `models/controlnet/` | ControlNet：姿态控制 | OpenPose 示例必需 |
| `controlnet-canny-sdxl.safetensors` | `models/controlnet/` | ControlNet：边缘控制 | 可选 |
| `CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors` | `models/clip_vision/` | IPAdapter：视觉编码器 | IPAdapter 示例必需 |
| `ip-adapter_sdxl_vit-h.safetensors` | `models/ipadapter/` | IPAdapter：图像特征注入 | IPAdapter 示例必需 |

## 自定义节点

| 仓库 | 作用 | 目录 |
| --- | --- | --- |
| [ComfyUI-Manager](https://github.com/ltdrdata/ComfyUI-Manager) | 自定义节点和依赖管理 | `custom_nodes/ComfyUI-Manager/` |
| [comfyui_controlnet_aux](https://github.com/Fannovel16/comfyui_controlnet_aux) | ControlNet 预处理器 | `custom_nodes/comfyui_controlnet_aux/` |

## 下载前检查

- [ ] 来源可信，并已阅读对应许可证；
- [ ] 文件适用于 SDXL，而不是 SD 1.5 或其他模型家族；
- [ ] 存储空间足够；
- [ ] 下载地址与预期文件名一致；
- [ ] 如发布实验结果，记录文件哈希或来源版本；
- [ ] 模型文件不会被 Git 跟踪。

## 启动后检查

- [ ] Checkpoint Loader 能列出 Base 与 Refiner；
- [ ] LoraLoader 能列出 LoRA；
- [ ] Load ControlNet Model 能列出目标 ControlNet；
- [ ] CLIP Vision 与 IPAdapter 节点能找到各自权重；
- [ ] 启动日志中没有 `missing model` 或依赖导入错误。

## Git 大文件提醒

本仓库的 `.gitignore` 已忽略常见模型扩展名。若确实需要版本化大型二进制文件，应先确认许可证，再单独评估 Git LFS；调研文档仓库通常只记录下载来源、版本和哈希。
