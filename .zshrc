export ZSH=$HOME/.oh-my-zsh
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="arrow"
plugins=()

source $ZSH/oh-my-zsh.sh

export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

alias wg="wargames"
alias ls="ls -l"
alias grep='grep --exclude="*.pyc" --exclude="*.swp" --exclude="*.tfstate.backup" --color=auto --exclude-dir=.terraform --exclude-dir=.git'
alias :q="exit"
alias g="git";
alias dc="docker compose"
alias tf="terraform"
alias tg="terragrunt"
alias k="kubectl"
alias setup_esp='. $HOME/esp/esp-idf/export.sh'
alias nvim_plugs="nvim +PlugInstall +UpdateRemotePlugins +qa"
source <(kubectl completion zsh)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
complete -F __start_kubectl k

eval "$(direnv hook zsh)"

export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export GO111MODULE=auto
export PATH=$PATH:$GOPATH/bin:$HOME/dev/flutter/bin
export IDF_PATH=$HOME/esp/esp-idf
export JAVA_HOME=`/usr/libexec/java_home`

# export FZF_COMPLETION_TRIGGER="z"
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --no-messages -g "!{.git,*.swp,**/.terraform}/*" 2> /dev/null'
export FZF_DEFAULT_OPTS="--bind J:down,K:up --reverse --ansi --multi"
. $HOME/dev/z/z.sh

export PATH=/usr/local/Cellar/:/usr/local/bin/:/usr/local/sbin:$HOME/Library/Android/sdk/tools/bin/:$HOME/Library/Android/sdk/emulator/:/usr/local/bin/python3:$HOME/esp/esp-idf/tools:$PATH

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/nickfreemantle/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/nickfreemantle/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/nickfreemantle/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/nickfreemantle/google-cloud-sdk/completion.zsh.inc'; fi

alias myip=dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | awk -F'"' '{ print $2}'
