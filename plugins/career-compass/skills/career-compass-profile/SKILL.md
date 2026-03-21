---
name: career-compass-profile
description: >
  Career Compassのプロフィール管理スキル。プロフィールの選択・新規登録（10問ウィザード）・保存を行う。
  「プロフィール登録」「プロフィール更新」などで起動。
user-invocable: true
---

# Career Compass — プロフィール管理

プロフィールの確認・選択・新規登録を行います。

---

## ステップ 1：プロフィール確認

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/check_profile.sh"
```

出力の `COUNT` を確認して分岐する：

- `COUNT: 0` → **エラーで終了**（以下のメッセージを表示して処理を中断）
- `COUNT: 1以上` → **自動選択**（UIを表示せず、一覧の先頭プロフィールのJSONを読み込んで返す）

### COUNT=0 のエラーメッセージ

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
❌ エラー：プロフィールが見つかりません
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

プロフィールファイルが登録されていないため、分析を開始できません。

以下のパスにプロフィールJSONを配置してください：
  plugins/career-compass/input/profiles/<名前>.json

profile.json.example をコピーして自分の情報に書き換えてください：
  plugins/career-compass/input/profiles/profile.json.example
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
