#!/bin/bash
# check_profile.sh — input/profiles/ 内のプロフィール存在・充足確認
# 出力: STATUS: OK/PARTIAL/EMPTY, COUNT, プロフィール一覧

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(dirname "${SCRIPT_DIR}")}"
PROFILES_DIR="${PLUGIN_ROOT}/input/profiles"

# フォールバック: キャッシュにプロフィールがなければ作業ディレクトリの plugins/career-compass/input/profiles/ を探す
if [ ! -d "${PROFILES_DIR}" ] || [ -z "$(find "${PROFILES_DIR}" -maxdepth 1 -name '*.json' 2>/dev/null)" ]; then
  FALLBACK_DIR="$(pwd)/plugins/career-compass/input/profiles"
  if [ -d "${FALLBACK_DIR}" ] && [ -n "$(find "${FALLBACK_DIR}" -maxdepth 1 -name '*.json' 2>/dev/null)" ]; then
    PROFILES_DIR="${FALLBACK_DIR}"
  fi
fi

python3 - "${PROFILES_DIR}" <<'PYEOF'
import sys
import json
from pathlib import Path

profiles_dir = Path(sys.argv[1])

if not profiles_dir.exists():
    print("STATUS: EMPTY")
    print("COUNT: 0")
    print("REASON: プロフィールが見つかりません。input/profiles/ にプロフィールJSONを配置してください。")
    sys.exit(0)

files = sorted(profiles_dir.glob("*.json"))

if not files:
    print("STATUS: EMPTY")
    print("COUNT: 0")
    print("REASON: プロフィールが見つかりません。input/profiles/ にプロフィールJSONを配置してください。")
    sys.exit(0)

def validate(data):
    missing = []
    personal = data.get("personal", {})
    if not personal.get("name"):           missing.append("personal.name")
    if not personal.get("current_title"):  missing.append("personal.current_title")
    if not personal.get("years_of_experience") and personal.get("years_of_experience") != 0:
        missing.append("personal.years_of_experience")
    if not data.get("skills", {}).get("technical"):  missing.append("skills.technical")
    if not data.get("work_history"):                 missing.append("work_history")
    edu = data.get("education", [])
    if not edu or not edu[0].get("institution"):     missing.append("education")
    if not data.get("preferences", {}).get("desired_role"): missing.append("preferences.desired_role")
    return missing

print(f"COUNT: {len(files)}")
print(f"PROFILES_DIR: {profiles_dir}")

for i, f in enumerate(files, 1):
    try:
        data = json.loads(f.read_text(encoding="utf-8"))
        missing = validate(data)
        status = "PARTIAL" if missing else "OK"
        personal = data.get("personal", {})
        name    = personal.get("name", "（不明）")
        title   = personal.get("current_title", "")
        updated = data.get("_updated", "")[:10]
        tech    = data.get("skills", {}).get("technical", [])
        print(f"[{i}] STATUS: {status} | FILE: {f} | NAME: {name} | TITLE: {title} | UPDATED: {updated} | TECH: {', '.join(tech[:3])}")
        if missing:
            print(f"    MISSING: {', '.join(missing)}")
    except Exception as e:
        print(f"[{i}] STATUS: ERROR | FILE: {f} | ERROR: {e}")
PYEOF
