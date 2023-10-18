# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH=/usr/local/Cellar:/usr/local/bin:/usr/local/sbin:$PATH
export EDITOR=nvim
export VISUAL=nvim
export PROJECT_DIRS=(
  ~/dev
  ~/go/src/github.com/socialviolation
)

source ~/.plugs/.powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
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

eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"
eval "$(rtx activate zsh)"


# TMUX SESSION MANAGER
export PATH=$HOME/.tmux/plugins/t-smart-tmux-session-manager/bin:$PATH
export PATH=$HOME/.config/tmux/plugins/t-smart-tmux-session-manager/bin:$PATH
export T_SESSION_USE_GIT_ROOT="true"


# Auto complete
source ~/.plugs/zsh-autocomplete/zsh-autocomplete.plugin.zsh
bindkey '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete
bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
zstyle ':autocomplete:*complete*:*' insert-unambiguous yes
zstyle ':autocomplete:*history*:*' insert-unambiguous yes
zstyle ':autocomplete:menu-search:*' insert-unambiguous yes
zstyle -e ':autocomplete:list-choices:*' list-lines 'reply=( 8 )'
zstyle ':autocomplete:history-incremental-search-backward:*' list-lines 8
zstyle ':autocomplete:history-search-backward:*' list-lines 8

alias ls="ls -l"
alias :q="exit"
alias mainmux="tmux attach -t main || tmux new-session -t main"
alias vmux="${HOME}/.tmux-sessionizer"

export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export GO111MODULE=auto
export PATH=$PATH:$GOPATH/bin:$HOME/bin

alias wip='dig @resolver4.opendns.com myip.opendns.com +short'
alias wipc='wip | pbcopy;echo copied tsource clipboard'

if [ -f "${HOME}/.user.zshrc" ]; then source "${HOME}/.user.zshrc"; fi

cf() {
    cd $(find ${PROJECT_DIRS} -mindepth 1 -maxdepth 2 -type d | fzf)
}
