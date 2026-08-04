"""
Azure TTS 音频批量生成脚本
使用 Azure Cognitive Services Text-to-Speech 生成粤语课程音频

用法:
  1. 设置环境变量 AZURE_SPEECH_KEY 和 AZURE_SPEECH_REGION
  2. python scripts/generate_audio.py

免费额度: 每月 50 万字符 (Neural voice)
粤语语音: zh-HK-HiuGaaiNeural (女声) / zh-HK-WanLungNeural (男声)
"""

import os
import sys
import time
import json
import hashlib
import requests
from pathlib import Path

# ==================== 配置 ====================

AZURE_SPEECH_KEY = os.environ.get("AZURE_SPEECH_KEY", "YOUR_KEY_HERE")
AZURE_SPEECH_REGION = os.environ.get("AZURE_SPEECH_REGION", "eastasia")
VOICE_NAME = "zh-HK-HiuGaaiNeural"  # 粤语女声

# 输出目录
ASSETS_DIR = Path(__file__).parent.parent / "assets" / "audio"

# ==================== 课程音频数据 ====================

# 场景对话句子 - 由 dart 数据提取或手动维护
SENTENCES = {
    # === 餐饮: 茶餐厅点餐 ===
    "dining/d1_1_s1": "唔該，我要一個A餐。",
    "dining/d1_1_s2": "餐飲要熱奶茶，走甜唔該。",
    "dining/d1_1_s3": "A餐，熱奶茶走甜。即刻到。",
    "dining/d1_1_s4": "唔好意思，要份公司三文治，飛邊。",
    "dining/d1_1_s5": "收到。公司治飛邊，轉頭到。",
    "dining/d1_2_s1": "唔該，埋單。",
    "dining/d1_2_s2": "多謝，一共六十八蚊。",
    "dining/d1_2_s3": "俾張一百蚊你。",
    "dining/d1_2_s4": "找返三十二蚊，多謝晒。",
    # 生词
    "dining/v_d1_1": "唔該",
    "dining/v_d1_2": "走甜",
    "dining/v_d1_3": "飛邊",
    "dining/v_d1_4": "即刻",
    "dining/v_d1_5": "埋單",
    "dining/v_d1_6": "蚊",
    "dining/v_d1_7": "俾",
    "dining/v_d1_8": "找返",
    "dining/v_d1_9": "多謝",
    "dining/v_d1_10": "轉頭",

    # === 餐饮: 酒楼饮茶 ===
    "dining/d2_1_s1": "唔該，三位。",
    "dining/d2_1_s2": "三位，等下就有枱㗎喇。",
    "dining/d2_1_s3": "唔該，想飲咩茶？普洱定香片？",
    "dining/d2_1_s4": "普洱吖，唔該。",
    "dining/d2_2_s1": "整籠蝦餃同燒賣吖。",
    "dining/d2_2_s2": "好，仲有冇其他？",
    "dining/d2_2_s3": "加多碟腸粉，要牛肉嘅。",
    "dining/d2_2_s4": "夠唔夠食呀？要唔要嗌多個炒飯？",
    "dining/v_d2_1": "枱",
    "dining/v_d2_2": "咩",
    "dining/v_d2_3": "定",
    "dining/v_d2_4": "整",
    "dining/v_d2_5": "同",
    "dining/v_d2_6": "仲",
    "dining/v_d2_7": "加多",
    "dining/v_d2_8": "嘅",
    "dining/v_d2_9": "嗌",
    "dining/v_d2_10": "夠食",

    # === 餐饮: 街市买菜 ===
    "dining/d3_1_s1": "阿姐，呢個菜心幾錢斤呀？",
    "dining/d3_1_s2": "十二蚊斤，好新鮮㗎，今朝先返貨。",
    "dining/d3_1_s3": "平啲得唔得呀？十蚊斤啦。",
    "dining/d3_1_s4": "好啦好啦，十蚊俾你。要多啲嚟幫襯喎！",
    "dining/d3_1_s5": "唔該晒，再要半斤瘦肉。",
    "dining/v_d3_1": "幾錢",
    "dining/v_d3_2": "斤",
    "dining/v_d3_3": "平啲",
    "dining/v_d3_4": "得唔得",
    "dining/v_d3_5": "今朝",
    "dining/v_d3_6": "返貨",
    "dining/v_d3_7": "嚟",
    "dining/v_d3_8": "幫襯",
    "dining/v_d3_9": "唔該晒",
    "dining/v_d3_10": "瘦肉",

    # === 交通: 搭港铁 ===
    "transport/t1_1_s1": "唔好意思，去旺角點樣搭車呀？",
    "transport/t1_1_s2": "你搭荃灣綫，兩個站就到㗎喇。",
    "transport/t1_1_s3": "使唔使轉車㗎？",
    "transport/t1_1_s4": "唔使轉車，直達㗎。",
    "transport/t1_2_s1": "唔該，想增值一百蚊。",
    "transport/t1_2_s2": "得，拍卡呢度。",
    "transport/v_t1_1": "點樣",
    "transport/v_t1_2": "搭車",
    "transport/v_t1_3": "站",
    "transport/v_t1_4": "使唔使",
    "transport/v_t1_5": "轉車",
    "transport/v_t1_6": "唔使",
    "transport/v_t1_7": "增值",
    "transport/v_t1_8": "拍卡",
    "transport/v_t1_9": "呢度",
    "transport/v_t1_10": "直達",

    # === 交通: 搭巴士 ===
    "transport/t2_1_s1": "呢架巴士去唔去銅鑼灣㗎？",
    "transport/t2_1_s2": "去㗎，上車拍卡啦。",
    "transport/t2_1_s3": "司機唔該，下個站有落。",
    "transport/t2_2_s1": "司機，前面街口有落呀！",
    "transport/t2_2_s2": "收到。落車小心呀。",
    "transport/t2_2_s3": "幾多錢呀？",
    "transport/t2_2_s4": "八個半，唔該。",
    "transport/v_t2_1": "有落",
    "transport/v_t2_2": "街口",
    "transport/v_t2_3": "落車",
    "transport/v_t2_4": "八個半",
    "transport/v_t2_5": "小心",

    # === 交通: 搭的士 ===
    "transport/t3_1_s1": "司機，去中環IFC唔該。",
    "transport/t3_1_s2": "好，過海定行紅隧？",
    "transport/t3_1_s3": "紅隧啦，快啲。",
    "transport/t3_1_s4": "唔該喺呢度停得喇。幾多錢？",
    "transport/t3_1_s5": "八十六蚊吖。有冇散紙？",
    "transport/v_t3_1": "過海",
    "transport/v_t3_2": "紅隧",
    "transport/v_t3_3": "喺",
    "transport/v_t3_4": "散紙",
    "transport/v_t3_5": "快啲",

    # === 购物: 超市 ===
    "shopping/s1_1_s1": "唔該，有冇會員卡呀？",
    "shopping/s1_1_s2": "冇呀。使唔使膠袋？",
    "shopping/s1_1_s3": "要吖。幾多錢？",
    "shopping/s1_1_s4": "膠袋五毫子。一共一百二十三蚊。",
    "shopping/v_s1_1": "會員卡",
    "shopping/v_s1_2": "膠袋",
    "shopping/v_s1_3": "毫子",
    "shopping/v_s1_4": "有冇",
    "shopping/v_s1_5": "買二送一",

    # === 购物: 商场 ===
    "shopping/s2_1_s1": "呢件衫有冇大碼呀？",
    "shopping/s2_1_s2": "有，試身室喺嗰邊。",
    "shopping/s2_1_s3": "而家有幾多折呀？",
    "shopping/s2_1_s4": "而家做緊七折，好抵㗎！",
    "shopping/v_s2_1": "大碼",
    "shopping/v_s2_2": "試身室",
    "shopping/v_s2_3": "嗰邊",
    "shopping/v_s2_4": "而家",
    "shopping/v_s2_5": "好抵",
    "shopping/v_s2_6": "做緊",
    "shopping/v_s2_7": "件",

    # === 购物: 药房 ===
    "shopping/s3_1_s1": "唔該，有冇傷風感冒藥？",
    "shopping/s3_1_s2": "有，想要藥丸定藥水？",
    "shopping/s3_1_s3": "藥丸啦。一日食幾多次？",
    "shopping/s3_1_s4": "一日三次，每次兩粒，飽肚食。",
    "shopping/v_s3_1": "傷風感冒",
    "shopping/v_s3_2": "藥丸",
    "shopping/v_s3_3": "藥水",
    "shopping/v_s3_4": "粒",
    "shopping/v_s3_5": "飽肚",

    # === 职场: 自我介绍 ===
    "workplace/w1_1_s1": "你好，我係陳大明，叫我阿明得喇。",
    "workplace/w1_1_s2": "阿明你好！我係李經理。你邊度做嘢㗎？",
    "workplace/w1_1_s3": "我喺中環返工，做市場推廣嘅。",
    "workplace/w1_1_s4": "好呀，以後多多指教。",
    "workplace/v_w1_1": "我係",
    "workplace/v_w1_2": "邊度",
    "workplace/v_w1_3": "做嘢",
    "workplace/v_w1_4": "返工",
    "workplace/v_w1_5": "多多指教",
    "workplace/v_w1_6": "得喇",

    # === 职场: 开会 ===
    "workplace/w2_1_s1": "我認為呢個方案可以試下。",
    "workplace/w2_1_s2": "不如我哋再傾傾先決定？",
    "workplace/w2_1_s3": "有冇問題想提出㗎？",
    "workplace/w2_1_s4": "大致上冇問題，可以開始做㗎喇。",
    "workplace/v_w2_1": "我認為",
    "workplace/v_w2_2": "不如",
    "workplace/v_w2_3": "我哋",
    "workplace/v_w2_4": "傾",
    "workplace/v_w2_5": "大致上",
    "workplace/v_w2_6": "試下",

    # === 职场: 电话 ===
    "workplace/w3_1_s1": "喂，請問係咪張生呀？",
    "workplace/w3_1_s2": "佢而家唔喺度喎，你留個口訊好唔好？",
    "workplace/w3_1_s3": "好呀，麻煩叫佢轉頭打返俾我吖。",
    "workplace/w3_1_s4": "一定。拜拜！",
    "workplace/v_w3_1": "係咪",
    "workplace/v_w3_2": "佢",
    "workplace/v_w3_3": "唔喺度",
    "workplace/v_w3_4": "口訊",
    "workplace/v_w3_5": "打返",
    "workplace/v_w3_6": "轉頭",
    "workplace/v_w3_7": "張生",
}


