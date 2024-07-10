# dotfiles repo

### Requirements
#### Nerd Fond
```
https://www.nerdfonts.com/font-downloads
```
#### Packages

```
alacritty
bat
delta
eza
fd
fzf
git
k9s
lazygit
neovim
nvm
ripgrep
starship
stow
tmux
zoxide
zsh
```

### Symlink the dotfiles repo

```
stow .
```

### Use the gitconfig

```
nvim ~/.gitconfig

[include]
  path = ~/.config/gitconfig/eladmz.gitconfig
```
