#!/bin/bash
# list_profiles.sh — 保存済みプロフィール一覧を表示
# 出力: STATUS: OK/EMPTY, COUNT, FILE/NAME 一覧

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(dirname "${SCRIPT_DIR}")"
PROFILES_DIR="${CLAUDE_PLUGIN_ROOT:-$PLUGIN_ROOT}/data/profiles"

if [ ! -d "${PROFILES_DIR}" ]; then
  echo "STATUS: EMPTY"
  echo "COUNT: 0"
  exit 0
fi

python3 - "${PROFILES_DIR}" <<'PYEOF'
import sys
import json
from pathlib import Path

profiles_dir = Path(sys.argv[1])
files = sorted(profiles_dir.glob("*.json"))

if not files:
    print("STATUS: EMPTY")
    print("COUNT: 0")
    sys.exit(0)

print("STATUS: OK")
print(f"COUNT: {len(files)}")
print(f"PROFILES_DIR: {profiles_dir}")

for i, f in enumerate(files, 1):
    try:
        data = json.loads(f.read_text(encoding="utf-8"))
        name    = data.get("personal", {}).get("name", "（不明）")
        title   = data.get("personal", {}).get("current_title", "")
        updated = data.get("_updated", "")[:10]
        print(f"[{i}] FILE: {f} | NAME: {name} | TITLE: {title} | UPDATED: {updated}")
    except Exception:
        print(f"[{i}] FILE: {f} | NAME: （読み込みエラー）")
PYEOF
