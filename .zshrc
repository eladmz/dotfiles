export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=$HISTSIZE

# History
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
# End History

source ~/.zsh_extra 2> /dev/null

source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

export FZF_DEFAULT_OPTS=" \
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"
source <(fzf --zsh)

eval "$(starship init zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

alias k="kubectl"
alias pods="kubectl get pods -A"
alias svc="kubectl get services -A"
alias ingress="kubectl get secrets -A"
alias kctx="kubectl config use-context"
alias kconf="kubectl config get-contexts -o name"

alias ls="eza --icons=always"

alias lg="lazygit"

alias mk="minikube"

source ~/.config/zsh/zsh-syntax-highlighting/themes/catppuccin_macchiato.zsh
source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
