#!/bin/bash
# install_git_hooks.sh — point this clone's git at .githooks/ (pre-commit = fast local gates). Idempotent; local to the clone.
# Undo: git config --unset core.hooksPath
cd "$(git rev-parse --show-toplevel)" || exit 1
chmod +x .githooks/* 2>/dev/null
git config core.hooksPath .githooks && echo "install_git_hooks: core.hooksPath = .githooks ($(ls .githooks | tr '\n' ' '))"
