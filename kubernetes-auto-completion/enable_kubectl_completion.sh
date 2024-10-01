#!/bin/bash

# Script to enable Kubernetes kubectl auto-completion for bash and zsh.
# This script detects your shell (bash or zsh) and configures kubectl auto-completion.
# After running the script, restart your terminal or run 'source ~/.bashrc' or 'source ~/.zshrc' to apply the changes.

# Detect the shell type
if [ -n "$BASH_VERSION" ]; then
    echo "Enabling kubectl auto-completion for bash..."
    
    # Load bash completion
    if ! source /usr/share/bash-completion/bash_completion 2>/dev/null; then
        echo "Error: bash-completion is not installed. Install it and re-run the script."
        exit 1
    fi

    # Load kubectl completion
    source <(kubectl completion bash)

    # Add kubectl completion to .bashrc to make it persistent
    echo 'source <(kubectl completion bash)' >>~/.bashrc
    echo "Kubernetes auto-completion added to .bashrc."

elif [ -n "$ZSH_VERSION" ]; then
    echo "Enabling kubectl auto-completion for zsh..."

    # Load kubectl completion
    source <(kubectl completion zsh)

    # Add kubectl completion to .zshrc to make it persistent
    echo 'source <(kubectl completion zsh)' >>~/.zshrc
    echo "Kubernetes auto-completion added to .zshrc."

else
    echo "Unsupported shell. This script only supports bash and zsh."
    exit 1
fi

echo "Kubernetes auto-completion enabled. Restart your terminal or run 'source ~/.bashrc' or 'source ~/.zshrc' to apply the changes."
