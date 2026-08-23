# 01. 环境准备：ComfyUI-Manager

[返回首页](../README.md)

## 作用

ComfyUI-Manager 用于安装、移除、启用、禁用和更新 ComfyUI 自定义节点，也能帮助定位工作流缺失的节点。对需要频繁尝试社区 Workflow 的学习环境而言，它通常是最先安装的扩展之一。

项目地址：[ltdrdata/ComfyUI-Manager](https://github.com/ltdrdata/ComfyUI-Manager)

## 安装

可以使用仓库内的辅助脚本：

```bash
bash scripts/install-manager.sh /path/to/ComfyUI
```

也可以手动执行：

```bash
cd /path/to/ComfyUI/custom_nodes
git clone https://github.com/ltdrdata/ComfyUI-Manager.git
```

## 重启与验证

1. 在运行 ComfyUI 的终端中按 `Ctrl + C` 停止进程。
2. 按原来的方式重新启动，例如 `python main.py`。
3. 打开 Web 界面，确认能够找到 Manager/管理器入口。
4. 如果入口未出现，先查看启动日志中的依赖错误，再确认仓库目录是否位于 `ComfyUI/custom_nodes/`。

## 建议记录的环境信息

为了让 Workflow 能够复现，建议在实验记录中保留：

- 操作系统与 Python 版本；
- ComfyUI 版本或 Git commit；
- GPU 型号与显存；
- 自定义节点仓库及其 commit；
- 基础模型、LoRA、ControlNet、IPAdapter 的文件名和哈希；
- 生成参数：Prompt、Seed、Sampler、Scheduler、Steps、CFG 和分辨率。

## 安全提醒

自定义节点是会在本机执行的第三方代码。安装前应查看仓库来源、维护状态和依赖文件；公开来源不等于经过安全审计。
