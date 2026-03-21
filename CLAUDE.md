# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

AGIラボ Plugin Marketplace — Claude Code の `/plugin` システム向け plugin を公開・提出する repo。ハッカソン参加者は `plugins/hackathon-starter/` を fork して自分の skill に書き換えて提出する。

## Plugin System Architecture

Claude Code の plugin は以下の階層で動く：

```
.claude-plugin/marketplace.json     ← repo 全体の marketplace 定義（plugin 一覧）
plugins/<name>/
  .claude-plugin/plugin.json        ← plugin 単体のメタ情報
  commands/<name>.md                ← /command として呼ばれるオーケストレーター（frontmatter で allowed-tools を宣言）
  skills/<skill-name>/SKILL.md      ← skill の本体（Claude が読んで動くプロンプト。frontmatter で user-invocable を宣言）
  scripts/                          ← Bash / Python ヘルパー（SKILL.md から Bash tool 経由で呼ぶ）
  data/                             ← 実行時に生成されるデータ（プロフィール等）
```

- **marketplace.json** に `plugins` 配列でエントリを追加すると、`/plugin install` でインストール可能になる
- **commands/*.md** は `allowed-tools` frontmatter で使用 tool を制限するオーケストレーター。sub-skill を順番に呼び出す
- **SKILL.md** が実際の動作定義。`user-invocable: true` で直接呼び出し可能、`false` でオーケストレーター専用
- スクリプトは `${CLAUDE_PLUGIN_ROOT}` 環境変数でプラグインのルートを参照する
- プロフィール等の永続データは `~/.career-compass/` に保存（plugin cache ではなく home dir）

## career-compass の構成（実装参考）

3スキル構成のオーケストレーターパターン：

| ファイル | 役割 |
|---------|------|
| `commands/career-compass.md` | オーケストレーター。profile → analyze の順に sub-skill を呼ぶ |
| `skills/career-compass-profile/SKILL.md` | プロフィール選択・新規登録（10問ウィザード） |
| `skills/career-compass-analyze/SKILL.md` | WebFetch で求人HTML取得 → ギャップ分析 → ロードマップ生成 |

スクリプトは Python3 + Bash。`save_profile.sh` / `check_profile.sh` でプロフィールを `~/.career-compass/profiles/<name>.json` に読み書きする。

## 新しい Plugin を作るときの最小手順

1. `plugins/hackathon-starter/` をコピーしてフォルダ名を変更
2. `skills/starter-guide/SKILL.md` → 自分の skill 定義に書き換え
3. `.claude-plugin/plugin.json` の `name` / `description` を更新
4. `.claude-plugin/marketplace.json` の `plugins` 配列にエントリを追加

## インストール確認コマンド

```bash
# Claude Code 上で実行
/plugin marketplace add <github-user>/<repo>
/plugin install <plugin-name>@<marketplace-name>
```

## 依存環境

- Python 3（スクリプト類）
- Bash
- ANSI 対応ターミナル（progress_bar / display_results）
