typeset -U path                                   # no duplicate PATH entries
path=("$HOME/.local/bin" $path)
export EDITOR="zed --wait"
BREW=${HOMEBREW_PREFIX:-/opt/homebrew}            # don't fork `brew --prefix` (~150ms)

# --- History ---
HISTFILE=~/.zsh_history
HISTSIZE=200000
SAVEHIST=200000
setopt SHARE_HISTORY EXTENDED_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS
setopt AUTO_CD

# --- Secrets ---
source ~/.zsh_secrets 2> /dev/null

# --- Completion (full security audit + rebuild only once a day, otherwise use the cache) ---
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do compinit; done
compinit -C
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select

# --- Up/Down: search history by what you already typed ---
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search '^[OA' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search '^[OB' down-line-or-beginning-search

# --- Catppuccin Mocha + fzf defaults ---
export BAT_THEME="Catppuccin Mocha"
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A,border:#6C7086,label:#CDD6F4"
export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'      # fast, respects .gitignore
export FZF_CTRL_T_COMMAND='fd --type=f --hidden --strip-cwd-prefix --exclude .git'
export FZF_ALT_C_COMMAND='fd --type=d --hidden --strip-cwd-prefix --exclude .git'
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :300 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --color=always {}'"

# --- Tools ---
eval "$(mise activate zsh)"
eval "$(starship init zsh)"
source <(fzf --zsh)                               # Ctrl-R history, Ctrl-T files, Alt-C cd

# --- ZSH Tools ---
eval "$($BREW/opt/zsh-patina/bin/zsh-patina activate)"
source $BREW/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# --- Aliases ---
alias ls='eza --icons --group-directories-first'
alias ll='eza -l --icons --git --group-directories-first'
alias la='eza -la --icons --git --group-directories-first'
alias lt='eza --tree --level=2 --icons'
alias cat='bat --paging=never --style=plain'
alias ..='cd ..' ...='cd ../..'
alias gs='git status' gd='git diff'
alias cc='claude'
alias k=kubectl

# --- zoxide last: `cd` itself becomes zoxide (replaces alias cd=z), `cdi` = interactive ---
eval "$(zoxide init zsh --cmd cd)"
