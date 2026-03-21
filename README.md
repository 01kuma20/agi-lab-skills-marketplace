# Career Compass

求人 URL を 1 つ渡すだけで、スキルギャップ分析と学習ロードマップを自動生成する転職支援エージェントです。

## 何ができるか

```
/career-compass https://example.com/jobs/12345
```

このコマンド 1 つで以下が自律実行されます。

| ステップ | 処理内容 |
|---------|---------|
| 1 | `input/profiles/` からプロフィールを自動ロード |
| 2 | 求人 URL から必須スキル・歓迎スキルを自動取得 |
| 3 | スキルギャップ分析（マッチスコア 0–100 + プログレスバー） |
| 4 | 学習ロードマップ生成（書籍・講座・ハンズオン提案） |

## セットアップ

### 1. インストール

```bash
# Claude Code 上で実行
/plugin marketplace add <your-github-user>/<your-repo>
/plugin install career-compass@agi-lab-skills
```

### 2. プロフィールを配置する

`input/profiles/profile.json.example` をコピーして自分の情報に書き換える。

```bash
cp plugins/career-compass/input/profiles/profile.json.example \
   plugins/career-compass/input/profiles/<自分の名前>.json
```

プロフィールが見つからない場合はエラーで終了する。

### 3. 実行する

```
/career-compass https://www.wantedly.com/projects/xxxxx
```

## プロフィールのフォーマット

スキル照合には `skills.technical` / `skills.business` / `work_history[].tech_stack` が使われる。

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
  "education": [{ "institution": "○○大学", "degree": "学士", "field": "情報工学", "graduation_year": "2022" }],
  "certifications": ["AWS SAA"],
  "preferences": {
    "desired_role": "バックエンドエンジニア",
    "desired_salary": "800万円",
    "work_style": "フルリモート希望"
  }
}
```

詳細は `input/profiles/profile.json.example` を参照。

## 必要環境

- Python 3
- Bash
- ANSI 対応のターミナル

## Repository Structure

```text
.claude-plugin/
└── marketplace.json

plugins/
└── career-compass/
    ├── .claude-plugin/
    │   └── plugin.json
    ├── scripts/
    │   ├── check_profile.sh
    │   ├── save_profile.sh
    │   ├── display_results.sh
    │   └── progress_bar.sh
    ├── input/
    │   └── profiles/            ← プロフィール JSON をここに置く
    │       └── profile.json.example
    └── skills/
        ├── career-compass/      ← オーケストレーター（エントリーポイント）
        ├── career-compass-profile/
        └── career-compass-analyze/
```

## License

MIT
