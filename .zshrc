export PATH=/usr/local/Cellar/:/usr/local/bin/:/usr/local/sbin:$HOME/.asdf/shims/:$PATH
export EDITOR=nvim
export VISUAL=nvim

alias ls="ls -l"
alias grep='grep --exclude="*.pyc" --exclude="*.swp" --exclude="*.tfstate.backup" --color=auto --exclude-dir=.terraform --exclude-dir=.git'
alias :q="exit"
alias g="git";
alias dc="docker compose"
alias tf="terraform"
alias tg="terragrunt"
alias k="kubectl"

alias nvim_plugs="nvim +PlugInstall +UpdateRemotePlugins +qa"

eval "$(direnv hook zsh)"

export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export GO111MODULE=auto
export PATH=$PATH:$GOPATH/bin:$HOME/bin

# export FZF_COMPLETION_TRIGGER="z"
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --no-messages -g "!{.git,*.swp,**/.terraform}/*" 2> /dev/null'
export FZF_DEFAULT_OPTS="--bind J:down,K:up --reverse --ansi --multi"

alias wip='dig @resolver4.opendns.com myip.opendns.com +short'
alias wipc='wip | pbcopy;echo copied to clipboard'

# The next line updates PATH for the Google Cloud SDK.
if [ -f '${HOME}/google-cloud-sdk/path.zsh.inc' ]; then . '${HOME}/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '${HOME}/google-cloud-sdk/completion.zsh.inc' ]; then . '${HOME}/google-cloud-sdk/completion.zsh.inc'; fi

