# Zsh configuration

Place changes by responsibility:

- `.zshrc`: startup order, shell options, and integration loading.
- `environment.zsh`: exported variables, `PATH`, and `LS_COLORS`.
- `aliases.zsh`: command renames and default flags.
- `functions.zsh`: small helpers with arguments or logic.
- `local.zsh`: optional machine-specific settings.
- `modules/`: larger helpers and Powerlevel10k configuration.
- `templates/`: config files copied into other projects.

Load `environment.zsh` after Manjaro's config so personal colors win, and
before Manjaro's prompt so it sees `USE_POWERLINE`.

For setup and dependencies, read `README.md`. After shell changes, run
`zsh -n` on each changed file and exercise the affected behavior.
