<div align="center">

# 🧭 Career Compass

**求人 URL を 1 つ渡すだけで、転職活動を自律実行するエージェント**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code Plugin](https://img.shields.io/badge/Claude%20Code-Plugin-blueviolet)](https://claude.ai/code)
[![Python 3](https://img.shields.io/badge/Python-3-blue)](https://www.python.org/)

</div>

---

## 何ができるか

```
/career-compass https://www.wantedly.com/projects/xxxxx
```

**このコマンド 1 つで、追加指示なしに最後まで自走します。**

```
🧭 CAREER COMPASS — 転職支援エージェント
─────────────────────────────────────────
  ▶ プロフィール自動ロード
  ▶ 求人ページ解析（必須スキル・歓迎スキル抽出）
  ▶ スキルギャップ分析

  マッチスコア：
  ████████████████████████░░░░  64/100  △ 中マッチ

  ✅ マッチスキル
    - Python・クラウド開発 5年以上
    - 要件定義・上流工程経験

  ⚠️  ギャップスキル
    - 金融ドメイン知識（歓迎）
    - インシデント対応経験（必須）

  🗺️  学習ロードマップ
  【優先度：高】
    🔴 インシデント管理
       📚 SREサイトリライアビリティエンジニアリング
       🛠️  AWS Well-Architected ハンズオン
─────────────────────────────────────────
✅ 転職活動、応援しています！ — Career Compass
```

---

## 機能

| | 機能 | 詳細 |
|---|---|---|
| 🔍 | **求人自動解析** | URLからHTML取得・必須/歓迎スキルを自動抽出 |
| 📊 | **スキルギャップ分析** | プロフィールと求人を照合しマッチスコア（0–100）を算出 |
| 🗺️ | **学習ロードマップ** | ギャップスキルごとに書籍・講座・ハンズオンを提案 |
| ⚡ | **完全自律実行** | プロフィール配置後はコマンド1つで最後まで自走 |

---

## セットアップ

### 1. インストール

```bash
# Claude Code 上で実行
/plugin marketplace add 01kuma20/agi-lab-skills-marketplace
/plugin install career-compass@agi-lab-skills
```

### 2. プロフィールを配置する

`input/profiles/profile.json.example` をコピーして自分の情報に書き換える。

```bash
cp plugins/career-compass/input/profiles/profile.json.example \
   plugins/career-compass/input/profiles/<自分の名前>.json
```

> プロフィールが見つからない場合はエラーメッセージを表示して終了します。

### 3. 実行する

```
/career-compass https://www.wantedly.com/projects/xxxxx
```

---

## プロフィールのフォーマット

スキル照合に使われるフィールド：`skills.technical` / `skills.business` / `work_history[].tech_stack`

```json
{
  "personal": {
    "name": "山田 太郎",
    "current_title": "バックエンドエンジニア",
    "years_of_experience": 5
  },
  "skills": {
    "technical": ["Python", "Go", "AWS"],
    "business": ["要件定義", "プロジェクト管理"]
  },
  "work_history": [
    {
      "company": "株式会社サンプル",
      "title": "エンジニア",
      "period_start": "2022-04",
      "period_end": "2026-01",
      "responsibilities": ["APIサーバー実装"],
      "achievements": [],
      "tech_stack": ["Python", "PostgreSQL"]
    }
  ],
  "education": [
    { "institution": "○○大学", "degree": "学士", "field": "情報工学", "graduation_year": "2022" }
  ],
  "certifications": ["AWS SAA"],
  "preferences": {
    "desired_role": "バックエンドエンジニア",
    "desired_salary": "800万円",
    "work_style": "フルリモート希望"
  }
}
```

詳細は [`input/profiles/profile.json.example`](plugins/career-compass/input/profiles/profile.json.example) を参照。

---

## 必要環境

- Claude Code
- Python 3
- Bash
- ANSI 対応のターミナル

---

## Repository Structure

```
plugins/career-compass/
├── .claude-plugin/
│   └── plugin.json
├── input/
│   └── profiles/              ← プロフィール JSON をここに置く
│       └── profile.json.example
├── scripts/
│   ├── check_profile.sh       ← プロフィール確認
│   ├── save_profile.sh        ← プロフィール保存
│   ├── display_results.sh     ← スプラッシュ・完了表示
│   └── progress_bar.sh        ← マッチスコア可視化
└── skills/
    ├── career-compass/        ← エントリーポイント（オーケストレーター）
    ├── career-compass-profile/ ← プロフィール管理
    └── career-compass-analyze/ ← 求人解析・ギャップ分析
```

---

## License

MIT
