#!/usr/bin/env bash
set -euo pipefail

YAML_FILE="${1:-projects.yml}"
OUTPUT_DIR="source/projects"

# calculate github raw url
get_raw_base_url() {
  local repo_url="$1"
  local branch="$2"
  local repo_path
  repo_path=$(echo "$repo_url" | sed -E 's|https?://github.com/||; s|/$||; s/\.git$//')
  echo "https://raw.githubusercontent.com/$repo_path/$branch"
}

# fix relative image link with github raw url
fix_relative_images() {
  local raw_base="$1"
  RAW_BASE="$raw_base" perl -pe 's|!\[(.*?)\]\((?!https?://)(?:\./)?(.*?)\)|![$1]($ENV{RAW_BASE}/$2)|g'
}

process_repo() {
  local item="$1"
  local name url slug branch raw_base dest

  name=$(echo "$item" | jq -r '.name')
  url=$(echo "$item" | jq -r '.url')
  
  # Read optional branch (defaults to main)
  branch=$(echo "$item" | jq -r '.branch // "main"')

  # Read optional slug (defaults to <repo-name>.md)
  slug=$(echo "$item" | jq -r '.slug // empty')
  if [[ -z "$slug" ]]; then
    slug="$(basename "$url").md"
  fi

  raw_base=$(get_raw_base_url "$url" "$branch")
  dest="$OUTPUT_DIR/$slug"

  echo "Fetching $name ($branch)..."

  # Add title
  cat <<EOF > "$dest"
---
title: "$name"
---

<a href="$url">GitHub link</a>

EOF

  # download and fix
  curl -sSL "$raw_base/README.md" | fix_relative_images "$raw_base" >> "$dest"
}

# main
mkdir -p "$OUTPUT_DIR"

yq -c '.projects[]' "$YAML_FILE" | while read -r item; do
  process_repo "$item"
done

echo "Finished sync to $OUTPUT_DIR!"