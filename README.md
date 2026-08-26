# yue_learn

## Windows build verification

- The project passes the full Dart analysis and Flutter test suite on Windows.
- Android release builds are supported. If Flutter's AOT compiler still fails in a workspace with non-ASCII characters, use an ASCII checkout path such as `C:\src\yue_learn` and run `flutter build apk --release` or `flutter build appbundle --release`.
- Web release builds are supported and should be served over HTTP for verification (for example, `http://127.0.0.1:4174/`).
- Windows desktop packaging requires Visual Studio with the `Desktop development with C++` workload; it is not installed in the current environment.

## iOS / iPad 发布

- iOS 工程已配置 iPhone 与 iPad（`TARGETED_DEVICE_FAMILY = 1,2`），最低版本为 iOS 13.0，并保留横竖屏支持。
- 发音跟读需要麦克风权限；`Info.plist` 已加入系统权限说明。
- macOS/Xcode 下的分析、测试、无签名及 Apple Development 签名 Release 构建，以及 iPhone/iPad 模拟器安装与启动均已通过。
- App Store Distribution 签名的 1.0.0 build 4 IPA 已生成并通过签名/profile 校验，可直接提交 TestFlight。
- 真机安装、录音和 TestFlight 仍需已连接设备及 App Store 分发配置；运行 `./scripts/ios_release_preflight.sh` 可重复执行发布预检。
- App Bundle ID：`com.yuelearn.yueLearn`。正式上架仍需配置 Apple Developer Team、证书、Provisioning Profile，以及 App Store Connect 的支付与隐私信息。
- 详细步骤与验收矩阵见 [iOS / iPadOS 发布交接](docs/ios-release.md)。

粤讲粤易——面向普通话母语者的港式粤语学习 App。

当前 MVP 的主线是“最快开口”：用户从首页进入“今天先开口”，用 5 分钟完成 3 句高频粤语的听读、跟读和复习，再进入完整场景课程。系统语音明确使用 `zh-HK` 粤语，不依赖仓库里旧的静音占位音频。

## 本地运行

这是一个 Flutter MVP。课程内容和学习进度默认使用本地数据，AI 教练和发音评估属于可选能力。

如需启用外部服务，请通过编译参数配置。Qwen 在生产环境应使用服务端代理，
不要把 Qwen 密钥打进正式客户端：

```bash
# 开发环境直连 Qwen（仅用于本地调试）
flutter run --dart-define=QWEN_API_KEY=your_qwen_key --dart-define=AZURE_SPEECH_KEY=your_azure_key --dart-define=AZURE_SPEECH_REGION=eastasia

# 生产环境：使用服务端代理，不传 QWEN_API_KEY / AZURE_SPEECH_KEY
flutter build web --dart-define=AI_PROXY_BASE_URL=https://api.example.com/ai/chat/completions --dart-define=AZURE_SPEECH_PROXY_URL=https://api.example.com/ai/pronunciation
```

代理负责上游 Qwen/Azure 鉴权、用户身份校验、限流和成本控制。AI 代理需兼容 OpenAI Chat Completions；发音代理需接受 WAV POST 和 `Pronunciation-Assessment` 请求头，并返回 Azure 兼容 JSON。

## 主要功能

- 场景化课程：餐饮、交通、购物、职场，共 12 个场景。
- 粤语汉字、粤拼、普通话、逐词拆解和本地音频。
- 场景完成后自动把词汇加入 SRS 复习队列。
- 录音跟读和 Azure 发音评估。
- AI 教练「阿明」对话、纠错和复盘。
- 阿明语音输入、粤语语音回复，以及 5 个高频生存场景的分支角色扮演。
- 入门诊断和持久化的 7 天开口计划。
- Hive 本地保存学习进度、复习卡片和试用状态。

## 当前限制

- 支付服务仍是本地试用状态，尚未接入 App Store 或 Google Play 收据验证。
- AI 和发音服务需要配置外部服务；未配置时使用离线提示。生产环境应分别配置 `AI_PROXY_BASE_URL` 和 `AZURE_SPEECH_PROXY_URL`。
- `AI_PROXY_BASE_URL` 需要兼容 OpenAI Chat Completions；`AZURE_SPEECH_PROXY_URL` 接收 16kHz WAV 和 `Pronunciation-Assessment` 请求头。两个代理都必须在服务端保存上游密钥，不能把密钥打进 IPA。
- 未配置代理时，阿明仍可运行本地分支角色扮演；录音按钮会提示无法进行云端识别，不会伪造评分。
- Web 端暂不支持本地录音评分，移动端和桌面端可使用录音功能。
