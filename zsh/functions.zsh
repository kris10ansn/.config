
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