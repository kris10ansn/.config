
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

cmsg() {
		ollama run mistral:latest "
        You are a developer writing clear, concise Git commit messages.
        Write a commit title (≤ 50 characters) that follows conventional-commit style, then optionally add a short body (max 72 characters per line) if the change needs extra context.

        Avoid going into detail about how the change was made; focus on what and why.
        Avoid being too vague or generic — be specific about the changes made.

		Use the following format with one of these types: feat, fix, docs, style, refactor, test, chore, perf:
		<type>(<optional scope>): <short summary>

        Do not include any extra commentary, just provide the commit message.

        DIFF: $(git diff --staged)" 
}