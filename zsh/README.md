# zsh config

Personal zsh configuration, kept in `~/.config/zsh` (XDG-style) instead of a
pile of dotfiles in `$HOME`.

## Layout

| File | Purpose |
| --- | --- |
| `.zshrc` | Orchestration: prompt, sourcing the files below, integrations (fzf, nvm, zoxide) |
| `environment.zsh` | Environment variables and `$PATH` |
| `aliases.zsh` | Aliases: renames and flag defaults |
| `functions.zsh` | Small helper functions (anything with arguments or logic) |
| `local.zsh` | Machine-specific bits (hardware quirks, interface names); skipped if absent |
| `modules/ccommit.zsh` | `ccommit`: AI-generated Conventional Commits messages via the `claude` CLI |
| `modules/p10k.zsh` | Powerlevel10k prompt config (`p10k configure` writes back here) |
| `templates/` | Config templates copied into projects (e.g. `prettierrc`) |

## Bootstrap on a new machine

Point zsh at this directory by creating `~/.zshenv`:

```zsh
ZDOTDIR="$HOME/.config/zsh"
```

Then clone this repo to `~/.config/zsh` and start a new shell.

## Dependencies

Expected on `$PATH` (all optional integrations are guarded, so missing ones
degrade gracefully): `eza`, `fzf`, `zoxide`, `nvm` (Manjaro package),
`xclip`, `jq`, `nvim` (via [bob](https://github.com/MordechaiHadad/bob)),
`codium`, and the `claude` CLI for `ccommit`. The prompt uses Manjaro's
zsh config and powerlevel10k packages.
