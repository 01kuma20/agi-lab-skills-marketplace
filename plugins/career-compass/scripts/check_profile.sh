#!/bin/bash
# check_profile.sh — data/profiles/ 内のプロフィール存在・充足確認
# 出力: STATUS: OK/PARTIAL/EMPTY, COUNT, プロフィール一覧

PROFILES_DIR="${HOME}/.career-compass/profiles"

# 旧形式 data/profile.json が存在する場合はマイグレーション（キャッシュ内を含む）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(dirname "${SCRIPT_DIR}")"
OLD_PROFILE="${CLAUDE_PLUGIN_ROOT:-$PLUGIN_ROOT}/data/profile.json"
if [ -f "${OLD_PROFILE}" ] && [ ! -d "${PROFILES_DIR}" ]; then
  mkdir -p "${PROFILES_DIR}"
  python3 - "${OLD_PROFILE}" "${PROFILES_DIR}" <<'MIGRATE'
import sys, json, re
from pathlib import Path

old = Path(sys.argv[1])
dst = Path(sys.argv[2])
try:
    data = json.loads(old.read_text(encoding="utf-8"))
    name = data.get("personal", {}).get("name", "profile")
    safe = re.sub(r'[^\w\u3000-\u9fff\u30a0-\u30ff\u3040-\u309f]', '_', name).strip('_')
    (dst / f"{safe}.json").write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"MIGRATED: {old} → {dst}/{safe}.json")
except Exception as e:
    print(f"MIGRATE_ERROR: {e}")
MIGRATE
fi

python3 - "${PROFILES_DIR}" <<'PYEOF'
import sys
import json
from pathlib import Path

profiles_dir = Path(sys.argv[1])

if not profiles_dir.exists():
    print("STATUS: EMPTY")
    print("COUNT: 0")
    print("REASON: プロフィールが見つかりません。オンボーディングを開始します。")
    sys.exit(0)

files = sorted(profiles_dir.glob("*.json"))

if not files:
    print("STATUS: EMPTY")
    print("COUNT: 0")
    print("REASON: プロフィールが見つかりません。オンボーディングを開始します。")
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
