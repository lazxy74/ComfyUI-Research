# ComfyUI Workflow 调研与实践

一份从基础文生图到可控生成的 ComfyUI 学习笔记，重点梳理 SDXL Base + Refiner、LoRA、ControlNet 与 IPAdapter 的数据流、核心节点和实验结论。

> 本项目由个人调研记录整理而来，定位是学习资料与实验手册，不是 ComfyUI 官方文档。模型、节点包和工作流之间存在版本兼容性，实际使用前请核对对应项目的说明。

## 内容导航

| 主题 | 解决的问题 | 文档 |
| --- | --- | --- |
| ComfyUI-Manager | 管理自定义节点和依赖 | [环境准备](docs/01-environment-setup.md) |
| SDXL Base + Refiner | 从构图到细节精修的两阶段文生图 | [基础工作流](docs/02-sdxl-base-refiner.md) |
| LoRA | 控制风格、人物或特定概念 | [LoRA 工作流](docs/03-sdxl-lora.md) |
| ControlNet | 约束姿态、边缘、深度和草图结构 | [ControlNet 工作流](docs/04-sdxl-controlnet.md) |
| IPAdapter | 参考人脸、物体或视觉风格 | [IPAdapter 工作流](docs/05-sdxl-ipadapter.md) |
| 模型准备 | 核对模型文件、目录和用途 | [模型清单](docs/model-checklist.md) |

## 一张表理解四类工作流

| 方案 | 控制对象 | 主要插入位置 | 典型输入 |
| --- | --- | --- | --- |
| Base + Refiner | 生成阶段与细节质量 | 两段采样链路 | Prompt + 空 Latent |
| LoRA | 模型风格与概念响应 | `MODEL` 与 `CLIP` | LoRA 权重 |
| ControlNet | 构图、姿态、轮廓等结构 | `CONDITIONING` | 预处理后的结构图 |
| IPAdapter | 人脸、物体、风格等视觉特征 | `MODEL` | 参考图 + CLIP Vision |


## 快速开始

假设本机已经能够启动 ComfyUI：

```bash
# 安装 ComfyUI-Manager
bash scripts/install-manager.sh /path/to/ComfyUI

# 查看模型下载脚本说明；默认不会下载大文件
bash scripts/download-models.sh --help
```

随后根据 [模型清单](docs/model-checklist.md) 准备模型，并选择一个章节完成实验。

## 项目结构

```text
comfyui-workflow-research/
├── README.md
├── docs/
│   ├── 01-environment-setup.md
│   ├── 02-sdxl-base-refiner.md
│   ├── 03-sdxl-lora.md
│   ├── 04-sdxl-controlnet.md
│   ├── 05-sdxl-ipadapter.md
│   ├── model-checklist.md
│   └── references.md
└── scripts/
    ├── install-manager.sh
    └── download-models.sh

```

