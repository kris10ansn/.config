# cleanup: reclaim disk space from package, dependency and system caches. Every
# step is guarded on its tool being installed and asks first, so the function is
# safe to run start-to-finish and cherry-pick from.

# Ask about a single step. Only an explicit y/yes is a yes: the default is no so
# that holding Enter through the run deletes nothing.
_cleanup_confirm() {
  local reply
  read -r "reply?:: $1 [y/N] "
  [[ "$reply" == (y|Y|yes|Yes|YES) ]]
}

# Total size of the given paths, formatted as " (1.5G)" for splicing into a
# prompt. Empty when none of them exist, so the prompt just reads without it.
_cleanup_size() {
  local total
  total=$(du -shc -- "$@" 2>/dev/null | tail -n1 | cut -f1)
  [[ -n "$total" && "$total" != 0 ]] && printf ' (%s)' "$total"
}

cleanup() {
  local avail_before avail_after sudo_ok=1
  local trash="${XDG_DATA_HOME:-$HOME/.local/share}/Trash"

  # Get the sudo timestamp up front so the password prompt doesn't interrupt a
  # later step. If it fails, the sudo steps are skipped rather than the run.
  if ! sudo -v; then
    echo "cleanup: no sudo, skipping the pacman cache and journal steps." >&2
    sudo_ok=0
  fi

  avail_before=$(df --output=avail -B1 / | tail -n1)

  # --- Package and dependency caches -----------------------------------------

  if (( $+commands[pnpm] )); then
    local pnpm_store
    pnpm_store=$(pnpm store path 2>/dev/null)
    _cleanup_confirm "pnpm store$(_cleanup_size $pnpm_store): drop packages no project references" &&
      pnpm store prune
  fi

  # `command npm` bypasses the lazy-nvm wrapper in .zshrc: cleaning the cache
  # isn't worth paying nvm's startup cost and losing the deferred load.
  if (( $+commands[npm] )); then
    _cleanup_confirm "npm cache$(_cleanup_size $HOME/.npm): clear it entirely" &&
      command npm cache clean --force
  fi

  if (( sudo_ok )) && (( $+commands[paccache] )); then
    _cleanup_confirm "pacman cache$(_cleanup_size /var/cache/pacman/pkg): keep the 2 newest versions of installed packages" &&
      sudo paccache -rk2
    _cleanup_confirm "pacman cache: remove every version of uninstalled packages" &&
      sudo paccache -ruk0
  fi

  # -Sc cleans the cache, -a restricts it to the AUR side (the clone/build dir);
  # the repo cache is left to paccache above, which prunes it more precisely.
  if (( $+commands[paru] )); then
    _cleanup_confirm "paru AUR cache$(_cleanup_size $HOME/.cache/paru): remove cloned and built AUR sources" &&
      paru -Sca --noconfirm
  fi

  # --- System ----------------------------------------------------------------

  # The journal grows to 10% of the filesystem before systemd rotates it.
  # Vacuuming discards the oldest boots, so raise the size to keep more history.
  if (( sudo_ok )) && (( $+commands[journalctl] )); then
    _cleanup_confirm "systemd journal ($(journalctl --disk-usage 2>/dev/null | grep -oE '[0-9.,]+[KMGT]' | tail -n1)): vacuum down to 200M, discarding the oldest boots" &&
      sudo journalctl --vacuum-size=200M
  fi

  # Brave regenerates this on next launch. Deleting it while the browser is
  # running can confuse it, so close Brave first if it matters.
  if [[ -d $HOME/.cache/BraveSoftware ]]; then
    _cleanup_confirm "Brave cache$(_cleanup_size $HOME/.cache/BraveSoftware): delete it (regenerates on next launch)" &&
      rm -rf -- $HOME/.cache/BraveSoftware/*(DN)
  fi

  # --- Destructive: real files and installed packages ------------------------

  # trash-cli's 30-day cutoff is preferred over emptying wholesale, so a file
  # binned an hour ago is still recoverable.
  if [[ -d $trash ]]; then
    if (( $+commands[trash-empty] )); then
      _cleanup_confirm "trash$(_cleanup_size $trash): permanently delete items older than 30 days" &&
        trash-empty 30
    else
      _cleanup_confirm "trash$(_cleanup_size $trash): permanently delete ALL of it (install trash-cli for a 30-day cutoff)" &&
        rm -rf -- $trash/files/*(DN) $trash/info/*(DN) $trash/expunged/*(DN)
    fi
  fi

  # Orphans are packages nothing depends on any more, which includes tools that
  # arrived as a dependency but are used directly. The list is printed and
  # pacman asks again, since this is the one step that uninstalls software.
  if (( sudo_ok )) && (( $+commands[pacman] )); then
    local -a orphans
    orphans=(${(f)"$(pacman -Qtdq 2>/dev/null)"})
    orphans=(${orphans:#})
    if (( ${#orphans} )); then
      echo "   orphaned packages: ${orphans[*]}"
      _cleanup_confirm "orphans: uninstall these ${#orphans} packages and their dependencies" &&
        sudo pacman -Rns "${orphans[@]}"
    fi
  fi

  avail_after=$(df --output=avail -B1 / | tail -n1)
  echo ":: freed $(numfmt --to=iec --suffix=B $(( avail_after - avail_before )))"
}
