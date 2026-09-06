# 08. LivePortrait 数字人实验

[返回首页](../README.md)

## 一、实验目的

使用 ComfyUI + LivePortrait 完成：

> **静态 Source Face（源人脸图片） + Driving Video（驱动视频） → 动态人脸视频**

本实验主要验证 LivePortrait 在 ComfyUI 中进行人脸视频驱动的效果。

同时通过本实验理解数字人与前面图像/视频生成 Workflow 的区别。


## 三、安装 LivePortrait 插件

进入 ComfyUI 的 `custom_nodes`：

```bash
cd /root/ComfyUI/custom_nodes
```

克隆插件：

```bash
git clone https://ghfast.top/https://github.com/kijai/ComfyUI-LivePortraitKJ.git
```

进入插件目录：

```bash
cd ComfyUI-LivePortraitKJ
```

安装依赖：

```bash
pip install -r requirements.txt
```


## 四、选择 LivePortrait Workflow

进入插件的 `examples`：

```bash
cd /root/ComfyUI/custom_nodes/ComfyUI-LivePortraitKJ/examples
ls
```

可以看到：

```text
liveportrait_image_example_01.json
liveportrait_realtime_example_01.json
liveportrait_video_example_02.json
```

### 本实验使用

```text
liveportrait_image_example_01.json
```


其他 Workflow：

```text
liveportrait_realtime_example_01.json
```

主要用于实时摄像头/屏幕驱动。

```text
liveportrait_video_example_02.json
```

主要用于视频相关的 LivePortrait Workflow，并不是本次静态人脸 + Driving Video 实验的首选。

## 六、准备 Source Face

Source Face 就是：

> **希望被 LivePortrait 驱动的人脸图片。**

