#!/bin/sh
set -eu

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

# リポジトリ設定（common_rule_url などで使用するため先に定義）
owner_repo="itsumura-h/cursor-template"

# .cursor/rules/common_rule.mdc を常にダウンロードして上書き
COMMON_RULE_TARGET="$RULES_DIR/common_rule.mdc"
common_rule_url="https://raw.githubusercontent.com/$owner_repo/main/.cursor/common_rule.mdc"
echo ".cursor/rules/common_rule.mdc をダウンロードして上書きします: $COMMON_RULE_TARGET"
success=false
if command -v curl >/dev/null 2>&1; then
  if curl -fsSL -o "$COMMON_RULE_TARGET" "$common_rule_url"; then
    success=true
  fi
elif command -v wget >/dev/null 2>&1; then
  if wget -qO "$COMMON_RULE_TARGET" "$common_rule_url"; then
    success=true
  fi
else
  echo "curl または wget が必要です。インストールしてください。" >&2
fi
if [ "$success" = true ]; then
  echo "ダウンロードに成功しました: $COMMON_RULE_TARGET"
else
  echo "GitHub からのダウンロードに失敗しました。手動で $COMMON_RULE_TARGET を配置してください (.cursor/rules/common_rule.mdc になるようにしてください)。" >&2
fi

# ダウンロードするファイルの定義
FILES_TO_DOWNLOAD="project.mdc branch.mdc"

# 各ファイルをダウンロード
for file in $FILES_TO_DOWNLOAD; do
  TARGET_FILE="$RULES_DIR/$file"
  
  if [ -f "$TARGET_FILE" ]; then
    echo ".cursor/rules/$file は既に存在します: $TARGET_FILE"
  else
    echo ".cursor/rules/$file が見つかりません。GitHub からダウンロードを試みます..."
    
    success=false
    raw_url="https://raw.githubusercontent.com/$owner_repo/main/.cursor/$file"
    echo "Downloading $raw_url ..."
    
    if command -v curl >/dev/null 2>&1; then
      if curl -fsSL -o "$TARGET_FILE" "$raw_url"; then
        success=true
      fi
    elif command -v wget >/dev/null 2>&1; then
      if wget -qO "$TARGET_FILE" "$raw_url"; then
        success=true
      fi
    else
      echo "curl または wget が必要です。インストールしてください。" >&2
    fi

    if [ "$success" = true ]; then
      echo "ダウンロードに成功しました: $TARGET_FILE"
    else
      echo "GitHub からのダウンロードに失敗しました。手動で $TARGET_FILE を配置してください。" >&2
    fi
  fi
done

# .cursor/rules/branchディレクトリがなければ作る
BRANCH_DIR="$RULES_DIR/branch"
if [ -d "$BRANCH_DIR" ]; then
  echo ".cursor/rules/branch ディレクトリは既に存在します: $BRANCH_DIR"
else
  mkdir -p "$BRANCH_DIR"
  echo ".cursor/rules/branch ディレクトリを作成しました: $BRANCH_DIR"
fi
