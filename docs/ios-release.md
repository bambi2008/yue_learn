# iOS / iPadOS 发布交接

## 当前验证状态

截至 2026-08-16，`codex/mvp-stabilization` 已在 macOS、Flutter 3.44.8、Xcode 26.6 下完成：

- `flutter analyze`：通过。
- `flutter test`：通过。
- iOS Release 无签名构建：通过，产物为 arm64。
- Apple Development 签名 Release 构建：通过；签名完整性校验通过。
- App Store Distribution 签名 IPA（build 4）：通过；`beta-reports-active=true`、`get-task-allow=false`，可提交 TestFlight。
- Bundle ID：`com.yuelearn.yueLearn`。
- 最低系统：iOS 13.0。
- `UIDeviceFamily`：同时包含 iPhone（1）和 iPad（2）。
- iPhone 17 Pro（iOS 26.5 模拟器）：安装、启动和首屏渲染通过。
- iPad Pro 13-inch M5（iOS 26.5 模拟器）：安装、启动和宽屏首屏渲染通过。
- 麦克风权限说明、横竖屏配置和 App 图标已进入构建产物。
- App Store 图标与启动图已替换为正式品牌资源，build 3 不再报告 Flutter 默认占位资源警告。

尚未完成的外部依赖：

- 当前 Mac 有 1 个有效 Apple Development 身份及 Xcode 管理的开发描述文件，但尚未验证 Apple Distribution / App Store 描述文件。
- 当前已发现并配对 iPhone 13（iOS 26.6，开发者模式已开启）；Build 8 已安装，但首次启动被系统拦截为“开发者尚未明确信任”，需要在 iPhone 的“设置 > 通用 > VPN 与设备管理”信任开发者后才能完成录音和权限弹窗验证。
- App 内购买尚未接入 StoreKit；在完成商品、收据验证和恢复购买前不能把当前购买入口作为正式付费能力上架。
- 正式环境仍需提供 AI 与发音代理地址、隐私政策 URL、支持 URL 和 App Store Connect 隐私问卷答案。

## 一键预检

在仓库根目录运行：

```bash
./scripts/ios_release_preflight.sh
```

该命令会检查 plist、依赖、静态分析、测试和无签名 Release 构建。签名账号配置完成后，可强制要求存在有效签名身份：

```bash
./scripts/ios_release_preflight.sh --require-signing
```

当前开发描述文件有效期至 2027-07-09，包含 1 台已注册设备，但执行验证时设备没有连接。该描述文件仅用于开发安装，不能代替 App Store 分发签名。

## 签名与真机安装

1. 用 Xcode 打开 `ios/Runner.xcworkspace`。
2. 在 Xcode Settings > Accounts 登录有权限的 Apple Developer 账号。
3. 选择 Runner target > Signing & Capabilities，启用 Automatically manage signing，并选择正确 Team。
4. 确认 App ID `com.yuelearn.yueLearn` 在 Apple Developer 后台可用；若已被其他账号占用，先确定正式 Bundle ID，再同步修改项目和 App Store Connect。
5. 用数据线或已配对的无线连接接入 iPhone 和 iPad，信任此 Mac，并在设备上启用 Developer Mode。
6. 分别选择 iPhone 与 iPad 运行 Release 配置，确认签名、安装和启动成功。

真机验收至少覆盖：

- 首次启动、试用入口、课程进入、学习进度持久化和重启恢复。
- 本地课程音频播放；静音模式、耳机和扬声器切换。
- 首次录音权限弹窗、允许/拒绝两条路径、录音文件生成和发音评分。
- AI/发音代理已配置、未配置、超时和断网状态。
- iPhone 竖屏与横屏；iPad 竖屏、横屏、分屏和窗口缩放。
- Dynamic Type、深色外观、中文显示、低电量和弱网。
- 试用到期、购买、恢复购买和跨设备恢复；StoreKit 接入前此项应标记为发布阻塞。

## Archive 与 TestFlight

签名可用且真机冒烟通过后，使用递增的 build number 归档：

```bash
flutter build ipa \
  --release \
  --export-method app-store \
  --build-name 1.0.0 \
  --build-number <递增数字> \
  --dart-define=AI_PROXY_BASE_URL=https://example.com/ai/chat/completions \
  --dart-define=AZURE_SPEECH_PROXY_URL=https://example.com/ai/pronunciation \
  --dart-define=AZURE_TTS_PROXY_URL=https://example.com/ai/tts
```

不要把 Qwen 或 Azure 密钥通过 `--dart-define` 打入正式客户端。上传前检查 Archive 中的版本、签名 Team、Bundle ID、图标、隐私清单和 dSYM；随后先发 TestFlight Internal Testing，按上面的真机矩阵复验。

本次已生成并验证 `build/ios/ipa/yue_learn.ipa`（版本 1.0.0，build 8）。Build 8 使用内部测试开关绕过本地试用支付墙，包含语音输入、分支角色扮演和 7 天计划，适合 TestFlight 内部测试，不代表正式生产包的付费逻辑已完成。上传需要 App Store Connect API key 或已登录的 Transporter；本机已将该包载入 Transporter，等待交付上传。

内部测试构建命令：

```bash
flutter build ipa \
  --release \
  --export-method app-store \
  --build-name 1.0.0 \
  --build-number <递增数字> \
  --dart-define=INTERNAL_TEST_ACCESS=true
```

正式生产构建不要传 `INTERNAL_TEST_ACCESS=true`；在 StoreKit 商品、交易监听、收据验证和恢复购买完成前，不要把正式包提交为可购买版本。

语音交流闭环构建需要同时传入两个服务端代理地址：

```bash
flutter build ipa \
  --release \
  --export-method app-store \
  --build-name 1.0.0 \
  --build-number <递增数字> \
  --dart-define=INTERNAL_TEST_ACCESS=true \
  --dart-define=AI_PROXY_BASE_URL=https://<your-domain>/ai/chat/completions \
  --dart-define=AZURE_SPEECH_PROXY_URL=https://<your-domain>/ai/pronunciation \
  --dart-define=AZURE_TTS_PROXY_URL=https://<your-domain>/ai/tts
```

未提供真实代理地址时，Build 仍可用于离线角色扮演和 iPhone 系统粤语 TTS；阿明语音输入、Azure 发音评分和 Azure Neural TTS 不会显示为已接通。

使用 API key 上传：

```bash
xcrun altool --upload-app \
  --type ios \
  --file build/ios/ipa/yue_learn.ipa \
  --apiKey <KEY_ID> \
  --apiIssuer <ISSUER_ID>
```

或在 Transporter 中拖入 `build/ios/ipa/yue_learn.ipa`。上传完成后，在 App Store Connect 的 TestFlight > Builds 等待处理完成，再添加 Internal Testers。

## App Store Connect 准备

- 建立 App 记录，Bundle ID 与 Xcode 保持一致。
- 准备 iPhone 与 iPad 截图、名称、副标题、描述、关键词、分类、年龄分级和审核备注。
- 提供隐私政策 URL 与支持 URL；如需审核登录或代理测试账号，在审核备注中提供。
- 根据真实数据流填写隐私问卷：录音音频、发音文本和 AI 对话是否发送到服务端、是否与身份关联、保留多久、如何删除。
- 若保留 ¥68 买断，先在 App Store Connect 建立 non-consumable IAP，并实现购买、恢复购买、交易监听、服务端验证和退款/撤销处理。
- 完成 Export Compliance。项目声明不使用非豁免加密；若后续加入自定义密码学或 VPN 等能力，必须重新评估。