### 源人脸
![源人脸](https://private-user-images.githubusercontent.com/220977013/646878142-e9c26331-e246-4be0-ac9c-c3a5874eee66.jpg?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3ODg2Nzc0MjgsIm5iZiI6MTc4ODY3NzEyOCwicGF0aCI6Ii8yMjA5NzcwMTMvNjQ2ODc4MTQyLWU5YzI2MzMxLWUyNDYtNGJlMC1hYzljLWMzYTU4NzRlZWU2Ni5qcGc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjYwOTA2JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI2MDkwNlQwNjQ1MjhaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT0zMjQwMjg4NGJmZDE3MzY3YzI1MjVlOTFkYjljZmY2ZmNlYThmODExNmZjNjVmMDJjZDQ3ZmIxYTEwMDdmYTY4JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZyZXNwb25zZS1jb250ZW50LXR5cGU9aW1hZ2UlMkZqcGVnIn0.0KRKUyeje2xHWp8IagWdOtSP8aFDyyDtW6zWFypidOE)

---

## 七、准备 Driving Video

Driving Video 就是：

> **提供动作、表情和头部运动的视频。**

LivePortrait 会分析 Driving Video 中的人脸动作，再将这些动作迁移到 Source Face。

### 本次实验

使用官方示例：

```text
d0.mp4
```
![d0.MP4](https://github-production-user-asset-6210df.s3.amazonaws.com/220977013/646878127-2232b9d9-a770-421e-858a-828310b598a6.mp4?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAVCODYLSA53PQK4ZA%2F20260906%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20260906T065944Z&X-Amz-Expires=300&X-Amz-Signature=4bd825e835cacd4e68c8c53d2c7e917e0a5876762ff118752142695c76092ca1&X-Amz-SignedHeaders=host&response-content-type=video%2Fmp4)


## 十、下载模型

进入 ComfyUI：

```bash
cd /root/ComfyUI
```

创建目录：

```bash
mkdir -p models/liveportrait
```

### 1. landmark.onnx

```bash
wget -O models/liveportrait/landmark.onnx \
https://hf-mirror.com/Kijai/LivePortrait_safetensors/resolve/main/landmark.onnx
```

### 2. appearance_feature_extractor.safetensors

```bash
wget -O models/liveportrait/appearance_feature_extractor.safetensors \
https://hf-mirror.com/Kijai/LivePortrait_safetensors/resolve/main/appearance_feature_extractor.safetensors
```

### 3. motion_extractor.safetensors

```bash
wget -O models/liveportrait/motion_extractor.safetensors \
https://hf-mirror.com/Kijai/LivePortrait_safetensors/resolve/main/motion_extractor.safetensors
```

### 4. warping_module.safetensors

```bash
wget -O models/liveportrait/warping_module.safetensors \
https://hf-mirror.com/Kijai/LivePortrait_safetensors/resolve/main/warping_module.safetensors
```

### 5. spade_generator.safetensors

```bash
wget -O models/liveportrait/spade_generator.safetensors \
https://hf-mirror.com/Kijai/LivePortrait_safetensors/resolve/main/spade_generator.safetensors
```

### 6. stitching_retargeting_module.safetensors

```bash
wget -O models/liveportrait/stitching_retargeting_module.safetensors \
https://hf-mirror.com/Kijai/LivePortrait_safetensors/resolve/main/stitching_retargeting_module.safetensors
```

---

## 十一、检查模型

执行：

```bash
ls -lh models/liveportrait/
```

最终应该能够看到上述 6 个模型文件。

---

## 十三、操作出现的问题

由于当前版本的 ComfyUI 启用了 Dynamic VRAM，并使用 `comfy-aimdo` 进行模型加载。

因此单独使用：

```text
--disable-mmap
```

并不能完全绕过当前的 ModelMMAP 加载路径。

最终使用：

```bash
python main.py --listen 0.0.0.0 --disable-mmap --disable-dynamic-vram
```

### `--disable-mmap`

关闭 mmap 相关加载方式。

### `--disable-dynamic-vram`

关闭 Dynamic VRAM。

最终启动日志出现：

```text
Dynamic vram disabled with argument.
```

之后 LivePortrait 模型可以正常加载。


## 十六、ComfyUI 中的主要节点

### Source Face

`LoadImage`

用于加载源人脸图片。

### Driving Video

`VHS_LoadVideo`

用于加载 Driving Video。

### 人脸裁剪

`LivePortraitCropper`

负责对人脸进行检测和裁剪。

### LivePortrait 模型与处理

`LivePortrait Load MediaPipeCropper`

以及：

`LivePortraitProcess`

负责核心的人脸运动迁移。

### 视频输出

`VHS_VideoCombine`

将生成的帧合成为最终视频。

---

## 十七、最终输出结果与workflow完整图

### 略显凌乱的workflow
![完整workflow](https://private-user-images.githubusercontent.com/220977013/646881032-c386476e-20d9-4754-a663-d21655933148.png?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3ODg2Nzg4NDMsIm5iZiI6MTc4ODY3ODU0MywicGF0aCI6Ii8yMjA5NzcwMTMvNjQ2ODgxMDMyLWMzODY0NzZlLTIwZDktNDc1NC1hNjYzLWQyMTY1NTkzMzE0OC5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjYwOTA2JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI2MDkwNlQwNzA5MDNaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT04NmM3N2NkNjM2NmY5NjgyNWVhMzcxMDg4MzM2YmZiM2UzNjc1ODI0MGMyYThjZmE4MzZlMjVhZWVlYjlmYmYyJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZyZXNwb25zZS1jb250ZW50LXR5cGU9aW1hZ2UlMkZwbmcifQ.dnHBLtJav-eHyvcQd_pviShoOa8SNJlXLbAST7OdW8k)

### 输出结果
![完整workflow](https://private-user-images.githubusercontent.com/220977013/646881312-199b2961-98d7-4ba3-8d86-e9a9ba6c5c58.mp4?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3ODg2NzkwNDUsIm5iZiI6MTc4ODY3ODc0NSwicGF0aCI6Ii8yMjA5NzcwMTMvNjQ2ODgxMzEyLTE5OWIyOTYxLTk4ZDctNGJhMy04ZDg2LWU5YTliYTZjNWM1OC5tcDQ_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjYwOTA2JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI2MDkwNlQwNzEyMjVaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT00ZTE2OGZhYzI5OTRiZTM1ODk2M2MyMzM1YmY0ZTdmM2M0OGIyMzdmOWZmNWM2MWE2NzAyNzNhMjM2ODAxYzM1JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZyZXNwb25zZS1jb250ZW50LXR5cGU9dmlkZW8lMkZtcDQifQ.NFKcaxwesKEy9b3KYK2mkJuDmymqjjhxAkJDNLaq8u8)