set -U fish_greeting
set --universal nvm_default_version 22
set --universal nvm_default_packages pnpm

function vim
	nvim $argv
end

function diff
	git diff
end

function remove_branches
	git branch | xargs git branch -D
end

function pbcopy
	xsel --clipboard --input
end

function pbpaste
	xsel --clipboard --output
end

function send
	if test (count $argv) -eq 0
		echo "Please, provide commit message"
	end

	git add --all
	git commit -am $argv
	git push origin HEAD
end

function fuck -d "Correct your previous console command"
  set -l fucked_up_command $history[1]
  env TF_SHELL=fish TF_ALIAS=fuck PYTHONIOENCODING=utf-8 thefuck $fucked_up_command THEFUCK_ARGUMENT_PLACEHOLDER $argv | read -l unfucked_command
  if [ "$unfucked_command" != "" ]
    eval $unfucked_command
    builtin history delete --exact --case-sensitive -- $fucked_up_command
    builtin history merge
  end
end

if status is-interactive

end
# Set user paths for bun and rbenv
set -Ux fish_user_paths $HOME/.bun/bin $HOME/.rbenv/bin $fish_user_paths
set -Ux EDITOR nvim
set -Ux VISUAL nvim

# Initialize rbenv
status --is-interactive; and rbenv init - | source
