# MacOS step by step

- install brew package manager, follow the instructions

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

- install JetBrainsMono Nerd Font

```
brew install --cask font-jetbrains-mono-nerd-font
```

- install alacritty terminal emulator

```
brew install --cask alacritty
```

- try to run alacritty, if it's not working, please open it via Finder and Allow all

- install all other packages

```
brew install bat delta eza fd fzf git k9s lazygit neovim nvm ripgrep starship stow tmux zoxide zsh
```

- clone zsh plugins repos

```
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/zsh/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/zsh-autosuggestions
git clone https://github.com/catppuccin/zsh-syntax-highlighting.git ~/.config/zsh/zsh-syntax-highlighting-catppuccin
```

- clone tmux plugin manager

```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

- clone this repo

```
git clone https://github.com/eladmz/dotfiles.git ~/dotfiles
```

- run this commands to create symlinks

```
cd ~/dotfiles
stow .
```

- if the step above didn't work, try the following

```
cp ~/.zshrc ~/.zshrc.bak
rm ~/.zshrc
sudo stow .
```

- apply catppuccin theme to bat

```
bat cache --build
```

- apply the gitconfig (add to the top of the file)

```
vim ~/.gitconfig

[include]
  path = ~/.config/gitconfig/eladmz.gitconfig
```

- run alacritty and ENJOY :)
