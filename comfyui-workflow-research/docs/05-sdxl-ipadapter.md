# 05. SDXL + IPAdapter 实验

[返回首页](../README.md)

## 一、实验目的

本阶段主要研究 **IPAdapter** 在 SDXL 图像生成中的作用，并通过调整 `weight` 进行对照实验，观察参考图对最终生成结果的影响。

本实验重点理解：

> **IPAdapter 如何利用参考图控制生成内容，以及它与 ControlNet 的区别。**

---

# 二、IPAdapter 与 ControlNet 的区别

| 维度 | ControlNet（Scribble） | IPAdapter |
|---|---|---|
| **控制什么** | 结构 / 轮廓（草图骨架） | 内容 / 特征（人脸、风格、物体） |
| **参考图作用** | “请按这个形状画” | “请画得像这张图” |
| **预处理** | 需要（ScribblePreprocessor） | 不需要（直接使用原图） |
| **依赖模型** | ControlNet 专用模型 | CLIP Vision + IPAdapter 模型 |
| **主要注入位置** | CONDITIONING | MODEL |

可以简单理解为：

```text
ControlNet：
参考图 → 提取结构 → 控制“怎么摆”

IPAdapter：
参考图 → 提取视觉特征 → 控制“长什么样”
```

---


# 四、模型准备

## 1. 下载 SDXL 基础版 IPAdapter

创建模型目录：

```bash
mkdir -p models/ipadapter
```

下载 SDXL IPAdapter：

```bash
wget -O models/ipadapter/ip-adapter_sdxl_vit-h.safetensors \
https://hf-mirror.com/h94/IP-Adapter/resolve/main/sdxl_models/ip-adapter_sdxl_vit-h.safetensors
```

---

## 2. 下载 CLIP Vision 编码器

下载约 1.2 GB 的 CLIP Vision 模型：

```bash
wget https://hf-mirror.com/h94/IP-Adapter/resolve/main/models/image_encoder/model.safetensors \
-O CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors
```

CLIP Vision 负责将参考图转换成视觉特征。


# 五、Workflow 准备

本次实验参考：

```text
ip-adapter-sdxl.json
```

来源：

```text
https://github.com/aimpowerment/comfyui-workflows/blob/main/ip-adapter-sdxl.json
```

但是需要注意：

> 该 JSON 使用的是旧版本的 `IPAdapterApply` 节点。

当前已经安装新版：

```text
ComfyUI_IPAdapter_plus
```

因此需要将旧版：

```text
IPAdapterApply
```

替换为新版：

```text
IPAdapter Advanced
```

# 七、修改权重实验

## 实验目标

本次实验采用控制变量法：

> **固定其他参数，只改变 IPAdapter 的 `weight`。**

这样可以观察：

> IPAdapter 的参考图影响强度与最终结果之间的关系。


# 八、完整workflow

