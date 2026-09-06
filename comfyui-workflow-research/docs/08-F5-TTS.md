# 09. F5-TTS 语音生成实验

[返回首页](../README.md)

## 一、实验目的

使用 **F5-TTS** 根据一段参考音频的音色，生成指定文本的 AI 语音。

本次实验完成：

> **参考音频 → F5-TTS → 指定文本的 AI 语音**

生成的语音后续可以与 LivePortrait 生成的人物视频进行合成。

---


## 三、安装 F5-TTS

最开始直接安装：

```bash
pip install f5-tts
```

由于服务器的 pip 镜像源存在问题，无法正常找到 F5-TTS。

之后先安装/更新 setuptools：

```bash
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple setuptools>=61.0
```

也使用过：

```bash
pip install -i https://pypi.org/simple setuptools>=61.0
```

完成依赖处理后，F5-TTS 安装成功。

---

## 四、验证 F5-TTS

执行：

```bash
f5-tts_infer-cli --help
```

如果能够正常显示帮助信息，说明 F5-TTS CLI 已经安装成功。

本次使用的主要参数包括：

```text
--model
--ref_audio
--ref_text
--gen_text
--output_dir
--output_file
--device
```

| 参数 | 作用 |
|---|---|
| `--model` | 指定使用的 F5-TTS 模型 |
| `--ref_audio` | 参考音频 |
| `--ref_text` | 参考音频对应的文字 |
| `--gen_text` | 希望 AI 生成的文字 |
| `--output_dir` | 输出目录 |
| `--output_file` | 输出文件名 |
| `--device` | 指定运行设备，例如 GPU |

---

## 五、准备参考音频

原始参考音频随机片段即可

为了让 F5-TTS 更稳定地处理音频，先转换为：

- WAV
- 24000 Hz
- 单声道
- PCM 16-bit

首先创建目录：

```bash
mkdir -p /root/ComfyUI/audio/reference
mkdir -p /root/ComfyUI/audio/tts_output
```

然后执行：

```bash
ffmpeg -i "/root/ComfyUI/audio/tts音频.m4a" \
-ar 24000 \
-ac 1 \
-c:a pcm_s16le \
"/root/ComfyUI/audio/reference/reference.wav"
```

生成：

```text
/root/ComfyUI/audio/reference/reference.wav
```

---

## 六、F5-TTS 核心原理

本次实验使用的是：

> **参考音频 + 参考文本 + 目标文本**

方式。

整体逻辑：

```text
参考音频
   +
参考音频对应的文字
   ↓
 F5-TTS
   ↓
提取/参考说话人的声音特征
   ↓
输入新的目标文本
   ↓
生成新的语音
```

### 1. Reference Audio

参考音频决定 AI 生成语音时所参考的声音特征。

对应参数：

```text
--ref_audio
```

### 2. Reference Text

需要告诉模型参考音频中说了什么。

对应参数：

```text
--ref_text
```

### 3. Generation Text

这是最终希望 AI 说出来的新内容。

对应参数：

```text
--gen_text
```

例如：

```text
你好，这是我的数字人测试视频。
```

---



## 十一、与数字人实验的关系

F5-TTS 在整个数字人实验中负责的是：

> **声音生成**

而不是人物动作生成。

目前整个实验链路：

```text
                    ┌─→ LivePortrait → 人物视频
源人脸 ─────────────┤
                    │
驱动视频 ───────────┘

参考音频 ─→ F5-TTS ─→ AI语音
                       │
                       ↓
                  FFmpeg 合成
                       ↓
                  最终数字人视频
```



## 十二、当前实验的局限

需要注意：

> **F5-TTS 本身不负责唇形同步。**

目前流程实际上是：

```text
LivePortrait
    ↓
根据 Driving Video 生成脸部动作

F5-TTS
    ↓
独立生成声音

FFmpeg
    ↓
把两者合在一起
```

因此：

> 人物的嘴部动作与 F5-TTS 生成的语音内容不一定完全同步。

例如：

```text
人物嘴巴：
根据 Driving Video 的内容运动

AI 声音：
“你好，这是我的数字人测试视频。”
```

如果 Driving Video 原本说的是其他内容，就可能出现：

```text
声音 ≠ 嘴型
```

因此当前实验可以称为：

> **数字人视频 + AI 语音合成**

但还不能严格称为：

> **真正的音频驱动唇形同步数字人**

如果后续继续深入数字人方向，需要增加专门的 **Lip Sync / Talking Head** 实验。

---

## 十三、最终输出结果

![输出结果](https://github-production-user-asset-6210df.s3.amazonaws.com/220977013/646878126-02ffad00-d529-4752-9c6c-e6370fcba892.mp4?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAVCODYLSA53PQK4ZA%2F20260906%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20260906T065944Z&X-Amz-Expires=300&X-Amz-Signature=764f2e7a4f89d6d9249607562ceccde2cf02863aee94a73cf4b6b7f465fc2d32&X-Amz-SignedHeaders=host&response-content-type=video%2Fmp4)

