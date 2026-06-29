
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
  local msg
  msg=$(git diff --cached | claude -p "Write a concise git commit message for this diff. Output only the message, no preamble.")
  [[ -z "$msg" ]] && { echo "No staged changes or empty message."; return 1; }
  echo "\n$msg\n"
  echo -n "Accept? [Y/n] "
  read -r reply
  [[ "$reply" =~ ^[Nn]$ ]] && { echo "Aborted."; return 1; }
  git commit -m "$msg"
}
