reload() {
  exec zsh
}

mkcd() {
  mkdir -p "$@" && cd "${@[-1]}"
}

cdtemp() {
  cd "$(mktemp -d)"
}

cdcodium() {
  cd "$@" && codium .
}

mkcdcodium() {
  mkcd "$@" && codium .
}

zc() {
  local -a flags dirs
  local arg
  for arg in "$@"; do
    if [[ "$arg" == -* ]]; then
      flags+=("$arg")
    else
      dirs+=("$arg")
    fi
  done
  z "${dirs[@]}" && codium "${flags[@]}" .
}

cdclone() {
  git clone "$@" && cd "$(basename "$1" .git)"
}

git-checkout-unstaged() {
  # Only pop if we actually stashed something, so a clean tree
  # doesn't pop an older, unrelated stash
  local stashed=0
  if [[ -n "$(git status --porcelain)" ]]; then
    git stash push -m "git-checkout-unstaged" && stashed=1
  fi
  git checkout "$@"
  (( stashed )) && git stash pop
}

git-undo-commit() {
  git reset --soft HEAD~1
}
