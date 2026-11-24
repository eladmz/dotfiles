# MacOS step by step

### Brew
- install brew package manager, follow the instructions

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

- install JetBrainsMono Nerd Font

```
brew install --cask font-jetbrains-mono-nerd-font
```

- install required packages

```
brew install bat eza fd fzf gh git jq derailed/k9s/k9s ripgrep starship wget yq zoxide zsh-autosuggestions zsh-patina 
```

- k9s config files are in
```
~/Library/Application\ Support/k9s/skins/catppuccin-mocha.yaml
~/Library/Application\ Support/k9s/config.yaml
```
