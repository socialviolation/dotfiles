export ZSH=$HOME/.oh-my-zsh
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="arrow"

DISABLE_AUTO_UPDATE="true"

# plugins=(gitfast poetry yarn zsh zsh-syntax-highlighting) # deprecated with antibody

source $ZSH/oh-my-zsh.sh

# https://github.com/getantibody/antibody/issues/261#issuecomment-533464072
source <(antibody init)
ZSH="$(antibody home)/https-COLON--SLASH--SLASH-github.com-SLASH-robbyrussell-SLASH-oh-my-zsh"

# https://github.com/getantibody/antibody/issues/261#issuecomment-616205908
antibody bundle robbyrussell/oh-my-zsh path:lib path:plugins/gitfast path:plugins/yarn path:plugins/zsh path:plugins/zsh-syntax-highlighting


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias ls="ls --color=auto --group-directories-first"
alias grep='grep --exclude="*.pyc" --exclude="*.swp" --exclude="*.tfstate.backup" --color=auto --exclude-dir=.terraform --exclude-dir=.git'
alias :q="exit"
alias g="git";alias got="git";
alias dc="docker-compose"
alias tf="terraform"
alias k="kubectl"

export FZF_COMPLETION_TRIGGER="z"
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --no-messages -g "!{.git,*.swp,**/.terraform}/*" 2> /dev/null'
export FZF_DEFAULT_OPTS="--bind J:down,K:up --reverse --ansi --multi"


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh