#!/bin/bash
# mcp_slack.sh — Slack MCP Server シミュレーター
# 引数: user IDs (スペース区切り) → users.json からプロフィール＋Slackデータを返す
#
# 実際のMCP使用時はここが以下のようなコールに置き換わる:
#   mcp call slack get_user_profile --user_id $id
#   mcp call slack get_messages --user_id $id --limit 10

USERS_FILE="${CLAUDE_PLUGIN_ROOT}/data/users.json"
IDS=("$@")

echo "["
first=1
for id in "${IDS[@]}"; do
  user=$(python3 -c "
import json, sys
data = json.load(open('${USERS_FILE}'))
user = next((u for u in data['users'] if u['id'] == '${id}'), None)
if user:
    print(json.dumps(user, ensure_ascii=False))
" 2>/dev/null)
  if [ -n "$user" ]; then
    [ $first -eq 0 ] && echo ","
    echo "$user"
    first=0
  fi
done
echo "]"
