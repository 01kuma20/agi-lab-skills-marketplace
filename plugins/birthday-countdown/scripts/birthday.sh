#!/bin/bash

today=$(date +%Y-%m-%d)
year=$(date +%Y)
month=$(date +%m)

# 今年の誕生日
birthday="${year}-01-20"

# 今年の誕生日が既に過ぎていたら来年
if [[ "$today" > "$birthday" ]]; then
  birthday="$((year + 1))-01-20"
fi

# 残り日数を計算
today_sec=$(date -j -f "%Y-%m-%d" "$today" "+%s" 2>/dev/null || date -d "$today" "+%s")
birthday_sec=$(date -j -f "%Y-%m-%d" "$birthday" "+%s" 2>/dev/null || date -d "$birthday" "+%s")

days=$(( (birthday_sec - today_sec) / 86400 ))

echo "🎂 誕生日（1月20日）まで あと ${days} 日！"
