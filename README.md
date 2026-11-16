# myMacConfig
My custom configurations for mac

## Updating the San Ciprian Zsh theme

The prompt theme in `omz/sanciprian.zsh-theme` is based on the upstream
[Oh My Zsh Agnoster theme](https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/agnoster.zsh-theme).
San Ciprian has local changes. A weekly GitHub Actions workflow attempts a
three-way merge from the recorded upstream snapshot and opens a pull request
for review. You can also run it on demand from the Actions tab, or locally:

```sh
./scripts/update-agnoster-upstream.sh
```

The reviewed upstream snapshot and its commit are stored in
`omz/agnoster.upstream.zsh-theme` and `omz/agnoster.upstream.version`. The
updater uses them as the base for a three-way merge, preserving local changes
when the upstream edits do not conflict. It checks Zsh syntax before changing
any files. If changes conflict, it stops without modifying the project; use
the checker to inspect the upstream diff and resolve the conflict manually:

```sh
./scripts/check-agnoster-upstream.sh
```

If the automatic merge conflicts, resolve the theme changes manually. Once
the San Ciprian theme contains your chosen upstream changes, refresh the
baseline with:

```sh
./scripts/check-agnoster-upstream.sh --accept
```

This updates only the upstream snapshot and revision marker. The scheduled
workflow requires the repository setting **Allow GitHub Actions to create
and approve pull requests** so it can open the update PR. Review each PR's
prompt behavior before merging.

```sh
zsh -n omz/sanciprian.zsh-theme
```
