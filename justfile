help:
  just --help

brew-dump:
  brew bundle dump --file $HOME/.Brewfile -f

brew-restpre:
  brew bundle --file=$HOME/.Brewfile

asdf-dump:
  asdf-plugin-manager export > $HOME/.plugin-versions

asdf-restore:
  asdf-plugin-manager add-all

