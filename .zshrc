# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

autoload -Uz compinit
compinit

### ZSH HOME
export ZSH=$HOME/.zsh

### ---- history config -------------------------------------
export HISTFILE=$ZSH/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

export PATH=$HOME/bin:/usr/local/bin:/snap/bin:/opt/bin:$PATH 
. "$HOME/.powerlevel10k/powerlevel10k.zsh-theme"
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source $ZSH/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $ZSH/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
fpath=($ZSH/plugins/zsh-completions/src $fpath)
rm -f ~/.zcompdump; compinit

eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"

# Silence direnv during initialization to prevent P10k instant prompt issues
export DIRENV_LOG_FORMAT=
eval "$(direnv hook zsh)"
unset DIRENV_LOG_FORMAT
source <(fzf --zsh)
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"
export FZF_ALT_C_OPTS="--preview 'tree -C {}'"
export FZF_COMPLETION_OPTS='--border --info=inline'

function _gcp() {
    if [ -z "$1" ]; then
        echo "Error: Commit message is required"
        return 1
    fi
    git add . && git commit -m "$1" && git push
}

alias ls="eza"
alias :q="exit"
alias mm="tmux new-session -A -s main"
alias nm="${HOME}/.config/tmux-sessionizer"
alias da="direnv allow"
alias lg="lazygit"
alias mr='mise run'
alias en="nvim $(pwd)"
alias ez="nvim ${HOME}/.zshrc"
alias k="kubectl"
alias dc="docker compose"
alias src="source ~/.zshrc"
alias gs="git status"
alias gcp='_gcp'
alias gcpc="gcp checkpoint"
source <(kubectl completion zsh)

. "$HOME/.local/bin/env"

# Load user-specific config if it exists
[[ -f ~/.zshrc.user ]] && source ~/.zshrc.user
