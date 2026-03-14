#!/bin/bash
# progress_bar.sh — マッチスコアのANSIプログレスバー表示
# 使用法: bash progress_bar.sh <スコア0-100>

SCORE="${1:-0}"

# 数値検証
if ! [[ "${SCORE}" =~ ^[0-9]+$ ]] || [ "${SCORE}" -gt 100 ]; then
  echo "ERROR: スコアは0-100の整数で指定してください。"
  exit 1
fi

GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
CYAN='\033[1;36m'
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'

# スコアに応じた色選択
if [ "${SCORE}" -ge 70 ]; then
  BAR_COLOR="${GREEN}"
  LABEL="★ 高マッチ！"
elif [ "${SCORE}" -ge 40 ]; then
  BAR_COLOR="${YELLOW}"
  LABEL="△ 中マッチ"
else
  BAR_COLOR="${RED}"
  LABEL="▼ ギャップあり"
fi

# プログレスバー生成（幅40文字）
BAR_WIDTH=40
FILLED=$(( SCORE * BAR_WIDTH / 100 ))
EMPTY=$(( BAR_WIDTH - FILLED ))

FILLED_STR=""
for ((i=0; i<FILLED; i++)); do
  FILLED_STR="${FILLED_STR}█"
done

EMPTY_STR=""
for ((i=0; i<EMPTY; i++)); do
  EMPTY_STR="${EMPTY_STR}░"
done

echo ""
printf "  ${BOLD}マッチスコア：${RESET}\n"
printf "  ${BAR_COLOR}${FILLED_STR}${DIM}${EMPTY_STR}${RESET}  ${BAR_COLOR}${BOLD}${SCORE}/100${RESET}  ${CYAN}${LABEL}${RESET}\n"
echo ""
