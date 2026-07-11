<div align="center">
  <img src="https://dotfiles.github.io/images/dotfiles-logo.png" width="300" align="center" />
  
  <h3 align="center">My dotfiles</h3>

  <p align="center">My personal configuration files for programs I use on my linux machines.</p>
</div>

<br />

## Overview

This repo lives directly in `~/.config`. The [`.gitignore`](.gitignore) ignores
everything by default and re-includes only the directories worth tracking, so
the rest of `~/.config` stays out of version control:

```
/*
!README.md
!/nvim
!/zsh
!/VSCodium
```

Setup is [Manjaro Linux](https://manjaro.org/) with KDE Plasma, `zsh` as the
shell, and Neovim / VSCodium as editors.

## Contents

### [`zsh/`](zsh) — shell configuration

Sourced via `ZDOTDIR="$HOME/.config/zsh"`.

- **[`.zshrc`](zsh/.zshrc)** — entry point. Loads Powerlevel10k instant prompt,
  the Manjaro zsh config/prompt, `fzf` key bindings, [`zoxide`](https://github.com/ajeetdsouza/zoxide),
  and `nvm`, then sources the files below.
- **[`environment.zsh`](zsh/environment.zsh)** — `PATH` additions and env vars
  (Android SDK, Java, pnpm, .NET, `EDITOR=nvim`, etc.).
- **[`aliases.zsh`](zsh/aliases.zsh)** — shortcuts such as `code`→`codium`,
  `v`→`nvim`, `ll`→`exa -la`, plus quick-edit aliases for the configs themselves.
- **[`functions.zsh`](zsh/functions.zsh)** — helpers including `mkcd`, `cdclone`,
  a few git shortcuts, and `ccommit` — an AI-generated Conventional Commits
  helper that pipes the staged diff through `claude -p`.

### [`nvim/`](nvim) — Neovim configuration

A minimal [`init.lua`](nvim/init.lua) using the built-in `vim.pack` plugin
manager. Plugins: [catppuccin](https://github.com/catppuccin/nvim) (theme),
[mini.pick](https://github.com/echasnovski/mini.pick) (fuzzy picker),
[oil.nvim](https://github.com/stevearc/oil.nvim) (file explorer), and
[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig).

### [`VSCodium/`](VSCodium) — VSCodium / VS Code configuration

User-level `settings.json`, `keybindings.json`, `snippets/`, and a Prettier
setup (`.prettierrc.json` + `package.json` with `prettier-plugin-sort-json`).
