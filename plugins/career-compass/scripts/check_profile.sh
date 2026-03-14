#!/bin/bash
# check_profile.sh — profile.json の存在・充足確認
# 出力: STATUS: OK / PARTIAL / EMPTY

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(dirname "${SCRIPT_DIR}")"
PROFILE_PATH="${CLAUDE_PLUGIN_ROOT:-$PLUGIN_ROOT}/data/profile.json"

# profile.json が存在しない
if [ ! -f "${PROFILE_PATH}" ]; then
  echo "STATUS: EMPTY"
  echo "REASON: profile.json が見つかりません。オンボーディングを開始します。"
  exit 0
fi

# Python3 でJSONを検証・充足確認
python3 - "${PROFILE_PATH}" <<'PYEOF'
import sys
import json

path = sys.argv[1]
try:
    with open(path, "r", encoding="utf-8") as f:
        data = json.load(f)
except Exception as e:
    print("STATUS: EMPTY")
    print(f"REASON: JSONパースエラー: {e}")
    sys.exit(0)

missing = []

# 必須フィールドチェック
personal = data.get("personal", {})
if not personal.get("name"):
    missing.append("personal.name")
if not personal.get("current_title"):
    missing.append("personal.current_title")
if not personal.get("years_of_experience") and personal.get("years_of_experience") != 0:
    missing.append("personal.years_of_experience")

skills = data.get("skills", {})
if not skills.get("technical"):
    missing.append("skills.technical")

work_history = data.get("work_history", [])
if not work_history:
    missing.append("work_history")

education = data.get("education", [])
if not education or not education[0].get("institution"):
    missing.append("education")

preferences = data.get("preferences", {})
if not preferences.get("desired_role"):
    missing.append("preferences.desired_role")

if missing:
    print("STATUS: PARTIAL")
    print(f"MISSING_FIELDS: {', '.join(missing)}")
    print(f"PROFILE_PATH: {path}")
else:
    print("STATUS: OK")
    print(f"PROFILE_PATH: {path}")
    # プロフィールサマリー表示
    print(f"NAME: {personal.get('name', '')}")
    print(f"TITLE: {personal.get('current_title', '')}")
    print(f"EXPERIENCE: {personal.get('years_of_experience', 0)}年")
    tech = skills.get("technical", [])
    print(f"TECH_SKILLS: {', '.join(tech[:5])}")
PYEOF
