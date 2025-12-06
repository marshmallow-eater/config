# --- UNIVERSAL VARIABLES ---
# Suppress the welcome message
set -U fish_greeting

# Set universal defaults for nvm
set --universal nvm_default_version 22
set --universal nvm_default_packages pnpm

# Set user paths for bun and rbenv
set -Ux fish_user_paths $HOME/.bun/bin $HOME/.rbenv/bin $fish_user_paths

# Set the preferred editor
set -Ux EDITOR nvim
set -Ux VISUAL nvim

# --- FUNCTIONS/ALIASES ---

# Alias 'vim' to 'nvim'
function vim
    nvim $argv
end

function htop
    btop $argv
end

# Alias 'diff' to 'git diff'
function diff
    git diff $argv
end

# Force-remove all local branches (Use with caution!)
function remove_branches
    git branch | xargs git branch -D
end

# Copy to clipboard (requires xsel)
function pbcopy
    xsel --clipboard --input
end

# Paste from clipboard (requires xsel)
function pbpaste
    xsel --clipboard --output
end

# Git "send" (add all, commit, push HEAD)
function send
    if test (count $argv) -eq 0
        echo "Please, provide a commit message"
        return 1
    end

    git add --all
    # Use $argv instead of $argv[1] to allow multi-word messages
    git commit -am $argv
    git push origin HEAD
end

# Correct your previous console command (requires TheFuck)
function fuck -d "Correct your previous console command"
    set -l fucked_up_command $history[1]
    env TF_SHELL=fish TF_ALIAS=fuck PYTHONIOENCODING=utf-8 thefuck $fucked_up_command THEFUCK_ARGUMENT_PLACEHOLDER $argv | read -l unfucked_command
    if [ "$unfucked_command" != "" ]
        eval $unfucked_command
        builtin history delete --exact --case-sensitive -- $fucked_up_command
        builtin history merge
    end
end

# --- INTERACTIVE SESSION INITIALIZATION ---

if status is-interactive
    # Initialize rbenv (moved here from the end of the file)
    rbenv init - | source

    # Load fzf keybindings for Ctrl+R (history) and Ctrl+T (files)
    # This dynamically generates and sources the required 'bind' commands.
    if type -q fzf
        fzf --fish | source
    end

    # Add other interactive-only setup here
end
