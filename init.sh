#!/usr/bin/env bash
set -euo pipefail

# .cursorディレクトリがあるかチェックして、無ければ作る
CURSOR_DIR="$(pwd)/.cursor"

if [ -d "$CURSOR_DIR" ]; then
  echo ".cursor ディレクトリは既に存在します: $CURSOR_DIR"
fi

mkdir -p "$CURSOR_DIR"
echo ".cursor ディレクトリを作成しました: $CURSOR_DIR"

# ダウンロード用ディレクトリ
RULES_DIR="$CURSOR_DIR/rules"
mkdir -p "$RULES_DIR"
echo ".cursor/rules ディレクトリを作成しました: $RULES_DIR"
# .cursor/rules/project.mdcがあるかチェックして、無ければgithubからダウンロードする
PROJECT_FILE="$RULES_DIR/project.mdc"

if [ -f "$PROJECT_FILE" ]; then
  echo ".cursor/rules/project.mdc は既に存在します: $PROJECT_FILE"
else
  echo ".cursor/rules/project.mdc が見つかりません。GitHub からダウンロードを試みます..."

  owner_repo="itsumura-h/cursor-template"
  try_branches=("main" "master")
  success=false

  for b in "${try_branches[@]}"; do
    raw_url="https://raw.githubusercontent.com/$owner_repo/$b/files/project.mdc"
    echo "Downloading $raw_url ..."
    if command -v curl >/dev/null 2>&1; then
      if curl -fsSL -o "$PROJECT_FILE" "$raw_url"; then
        success=true
        break
      fi
    elif command -v wget >/dev/null 2>&1; then
      if wget -qO "$PROJECT_FILE" "$raw_url"; then
        success=true
        break
      fi
    else
      echo "curl または wget が必要です。インストールしてください。" >&2
      break
    fi
  done

  if [ "$success" = true ]; then
    echo "ダウンロードに成功しました: $PROJECT_FILE"
  else
    echo "GitHub からのダウンロードに失敗しました。手動で $PROJECT_FILE を配置してください。" >&2
  fi
fi
# .cursor/rules/branch.mdcがあるかチェックして、無ければgithubからダウンロードする
BRANCH_FILE="$RULES_DIR/branch.mdc"

if [ -f "$BRANCH_FILE" ]; then
  echo ".cursor/rules/branch.mdc は既に存在します: $BRANCH_FILE"
else
  echo ".cursor/rules/branch.mdc が見つかりません。GitHub からダウンロードを試みます..."

  # ダウンロード元の GitHub リポジトリを固定
  owner_repo="itsumura-h/cursor-template"
  echo "ダウンロード元リポジトリ: $owner_repo"

  try_branches=("main" "master")
  success=false

  if [ -n "$owner_repo" ]; then
    for b in "${try_branches[@]}"; do
      raw_url="https://raw.githubusercontent.com/$owner_repo/$b/files/branch.mdc"
      echo "Downloading $raw_url ..."
      if command -v curl >/dev/null 2>&1; then
        if curl -fsSL -o "$BRANCH_FILE" "$raw_url"; then
          success=true
          break
        fi
      elif command -v wget >/dev/null 2>&1; then
        if wget -qO "$BRANCH_FILE" "$raw_url"; then
          success=true
          break
        fi
      else
        echo "curl または wget が必要です。インストールしてください。" >&2
        break
      fi
    done
  else
    echo "git remote origin が見つからないためダウンロード元を特定できませんでした。" >&2
  fi

  if [ "$success" = true ]; then
    echo "ダウンロードに成功しました: $BRANCH_FILE"
  else
    echo "GitHub からのダウンロードに失敗しました。手動で $BRANCH_FILE を配置してください。" >&2
  fi
fi

# .cursor/rules/branchディレクトリがなければ作る
BRANCH_DIR="$RULES_DIR/branch"
if [ -d "$BRANCH_DIR" ]; then
  echo ".cursor/rules/branch ディレクトリは既に存在します: $BRANCH_DIR"
else
  mkdir -p "$BRANCH_DIR"
  echo ".cursor/rules/branch ディレクトリを作成しました: $BRANCH_DIR"
fi