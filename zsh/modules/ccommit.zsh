# ccommit: generate a Conventional Commits message for the staged diff with
# Codex, confirm, and commit. Extra arguments are passed as context to the
# model. Set CCOMMIT_MODEL to override the model configured for Codex.
ccommit() {
  local context
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
    read -r "reply?Commit all these changes? [Y/n] "
    if [[ "$reply" =~ ^[Nn]$ ]]; then
      echo "Aborted."
      return 1
    fi
    git add -A
  fi

  local branch
  branch=$(git branch --show-current)

  local prompt="Write a git commit message for this diff following Conventional Commits. Start the summary line with a type (feat, fix, chore, style, refactor, docs, test, perf, build, ci) and optional scope, e.g. 'feat(auth): ...'. Keep the summary under 50 chars, then a blank line, then a body explaining what changed and why. Account for every file in the file list; do not leave a changed file out of the body. Always emit both parts: a type-prefixed summary line, a blank line, then at least one sentence of body. Never reply with only a summary line, even for a one-line change."

  if [[ -n "$branch" ]]; then
    prompt+="

The current branch is '$branch'. Use it only as a hint about the scope and intent of the change. Never quote the branch name or mention the branch in the message."
  fi

  if [[ -n "$context" ]]; then
    prompt+="

Additional context from the author: $context"
  fi

  prompt+="

Output only the message, no preamble, no code fences."

  prompt+="

Use only the supplied change information. Do not run commands or use tools."

  local max_diff_lines=2000
  local diff
  # Small changes get extra surrounding context so the model can see the
  # neighbouring code instead of guessing; large ones stay at git's default
  # so the extra context doesn't balloon the request.
  diff=$(git diff --cached -U15)
  if (( ${#${(f)diff}} > 400 )); then
    diff=$(git diff --cached)
  fi

  if (( ${#${(f)diff}} > max_diff_lines )); then
    diff=$(printf '%s\n' "$diff" | head -n $max_diff_lines)
    diff+="

[... diff truncated after $max_diff_lines lines; see the file summary above for the full scope ...]"
  fi

  local msg
  local -a codex_args
  codex_args=(
    exec
    --sandbox read-only
    --ephemeral
    --color never
  )
  if [[ -n "${CCOMMIT_MODEL:-}" ]]; then
    codex_args+=(--model "$CCOMMIT_MODEL")
  fi

  msg=$(
    {
      printf 'Files changed:\n'
      git diff --cached --stat
      printf '\nFile status:\n'
      git diff --cached --name-status -M
      printf '\nDiff:\n%s\n' "$diff"
    } | codex "${codex_args[@]}" "$prompt" 2>/dev/null
  )
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
