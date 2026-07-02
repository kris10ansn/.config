
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
  local history context
  history=$(git log -20 --pretty=format:'%s')
  context="$*"

  if git diff --cached --quiet; then
    if [[ -z "$(git status --porcelain)" ]]; then
      echo "Nothing to commit."
      return 1
    fi
    echo "No staged changes. The following changes would be committed:"
    echo
    git status --short
    echo
    read -r "reply?Commit all these changes? [y/N] "
    if [[ ! "$reply" =~ ^[Yy]$ ]]; then
      echo "Aborted."
      return 1
    fi
    git add -A
  fi

  local prompt="Write a git commit message for this diff following Conventional Commits. Start the summary line with a type (feat, fix, chore, style, refactor, docs, test, perf, build, ci) and optional scope, e.g. 'feat(auth): ...'. Keep the summary under 50 chars, then a blank line, then a body explaining what changed and why. Match the style of these recent commit subjects:
$history"

  if [[ -n "$context" ]]; then
    prompt+="

Additional context from the author: $context"
  fi

  prompt+="

Output only the message, no preamble, no code fences."

  local msg
  msg=$(git diff --cached | claude -p "$prompt")
  msg=$(printf '%s\n' "$msg" | sed '/^```/d')

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
