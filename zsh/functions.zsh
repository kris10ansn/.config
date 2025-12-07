
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
		{ git status; echo ""; git diff --cached; } | ollama run deepseek-coder-v2 "
		You are an assistant that writes Git commit messages using the Conventional Commits specification.
		Analyze the following diff and output **only** a commit message in the format:

		<type>(<optional scope>): <short summary>

		Use one of these types: feat, fix, docs, style, refactor, test, chore, perf.
		Keep it under 72 characters. Do not include extra text.

		Status and diff:"
}