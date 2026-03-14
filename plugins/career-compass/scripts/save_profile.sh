#!/bin/bash
# save_profile.sh — オンボーディング後にJSONをdata/profiles/<name>.jsonに保存
# 使用法: bash save_profile.sh '<JSON文字列>'

PROFILES_DIR="${HOME}/.career-compass/profiles"

JSON_INPUT="$1"

if [ -z "${JSON_INPUT}" ]; then
  echo "ERROR: JSON引数が必要です。"
  echo "使用法: bash save_profile.sh '<JSON文字列>'"
  exit 1
fi

# profiles ディレクトリが存在しない場合は作成
mkdir -p "${PROFILES_DIR}"

# Pythonで整形・バリデーション・保存
python3 - "${PROFILES_DIR}" "${JSON_INPUT}" <<'PYEOF'
import sys
import json
from datetime import datetime, timezone

import re
from pathlib import Path

profiles_dir = Path(sys.argv[1])
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

# 名前からファイル名を生成（スペース→アンダースコア、記号除去）
name = data.get("personal", {}).get("name", "profile")
safe_name = re.sub(r'[^\w\u3000-\u9fff\u30a0-\u30ff\u3040-\u309f]', '_', name).strip('_')
profile_path = profiles_dir / f"{safe_name}.json"

# 整形して保存
with open(profile_path, "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print(f"SUCCESS: プロフィールを保存しました → {profile_path}")
print(f"NAME: {name}")
print(f"PROFILE_FILE: {profile_path}")
PYEOF
