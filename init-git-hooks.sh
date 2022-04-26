#!/bin/bash

# Init git only if exists

if [[ -n "git --version" ]]; then
    echo "Initializing Git..."
    git init
    echo "Initializing pre-commit hook..."
    cp .git/hooks/pre-commit.sample .git/hooks/pre-commit
    cat hooks/pre-commit > .git/hooks/pre-commit
    chmod +x .git/hooks/pre-commit
    echo "Done!"
fi
