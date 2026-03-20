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

- `COUNT: 0` → オンボーディングウィザードへ
- `COUNT: 1以上` → 選択UIを表示

---

## ステップ 2：プロフィール選択UI（COUNT: 1以上 は必ず表示）

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
👤 プロフィールを選択してください
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] 熊谷颯人 — データサイエンティスト（更新: 2026-03-14）
[+] 新しいプロフィールを登録する

番号を入力してください：
```

- 番号が選ばれた場合 → 選択プロフィールのJSONを読み込んで返す
- `+` が選ばれた場合 → オンボーディングウィザードへ

---

## オンボーディングウィザード

10問を**1問ずつ**対話形式で質問する（まとめて並べない）：

| # | 質問 | JSONフィールド |
|---|------|--------------|
| 1 | お名前（フルネーム） | `personal.name` |
| 2 | 現在の職種・役職 | `personal.current_title` |
| 3 | 経験年数（IT/エンジニア経験） | `personal.years_of_experience` |
| 4 | 得意な技術スキル（カンマ区切り） | `skills.technical` |
| 5 | 得意なビジネス・業務スキル（カンマ区切り） | `skills.business` |
| 6 | 直近の職歴（会社名・役職・期間・主な業務） | `work_history[0]` |
| 7 | その前の職歴（なければ「なし」） | `work_history[1]` |
| 8 | 最終学歴（学校名・学部・卒業年） | `education[0]` |
| 9 | 保有資格（なければ「なし」） | `certifications` |
| 10 | 希望職種・希望年収・希望する働き方 | `preferences` |

全回答収集後、以下のスキーマでJSONを生成して保存する：

```json
{
  "_version": "1.0",
  "_created": "<ISO8601>",
  "_updated": "<ISO8601>",
  "personal": { "name": "", "current_title": "", "years_of_experience": 0 },
  "skills": { "technical": [], "business": [] },
  "work_history": [{ "company": "", "title": "", "period_start": "", "period_end": "", "responsibilities": [], "achievements": [], "tech_stack": [] }],
  "education": [{ "institution": "", "degree": "", "field": "", "graduation_year": "" }],
  "certifications": [],
  "preferences": { "desired_role": "", "desired_salary": "", "work_style": "" }
}
```

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/save_profile.sh" '<JSON文字列>'
```

保存完了後、読み込んだプロフィールのJSONを返す。
