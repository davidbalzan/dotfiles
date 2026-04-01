# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS SHARE_HISTORY HIST_REDUCE_BLANKS

# Completion
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select

# Key bindings
bindkey -e
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Aliases
alias ls='eza --icons'
alias ll='eza -la --icons'
alias lt='eza -T --icons'
alias cat='bat --style=plain'
alias grep='rg'
alias find='fd'
alias cd='z'

# Path
export PATH="$HOME/.local/bin:$PATH"

# Tools
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

# Autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax highlighting (must be at end of .zshrc)
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
alias code="codium"
