# 01. 环境准备：ComfyUI-Manager

[返回首页](../README.md)

## 作用

ComfyUI-Manager 用于安装、移除、启用、禁用和更新 ComfyUI 自定义节点，也能帮助定位工作流缺失的节点。对需要频繁尝试社区 Workflow 的学习环境而言，它通常是最先安装的扩展之一。

项目地址：[ltdrdata/ComfyUI-Manager](https://github.com/ltdrdata/ComfyUI-Manager)

## 安装

```bash
cd /path/to/ComfyUI/custom_nodes
git clone https://github.com/ltdrdata/ComfyUI-Manager.git
```

## 重启与验证

1. 在运行 ComfyUI 的终端中按 `Ctrl + C` 停止进程。
2. 按原来的方式重新启动，例如 `python main.py`。
3. 打开 Web 界面，确认能够在右上角找到 Manager管理器按钮。
4. 如果入口未出现，确认仓库目录是否位于 `ComfyUI/custom_nodes/`。


