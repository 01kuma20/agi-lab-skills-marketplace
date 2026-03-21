#!/bin/bash
# display_results.sh — ANSI UIスクリプト
# 使用法:
#   bash display_results.sh splash
#   bash display_results.sh section "セクションタイトル"
#   bash display_results.sh complete

MODE="${1:-splash}"

CYAN='\033[1;36m'
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
MAGENTA='\033[1;35m'
BLUE='\033[1;34m'
RED='\033[1;31m'
RESET='\033[0m'
DIM='\033[2m'
BOLD='\033[1m'

case "${MODE}" in
  splash)
    clear
    echo ""
    printf "${CYAN}╔══════════════════════════════════════════════════════╗${RESET}\n"
    printf "${CYAN}║${RESET}  ${YELLOW}🧭  CAREER COMPASS  —  転職支援エージェント${RESET}        ${CYAN}║${RESET}\n"
    printf "${CYAN}║${RESET}  ${DIM}スキルギャップ分析  →  学習ロードマップ生成  →  転職支援${RESET}  ${CYAN}║${RESET}\n"
    printf "${CYAN}╚══════════════════════════════════════════════════════╝${RESET}\n"
    echo ""
    printf "  ${DIM}Powered by Claude — あなたの転職を、データで後押しします。${RESET}\n"
    echo ""
    printf "${MAGENTA}  ▶ 起動中...${RESET}\n"

    for i in 3 2 1; do
      printf "\r  ${YELLOW}  開始まで ${i} 秒...${RESET}   "
      sleep 0.6
    done

    printf "\r  ${CYAN}  🚀 分析開始！${RESET}                \n"
    echo ""
    ;;

  section)
    TITLE="${2:-処理中...}"
    echo ""
    printf "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
    printf "${BOLD}  ${TITLE}${RESET}\n"
    printf "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
    echo ""
    ;;

  complete)
    echo ""
    printf "${GREEN}╔══════════════════════════════════════════════════════╗${RESET}\n"
    printf "${GREEN}║${RESET}  ${BOLD}✅  分析完了！${RESET}                                      ${GREEN}║${RESET}\n"
    printf "${GREEN}╚══════════════════════════════════════════════════════╝${RESET}\n"
    echo ""
    printf "  ${CYAN}転職活動、応援しています！ — Career Compass 🧭${RESET}\n"
    echo ""
    ;;

  *)
    echo "使用法: $0 {splash|section <タイトル>|complete}"
    exit 1
    ;;
esac