def get_access_token(key: str, region: str) -> str:
    """获取 Azure Speech API 访问令牌"""
    url = f"https://{region}.api.cognitive.microsoft.com/sts/v1.0/issueToken"
    resp = requests.post(
        url,
        headers={
            "Ocp-Apim-Subscription-Key": key,
            "Content-Type": "application/x-www-form-urlencoded",
        },
        timeout=10,
    )
    resp.raise_for_status()
    return resp.text


def generate_audio(
    token: str, region: str, text: str, output_path: Path
) -> bool:
    """使用 SSML 生成单个音频文件"""
    ssml = f"""
    <speak version='1.0' xmlns='http://www.w3.org/2001/10/synthesis' xml:lang='zh-HK'>
        <voice name='{VOICE_NAME}'>
            <prosody rate='0.9' pitch='+0%'>
                {text}
            </prosody>
        </voice>
    </speak>
    """

    url = f"https://{region}.tts.speech.microsoft.com/cognitiveservices/v1"

    resp = requests.post(
        url,
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/ssml+xml",
            "X-Microsoft-OutputFormat": "audio-16khz-128kbitrate-mono-mp3",
            "User-Agent": "YueLearn",
        },
        data=ssml.encode("utf-8"),
        timeout=30,
    )

    if resp.status_code == 200:
        output_path.parent.mkdir(parents=True, exist_ok=True)
        output_path.write_bytes(resp.content)
        return True
    else:
        print(f"  ❌ Error {resp.status_code}: {resp.text[:200]}")
        return False


