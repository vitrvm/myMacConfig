# Project guidance

This repository contains personal macOS terminal configuration:

- `omz/sanciprian.zsh-theme` is an Oh My Zsh prompt theme inspired by Agnoster.
- `omz/sanciprian.itermcolors` is the matching iTerm2 color profile.

## Editing

- Keep changes focused on the requested configuration or documentation.
- Preserve Zsh prompt conventions and the Powerline glyph code points used by the theme.
- The San Ciprian theme follows Oh My Zsh's `themes/agnoster.zsh-theme`; use `./scripts/check-agnoster-upstream.sh` to inspect changes and `./scripts/update-agnoster-upstream.sh` to attempt a safe three-way merge from the committed upstream snapshot.
- Keep San Ciprian-specific behavior, including AWS profile display, when incorporating upstream changes.
- Advance the upstream snapshot only when the upstream changes are merged into San Ciprian. The updater does this after conflict-free merge and Zsh syntax validation.
- Keep `.itermcolors` files valid Apple plist XML and preserve their iTerm2 color keys.
- Do not add platform claims beyond the macOS-oriented support described by the project.

## Verification

- For changes to the Zsh theme, check syntax with `zsh -n omz/sanciprian.zsh-theme` when Zsh is available.
- For changes to the iTerm2 profile, parse it as a plist/XML file when suitable tools are available.
- There is no test suite or build system in this repository.
