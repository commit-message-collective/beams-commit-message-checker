#!/bin/sh
COMMIT_MSG_FILE=$1
sanitized_commit_message=$(cat "$COMMIT_MSG_FILE" | sed -e '/^#.*/,$d')
current_branch="$(git rev-parse --abbrev-ref HEAD)"
parent_commit="$(git rev-parse HEAD^)"
if [ "$(git rev-parse $current_branch)" = "$parent_commit" ]
then
    filenames="$(git diff --name-only HEAD^ | paste -sd "," -)"
else
    filenames="$(git diff --cached --pretty=format: --name-only | paste -sd "," -)"
fi
out=$(docker run -e COMMIT_MESSAGE="$sanitized_commit_message" -e FILENAMES="$filenames" ghcr.io/commit-message-collective/beams-commit-message-checker)
if [ -n "$out" ]
then
    echo "❌ $out\n"
    # Print the commit message that was rejected. Otherwise, it may get lost.
    echo "Your commit message was:\n"
    echo "$sanitized_commit_message\n"
    exit 1
fi
