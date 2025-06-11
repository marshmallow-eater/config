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

fish_add_path /usr/bin/ruby
fish_add_path "$HOME/.local/share/gem/ruby/3.0.0/bin"

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
fzf_configure_bindings --directory=\ct
# 
set -x PATH "$HOME/.rbenv/bin" $PATH
rbenv init - | source
