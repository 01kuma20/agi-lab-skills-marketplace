#!/bin/bash
# save_profile.sh — オンボーディング後にJSONをprofile.jsonに保存
# 使用法: bash save_profile.sh '<JSON文字列>'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(dirname "${SCRIPT_DIR}")"
DATA_DIR="${CLAUDE_PLUGIN_ROOT:-$PLUGIN_ROOT}/data"
PROFILE_PATH="${DATA_DIR}/profile.json"

JSON_INPUT="$1"

if [ -z "${JSON_INPUT}" ]; then
  echo "ERROR: JSON引数が必要です。"
  echo "使用法: bash save_profile.sh '<JSON文字列>'"
  exit 1
fi

# data ディレクトリが存在しない場合は作成
mkdir -p "${DATA_DIR}"

# Pythonで整形・バリデーション・保存
python3 - "${PROFILE_PATH}" "${JSON_INPUT}" <<'PYEOF'
import sys
import json
from datetime import datetime, timezone

profile_path = sys.argv[1]
json_input   = sys.argv[2]

try:
    data = json.loads(json_input)
except json.JSONDecodeError as e:
    print(f"ERROR: JSONパースエラー: {e}")
    sys.exit(1)

now_iso = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")

# バージョン・タイムスタンプを付与
data.setdefault("_version", "1.0")
if not data.get("_created"):
    data["_created"] = now_iso
data["_updated"] = now_iso

# 整形して保存
with open(profile_path, "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print(f"SUCCESS: プロフィールを保存しました → {profile_path}")
name = data.get("personal", {}).get("name", "（未設定）")
print(f"NAME: {name}")
PYEOF
