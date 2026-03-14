#!/bin/bash
# list_resumes.sh — 保存済み職務経歴書一覧を表示
# 出力: STATUS: OK/EMPTY, COUNT, FILE 一覧

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(dirname "${SCRIPT_DIR}")"
RESUMES_DIR="${CLAUDE_PLUGIN_ROOT:-$PLUGIN_ROOT}/data/resumes"

if [ ! -d "${RESUMES_DIR}" ]; then
  echo "STATUS: EMPTY"
  echo "COUNT: 0"
  exit 0
fi

python3 - "${RESUMES_DIR}" <<'PYEOF'
import sys
import re
from pathlib import Path

resumes_dir = Path(sys.argv[1])
files = sorted(resumes_dir.glob("resume_*.md"), reverse=True)  # 新しい順

if not files:
    print("STATUS: EMPTY")
    print("COUNT: 0")
    sys.exit(0)

print("STATUS: OK")
print(f"COUNT: {len(files)}")
print(f"RESUMES_DIR: {resumes_dir}")

for i, f in enumerate(files, 1):
    # ファイル名から情報を抽出（例: resume_熊谷颯人_20260314.md）
    stem = f.stem  # resume_熊谷颯人_20260314
    parts = stem.split("_", 2)  # ["resume", "熊谷颯人", "20260314"] or ["resume", "20260314"]
    if len(parts) == 3:
        name = parts[1]
        date = parts[2]
    elif len(parts) == 2:
        name = "（不明）"
        date = parts[1]
    else:
        name = "（不明）"
        date = ""

    # 先頭行（タイトル周辺）からサマリー取得
    try:
        lines = f.read_text(encoding="utf-8").splitlines()
        company_line = next((l for l in lines if "@ " in l or "求人" in l), "")
    except Exception:
        company_line = ""

    date_fmt = f"{date[:4]}/{date[4:6]}/{date[6:]}" if len(date) == 8 else date
    print(f"[{i}] FILE: {f} | NAME: {name} | DATE: {date_fmt} | {company_line.strip()}")
PYEOF
