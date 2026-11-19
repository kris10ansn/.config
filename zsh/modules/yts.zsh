
# Interactive YouTube search and playback
yts() {
    emulate -L zsh

    local query="$*"
    local selected video_id cmd

    # Prompt when no arguments are provided
    if [[ -z "$query" ]]; then
        printf "YouTube search: "
        read -r query || return 1
    fi

    [[ -z "$query" ]] && return 1

    # Search and interactively select a video
    selected=$(
        yt-dlp \
            --flat-playlist \
            --no-warnings \
            --print '%(id)s %(title)s' \
            "ytsearch20:$query" |
        fzf \
            --prompt="YouTube > " \
            --height=80% \
            --layout=reverse \
            --delimiter=' ' \
            --with-nth=2..
    ) || return 0

    [[ -z "$selected" ]] && return 0

    # Extract the YouTube video ID
    video_id="${selected%% *}"

    # Stream the selected video
    mpv -- "https://www.youtube.com/watch?v=$video_id"
}

