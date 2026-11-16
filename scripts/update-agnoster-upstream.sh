#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
upstream_repo=https://github.com/ohmyzsh/ohmyzsh.git
upstream_file_path=themes/agnoster.zsh-theme
local_file="$repo_root/omz/sanciprian.zsh-theme"
baseline_file="$repo_root/omz/agnoster.upstream.zsh-theme"
baseline_version_file="$repo_root/omz/agnoster.upstream.version"

temporary_dir=$(mktemp -d "${TMPDIR:-/tmp}/agnoster-update.XXXXXX")
trap 'rm -rf "$temporary_dir"' EXIT HUP INT TERM

latest_version=$(git ls-remote "$upstream_repo" refs/heads/master | cut -f1)
if [ -z "$latest_version" ]; then
  printf '%s\n' 'Could not determine the latest Oh My Zsh master revision.' >&2
  exit 1
fi

baseline_version=$(cat "$baseline_version_file")
if [ "$latest_version" = "$baseline_version" ]; then
  printf 'Agnoster is already current at %s.\n' "$baseline_version"
  exit 0
fi

latest_file="$temporary_dir/agnoster.zsh-theme"
merged_file="$temporary_dir/sanciprian.zsh-theme"
curl -fsSL "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/$latest_version/$upstream_file_path" -o "$latest_file"

if git merge-file -p "$local_file" "$baseline_file" "$latest_file" > "$merged_file"; then
  :
else
  merge_status=$?
  if [ "$merge_status" -eq 1 ]; then
    printf '%s\n' 'Automatic merge found conflicts. No project files were changed; resolve them manually.' >&2
  fi
  exit "$merge_status"
fi

if ! zsh -n "$merged_file"; then
  printf '%s\n' 'Merged theme failed Zsh syntax validation. No project files were changed.' >&2
  exit 1
fi

cp "$merged_file" "$local_file"
cp "$latest_file" "$baseline_file"
printf '%s\n' "$latest_version" > "$baseline_version_file"
printf 'Merged upstream Agnoster %s into the San Ciprian theme.\n' "$latest_version"
