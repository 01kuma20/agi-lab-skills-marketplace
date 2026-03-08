#!/bin/bash
# Wingman opening ceremony - ANSI color terminal splash

MEETING_TITLE="${1:-会議}"
PARTICIPANT_COUNT="${2:-?}"

CYAN='\033[1;36m'
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
MAGENTA='\033[1;35m'
RESET='\033[0m'
DIM='\033[2m'

clear

echo ""
printf "${CYAN}╔══════════════════════════════════════════════════╗${RESET}\n"
printf "${CYAN}║${RESET}   ${YELLOW}✈  WINGMAN  —  あなたの会議の副操縦士${RESET}         ${CYAN}║${RESET}\n"
printf "${CYAN}╚══════════════════════════════════════════════════╝${RESET}\n"
echo ""
printf "  ${DIM}会議:${RESET}  ${GREEN}${MEETING_TITLE}${RESET}\n"
printf "  ${DIM}参加者:${RESET} ${GREEN}${PARTICIPANT_COUNT}名${RESET}\n"
echo ""
printf "${MAGENTA}  ▶ アイスブレイクを生成中...${RESET}\n"

for i in 3 2 1; do
  printf "\r  ${YELLOW}  発射まで ${i} 秒...${RESET}   "
  sleep 0.7
done

printf "\r  ${CYAN}  🚀 発射！${RESET}                \n"
echo ""
