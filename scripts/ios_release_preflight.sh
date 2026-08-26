#!/usr/bin/env bash

set -euo pipefail

require_signing=false
if [[ "${1:-}" == "--require-signing" ]]; then
  require_signing=true
elif [[ -n "${1:-}" ]]; then
  echo "用法: $0 [--require-signing]" >&2
  exit 64
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project_dir="$(cd "${script_dir}/.." && pwd)"
cd "${project_dir}"

for command_name in flutter xcodebuild plutil security; do
  if ! command -v "${command_name}" >/dev/null 2>&1; then
    echo "缺少命令: ${command_name}" >&2
    exit 1
  fi
done

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "iOS 发布预检必须在 macOS 上运行。" >&2
  exit 1
fi

plutil -lint ios/Runner/Info.plist
lock_host="$(awk '/url:/{gsub(/[\"[:space:]]/, "", $2); print $2; exit}' pubspec.lock)"
PUB_HOSTED_URL="${PUB_HOSTED_URL:-${lock_host}}" flutter pub get
flutter analyze
flutter test
flutter build ios --release --no-codesign

app_path="build/ios/iphoneos/Runner.app"
if [[ ! -d "${app_path}" ]]; then
  app_path="build/ios/Release-iphoneos/Runner.app"
fi
if [[ ! -d "${app_path}" ]]; then
  echo "未找到 iOS Release App。" >&2
  exit 1
fi

bundle_id="$(plutil -extract CFBundleIdentifier raw "${app_path}/Info.plist")"
minimum_ios="$(plutil -extract MinimumOSVersion raw "${app_path}/Info.plist")"
device_family="$(plutil -extract UIDeviceFamily json -o - "${app_path}/Info.plist")"

if [[ "${bundle_id}" != "com.yuelearn.yueLearn" ]]; then
  echo "Bundle ID 不符合预期: ${bundle_id}" >&2
  exit 1
fi
if [[ "${minimum_ios}" != "13.0" ]]; then
  echo "最低 iOS 版本不符合预期: ${minimum_ios}" >&2
  exit 1
fi
if [[ "${device_family}" != *"1"* || "${device_family}" != *"2"* ]]; then
  echo "构建产物没有同时包含 iPhone 与 iPad 设备族: ${device_family}" >&2
  exit 1
fi

identity_count="$(security find-identity -v -p codesigning | tail -n 1 | awk '{print $1}')"
identity_count="${identity_count:-0}"

echo "iOS 无签名预检通过：${bundle_id}，最低 iOS ${minimum_ios}，设备族 ${device_family}。"
if [[ "${identity_count}" == "0" ]]; then
  echo "未发现有效 Apple 代码签名身份。真机安装和 App Store 归档仍需在 Xcode 中登录开发者账号。" >&2
  if [[ "${require_signing}" == "true" ]]; then
    exit 2
  fi
else
  echo "发现 ${identity_count} 个有效代码签名身份。"
fi
