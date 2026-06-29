
reload() {
    exec zsh;
}

mkcd() {
    mkdir -p "$@" && cd "$@";
}

cdcodium() {
    cd "$@" && codium "."
}

mkcdcodium() {
    mkcd "$@" && codium "."
}

cdclone() {
    git clone "$@" && cd $(basename "$@" .git)
}

git-checkout-unstaged() {
		git stash;
		git checkout "$@"
		git stash pop;
}

git-undo-commit() {
  git reset --soft HEAD~1
}

ccommit() {
  local prompt="Write a git commit message for this diff: a concise summary line (max 50 chars), a blank line, then a body explaining what changed and why. Output only the message, no preamble."
  local msg
  msg=$(git diff --cached | claude -p "$prompt")

  if [[ -z "$msg" ]]; then
    echo "No staged changes or empty message."
    return 1
  fi

  printf '\n%s\n\n' "$msg"
  read -r "reply?Accept? [Y/n] "

  if [[ "$reply" =~ ^[Nn]$ ]]; then
    echo "Aborted."
    return 1
  fi

  git commit -m "$msg"
}