def main():
    key = AZURE_SPEECH_KEY
    region = AZURE_SPEECH_REGION

    if key == "YOUR_KEY_HERE":
        print("⚠️  请设置 AZURE_SPEECH_KEY 环境变量")
        print("   export AZURE_SPEECH_KEY=your_key_here")
        sys.exit(1)

    print(f"🔑 获取 Azure 访问令牌...")
    try:
        token = get_access_token(key, region)
    except Exception as e:
        print(f"❌ 获取令牌失败: {e}")
        sys.exit(1)

    print(f"🎙️  使用语音: {VOICE_NAME}")
    print(f"📂 输出目录: {ASSETS_DIR}")
    print(f"📝 共 {len(SENTENCES)} 个音频文件需要生成\n")

    success = 0
    failed = 0
    total_chars = sum(len(t) for t in SENTENCES.values())

    print(f"总字符数: {total_chars} (免费额度: 500,000/月)")

    for i, (name, text) in enumerate(SENTENCES.items(), 1):
        output_path = ASSETS_DIR / f"{name}.mp3"

        # 跳过已存在的文件
        if output_path.exists():
            print(f"  [{i:3d}/{len(SENTENCES)}] ⏭️  {name} (已存在)")
            success += 1
            continue

        # 限速: 每秒最多 20 个请求 (Azure TTS 限制)
        if i > 1:
            time.sleep(0.1)

        print(f"  [{i:3d}/{len(SENTENCES)}] 🎵 {name}: {text[:20]}...", end=" ")
        ok = generate_audio(token, region, text, output_path)
        if ok:
            print("✅")
            success += 1
        else:
            print("❌")
            failed += 1

    print(f"\n{'='*50}")
    print(f"✅ 成功: {success}")
    print(f"❌ 失败: {failed}")
    print(f"📊 总字符: {total_chars}")


if __name__ == "__main__":
    main()
