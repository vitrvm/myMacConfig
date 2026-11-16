#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
upstream_repo=https://github.com/ohmyzsh/ohmyzsh.git
upstream_file_path=themes/agnoster.zsh-theme
baseline_file="$repo_root/omz/agnoster.upstream.zsh-theme"
baseline_version_file="$repo_root/omz/agnoster.upstream.version"

case "${1:-}" in
  ""|--accept) ;;
  *) printf 'Usage: %s [--accept]\n' "$0" >&2; exit 2 ;;
esac

temporary_dir=$(mktemp -d "${TMPDIR:-/tmp}/agnoster-upstream.XXXXXX")
trap 'rm -rf "$temporary_dir"' EXIT HUP INT TERM

latest_version=$(git ls-remote "$upstream_repo" refs/heads/master | cut -f1)
if [ -z "$latest_version" ]; then
  printf '%s\n' 'Could not determine the latest Oh My Zsh master revision.' >&2
  exit 1
fi

latest_file="$temporary_dir/agnoster.zsh-theme"
curl -fsSL "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/$latest_version/$upstream_file_path" -o "$latest_file"

if [ "${1:-}" = '--accept' ]; then
  cp "$latest_file" "$baseline_file"
  printf '%s\n' "$latest_version" > "$baseline_version_file"
  printf 'Accepted upstream baseline at %s. The San Ciprian theme was not changed.\n' "$latest_version"
  exit 0
fi

baseline_version=$(cat "$baseline_version_file")
if [ "$latest_version" = "$baseline_version" ]; then
  printf 'No new upstream revision since baseline %s.\n' "$baseline_version"
  exit 0
fi

printf 'Upstream Agnoster changes: %s -> %s\n' "$baseline_version" "$latest_version"
if diff -u "$baseline_file" "$latest_file"; then
  printf '%s\n' 'No changes to the Agnoster theme in this upstream revision.'
else
  diff_status=$?
  if [ "$diff_status" -eq 1 ]; then
    printf '%s\n' 'Review the upstream diff, merge selected changes into sanciprian.zsh-theme, then run this script with --accept to advance the baseline.'
  else
    exit "$diff_status"
  fi
fi
