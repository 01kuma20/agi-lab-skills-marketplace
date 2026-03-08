#!/bin/bash
# read_participants.sh — 会議参加者データ取得
# participants.json の user_ids を読み、Slack MCP サーバーからプロフィール＋履歴を取得して返す

MEETING_FILE="${CLAUDE_PLUGIN_ROOT}/data/participants.json"

# 会議メタデータを取得
meeting=$(python3 -c "
import json
data = json.load(open('${MEETING_FILE}'))
print(json.dumps(data['meeting'], ensure_ascii=False))
" 2>/dev/null)

# 参加者IDリストを取得
ids=$(python3 -c "
import json
data = json.load(open('${MEETING_FILE}'))
print(' '.join(data['participant_ids']))
" 2>/dev/null)

# Slack MCP サーバーからプロフィール＋履歴取得（シミュレーション）
# 実際のMCP環境では:
#   mcp call slack get_user_profile --user_id $id
#   mcp call slack get_messages --user_id $id --limit 10
participants=$(bash "${CLAUDE_PLUGIN_ROOT}/scripts/mcp_slack.sh" $ids)

# 会議情報＋参加者を合体して返す
python3 -c "
import json, sys
meeting = ${meeting}
participants = json.loads('''${participants}''')
result = {
    'meeting': meeting,
    'participants': participants,
    '_source': 'Slack MCP Server (simulated)',
    '_fields': ['name','role','location','expertise','fun_facts','slack_profile','slack_history']
}
print(json.dumps(result, ensure_ascii=False, indent=2))
" 2>/dev/null
