# --- ENVIRONMENT VARIABLES (Global) ---
# Use -gx (global export) instead of -Ux (universal export)
set -gx EDITOR nvim
set -gx VISUAL nvim

# Suppress the welcome message
set -g fish_greeting ""

# NVM Defaults
set -g nvm_default_version 22
set -g nvm_default_packages pnpm

# --- FUNCTIONS / ABBREVIATIONS ---

# Using 'alias' or 'abbr' is often cleaner for simple replacements
alias vim='nvim'
alias htop='btop'
alias diff='git diff'

# Force-remove all local branches
function remove_branches
    git branch | xargs git branch -D
end

# Clipboard (X11)
function pbcopy
    xsel --clipboard --input
end

function pbpaste
    xsel --clipboard --output
end

function snake
    nsnake
end

# Git "send"
function send
    if test (count $argv) -eq 0
        echo "Please provide a commit message"
        return 1
    end

    git add --all
    git commit -am "$argv"
    git push origin HEAD
end

# TheFuck Integration
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
    # Load fzf keybindings
    if type -q fzf
        fzf --fish | source
    end

    # FZF UI Customization
    set -g FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS --layout=reverse"
end
