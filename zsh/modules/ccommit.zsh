# ccommit: generate a Conventional Commits message for the staged diff with
# Claude (Haiku by default), confirm, and commit. Extra arguments are passed
# as context to the model. Set CCOMMIT_MODEL to use a different Claude model.
ccommit() {
  local context
  context="$*"

  local unslop_file="$HOME/.agents/skills/unslop/SKILL.md"
  local unslop=""
  [[ -r "$unslop_file" ]] && unslop=$(<"$unslop_file")

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

  prompt+="

Before writing the title (the first line), review the complete file list and diff to identify every distinct purpose of the changes. The title must reflect the combined intent of the entire commit. Use a specific shared theme when it accurately covers all changes; otherwise name the distinct purposes concisely. Do not focus only on the first, largest, or most prominent change, or use a vague title such as 'update files'. Use an optional scope only if it covers the whole commit. Check the title against all changes before replying; covering an omitted purpose in the body does not make the title complete."

  if [[ -n "$branch" ]]; then
    prompt+="

The current branch is '$branch'. Use it only as a hint about the scope and intent of the change. Never quote the branch name or mention the branch in the message."
  fi

  if [[ -n "$context" ]]; then
    prompt+="

Additional context from the author: $context"
  fi

  if [[ -n "$unslop" ]]; then
    prompt+="

Apply the following unslop writing instructions to the message. They are included in full; do not load the skill separately. Preserve the required Conventional Commits summary and body format.

<unslop>
$unslop
</unslop>"
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
  local -a claude_args
  claude_args=(
    -p
    --model "${CCOMMIT_MODEL:-haiku}"
    --tools ""
    --strict-mcp-config
    --no-session-persistence
  )

  local error_file
  error_file=$(mktemp) || return 1
  local claude_exit=0
  msg=$(
    {
      printf 'Files changed:\n'
      git diff --cached --stat
      printf '\nFile status:\n'
      git diff --cached --name-status -M
      printf '\nDiff:\n%s\n' "$diff"
    } | claude "${claude_args[@]}" "$prompt" 2>"$error_file"
  ) || claude_exit=$?

  if (( claude_exit != 0 )); then
    printf 'Claude failed to generate a commit message (exit %s).\n' "$claude_exit" >&2
    cat "$error_file" >&2
    rm -f "$error_file"
    return "$claude_exit"
  fi

  msg=$(printf '%s\n' "$msg" | sed '/^```/d')

  if [[ -z "$msg" ]]; then
    echo "Claude returned an empty commit message." >&2
    cat "$error_file" >&2
    rm -f "$error_file"
    return 1
  fi
  rm -f "$error_file"

  printf '\n%s\n\n' "$msg"
  read -r "reply?Accept? [Y/n] "

  if [[ "$reply" =~ ^[Nn]$ ]]; then
    echo "Aborted."
    return 1
  fi

  git commit -m "$msg"
}
