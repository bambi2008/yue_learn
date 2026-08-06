# yue_learn

粤讲粤易——面向普通话母语者的港式粤语学习 App。

## 本地运行

这是一个 Flutter MVP。课程内容和学习进度默认使用本地数据，AI 教练和发音评估属于可选能力。

如需启用外部服务，请通过编译参数传入密钥，不要把密钥直接写进源码：

```bash
flutter run --dart-define=QWEN_API_KEY=your_qwen_key --dart-define=AZURE_SPEECH_KEY=your_azure_key --dart-define=AZURE_SPEECH_REGION=eastasia
```

## 主要功能

- 场景化课程：餐饮、交通、购物、职场，共 12 个场景。
- 粤语汉字、粤拼、普通话、逐词拆解和本地音频。
- 场景完成后自动把词汇加入 SRS 复习队列。
- 录音跟读和 Azure 发音评估。
- AI 教练「阿明」对话、纠错和复盘。
- Hive 本地保存学习进度、复习卡片和试用状态。

## 当前限制

- 支付服务仍是本地试用状态，尚未接入 App Store 或 Google Play 收据验证。
- AI 和发音服务需要通过 `--dart-define` 配置密钥；未配置时使用离线提示。
- Web 端暂不支持本地录音评分，移动端和桌面端可使用录音功能。
