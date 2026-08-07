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
  z $@ && codium .
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
