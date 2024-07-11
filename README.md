# dotfiles repo

### For MacOS step by step

Follow the instructions [a relative link](MacOS.md)

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

#### Clone repos

##### zsh plugins

```
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/zsh/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/zsh-autosuggestions
git clone https://github.com/catppuccin/zsh-syntax-highlighting.git ~/.config/zsh/zsh-syntax-highlighting-catppuccin
```

##### tmux plugins

```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
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