![完整workflow](https://private-user-images.githubusercontent.com/220977013/646879079-66cca02b-a854-44dd-afc5-15ed172b0e78.png?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3ODg2ODAwNDksIm5iZiI6MTc4ODY3OTc0OSwicGF0aCI6Ii8yMjA5NzcwMTMvNjQ2ODc5MDc5LTY2Y2NhMDJiLWE4NTQtNDRkZC1hZmM1LTE1ZWQxNzJiMGU3OC5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjYwOTA2JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI2MDkwNlQwNzI5MDlaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1hMTVlZTEzYTYwMGM5ZmQyYWY3YzI5MjY0MzA0OGI5ZDIyMTIzM2QzNTkwYzIzYjRjZjU4MDU2YTNhOWMxYmY2JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZyZXNwb25zZS1jb250ZW50LXR5cGU9aW1hZ2UlMkZwbmcifQ.FGCeNKQrB13mmusv1duMnobp5VBRNu6WZuASdDj1nto)


# 九、核心节点

## 3. IPAdapter Advanced

`IPAdapter Advanced` 是本实验的核心节点。

它接收：

### `model`

来自：

```text
Checkpoint Loader
```

即基础模型。

### `image / 视觉特征`

来自：

```text
CLIP Vision
```

即参考图的视觉特征。

### `clip_vision`

来自：

```text
CLIPVisionLoader
```

即 CLIP Vision 编码器。

它的核心作用：

> **将参考图的视觉特征注入 MODEL，使 KSampler 在生成过程中受到参考图视觉信息的影响。**

可以理解为：

> 在模型的“生成过程中加入一张参考图的视觉记忆”。

---

# 十、IPAdapter Weight

IPAdapter 最重要的实验参数之一：

```text
weight
```

它控制：

> **参考图视觉特征的注入强度。**

大致可以理解为：

```text
weight = 0
↓
几乎不参考参考图

weight ↑
↓
越来越受到参考图影响

weight 过高
↓
参考图特征过度侵占
↓
可能出现异常
```

本次实验观察到：

```text
0.0 → 没有参考图影响
0.5 → 参考图开始明显影响结果
1.0 → 相似度较高
1.5 → 结果开始严重异常
```


# 十四、对照实验结果

本实验采用控制变量法。

除 `weight` 外，其余参数全部固定。

| 实验 | weight | 与参考图相似度 | 画面质量 | 观察结果 |
|---|---:|---|---|---|
| A | 0.0 | 1/5（毫无相关性） | 正常 | 基础文生图效果，生成人物与参考图完全无关，证明 Baseline 正确 |
| B | 0.5 | 3/5（还可以） | 正常 | 参考图开始起作用，人物五官和气质向参考图靠拢，但不过度 |
| C | 1.0 | 4/5（还可以，但动作有点不对） | 轻微异常 | 相似度明显提升，但参考图特征开始过度约束，导致动作/姿态出现偏差 |
| D | 1.5 | 2/5（偏了） | 崩坏 | 参考图特征严重侵占生成结果，人物姿态和结构明显异常，进入过拟合区域 |



# 十六、IPAdapter 与 ControlNet 的核心区别

| 维度 | ControlNet（Scribble） | IPAdapter |
|---|---|---|
| 控制对象 | 结构、轮廓、姿态 | 内容、人物特征、风格、物体特征 |
| 参考图含义 | “请按这个形状画” | “请画得像这张图” |
| 预处理 | 需要 `ScribblePreprocessor` | 不需要，直接使用原图 |
| 依赖模型 | ControlNet 专用模型 | CLIP Vision + IPAdapter 模型 |
| 主要注入位置 | `CONDITIONING` | `MODEL` |

> **ControlNet 管“怎么摆”，IPAdapter 管“长什么样”。**

---

# 十七、两者可以组合使用

ControlNet 与 IPAdapter 并不是互斥关系。

可以组合：

```text
ControlNet
    ↓
控制结构 / 姿态 / 骨架

IPAdapter
    ↓
控制人物特征 / 风格 / 内容
```

例如：

```text
Reference Image
       ↓
    IPAdapter
       ↓
控制人物外观
       
Control Image
       ↓
   ControlNet
       ↓
控制人物姿态
       
       ↓
      SDXL
       ↓
最终图片
```

---

# 十八、调研结论

## 1. IPAdapter Weight 存在有效区间

本次实验中：

```text
0.5–1.0
```

整体效果比较平衡。

而：

```text
0.0
```

基本没有参考图影响。

```text
1.5
```

出现明显崩坏。

因此：

> **IPAdapter 并不是权重越高越好，而是存在一个相对合适的有效区间。**


## 3. Weight 升高可能产生“特征侵占”

当：

```text
weight = 1.0
```

时，参考图相似度已经明显提高。

但同时开始出现：

```text
动作 / 姿态偏差
```

当：

```text
weight = 1.5
```

时，甚至出现：

```text
结构异常
```

说明 IPAdapter 的影响并不仅限于：

```text
人物长相
```

还可能逐渐影响：

```text
构图
姿态
结构
```


# 二十、实验截图

### 参考图片
![参考图片](https://private-user-images.githubusercontent.com/220977013/646878174-2847cb25-8ece-4184-8855-9e7b75e2f15e.jpg?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3ODg2ODAwNDksIm5iZiI6MTc4ODY3OTc0OSwicGF0aCI6Ii8yMjA5NzcwMTMvNjQ2ODc4MTc0LTI4NDdjYjI1LThlY2UtNDE4NC04ODU1LTllN2I3NWUyZjE1ZS5qcGc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjYwOTA2JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI2MDkwNlQwNzI5MDlaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT04NWNhZGJmZTE0MWJjNjdkMmI5ZjM1Y2Q1MjE4NDEzMmJmOGIzZTNmMTk1MzdkMTE4NDU2ZWUwNDcxYWE5ZDFiJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZyZXNwb25zZS1jb250ZW50LXR5cGU9aW1hZ2UlMkZqcGVnIn0.uGQZKsrB2NFlrZ8ZN__vZmgFewrWYb4ms8py2I9hfS8)

### weight = 0.0
![IPAdapter weight 0.0](https://private-user-images.githubusercontent.com/220977013/646878064-42efebc3-4fb5-4a65-8e32-354a5391688b.png?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3ODg2ODAwNDksIm5iZiI6MTc4ODY3OTc0OSwicGF0aCI6Ii8yMjA5NzcwMTMvNjQ2ODc4MDY0LTQyZWZlYmMzLTRmYjUtNGE2NS04ZTMyLTM1NGE1MzkxNjg4Yi5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjYwOTA2JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI2MDkwNlQwNzI5MDlaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1jOTg4ZTAzNTM5YzNiYzA0Nzk5MzlmNWNhZWY5NDc0ZmE5N2E3YzRkNmMyMjgzZGZmOWJlYTE0NWJiNjExODcyJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZyZXNwb25zZS1jb250ZW50LXR5cGU9aW1hZ2UlMkZwbmcifQ.t94-bKRawuHYEwg3WbyrbrpEMmUIOu9mGFMt_8GFNps)

### weight = 0.5
![IPAdapter weight 0.5](https://private-user-images.githubusercontent.com/220977013/646878063-f9482b7d-d843-42bd-97a8-434da076ded5.png?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3ODg2ODAwNDksIm5iZiI6MTc4ODY3OTc0OSwicGF0aCI6Ii8yMjA5NzcwMTMvNjQ2ODc4MDYzLWY5NDgyYjdkLWQ4NDMtNDJiZC05N2E4LTQzNGRhMDc2ZGVkNS5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjYwOTA2JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI2MDkwNlQwNzI5MDlaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT0wYjcyYWRmNWRiMTRhYWI0M2MzNzMyM2UzZDkyM2Q4MDNkMWI2NDM3ZGIyZmZjNjcxMDZhOWFjNDFmMTQ3NWI4JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZyZXNwb25zZS1jb250ZW50LXR5cGU9aW1hZ2UlMkZwbmcifQ.TkYzN6nIoq3ysD-Z-QBhGD8nDCW1XI8pATgSxwNj21s)

### weight = 1.0
![IPAdapter weight 1.0](https://private-user-images.githubusercontent.com/220977013/646878065-a89c191f-6d91-4c8e-a333-97e0995fecc6.png?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3ODg2ODAwNDksIm5iZiI6MTc4ODY3OTc0OSwicGF0aCI6Ii8yMjA5NzcwMTMvNjQ2ODc4MDY1LWE4OWMxOTFmLTZkOTEtNGM4ZS1hMzMzLTk3ZTA5OTVmZWNjNi5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjYwOTA2JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI2MDkwNlQwNzI5MDlaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1mYWQyYzg1NzgyNThhYzk2ZDk1Njc0ZTc5NmIyNGY1ZTRlM2RjNmFlOGI2MzhjMGFlYWI0ZGNiNDEwMjhiYzllJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZyZXNwb25zZS1jb250ZW50LXR5cGU9aW1hZ2UlMkZwbmcifQ.V1Ezb_3GrumiMPLAId68VXJ7KT21wB-jT5RZ2aP77y0)

### weight = 1.5
![IPAdapter weight 1.5](https://private-user-images.githubusercontent.com/220977013/646878106-4261dbd0-3375-4f11-8f5b-9e9484f0b6b5.png?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3ODg2ODAwNDksIm5iZiI6MTc4ODY3OTc0OSwicGF0aCI6Ii8yMjA5NzcwMTMvNjQ2ODc4MTA2LTQyNjFkYmQwLTMzNzUtNGYxMS04ZjViLTllOTQ4NGYwYjZiNS5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjYwOTA2JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI2MDkwNlQwNzI5MDlaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT05ODhiOGM4MjU5YmI0NmMyN2VkYmIzNjRiYzA2MmQyM2E5ZDI4MDFkYjU0MGVjNWQyMzVlODEwZTIwODIzNWQxJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZyZXNwb25zZS1jb250ZW50LXR5cGU9aW1hZ2UlMkZwbmcifQ.p4AMRp2OtySLUEYVTTKXLHXsfdW2KX47UefOxeYuwGI)
