# --- Appearance ---
export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true

# --- Editor ---
export EDITOR=code

# --- History Settings ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory sharehistory
setopt hist_ignore_space hist_ignore_all_dups hist_save_no_dups hist_ignore_dups hist_find_no_dups

# --- Key Bindings ---
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# --- Zinit Plugin Manager (load early for plugin lazy loading) ---
if [[ ! -f ~/.zinit/bin/zinit.zsh ]]; then
  mkdir -p ~/.zinit
  git clone https://github.com/zdharma-continuum/zinit ~/.zinit/bin
fi
source ~/.zinit/bin/zinit.zsh

# --- Plugins (lazy load where possible) ---
zinit wait lucid for zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

# --- Completion System ---
autoload -Uz compinit && compinit -d ~/.zcompdump

zinit wait lucid for \
  joshskidmore/zsh-fzf-history-search \
  Aloxaf/fzf-tab

# --- Completion Styles & FZF-Tab ---
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':completion:*' insert-tab pending
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'

zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' popup-min-size 180 12

function _fzf_tab_cd_preview() {
  if command -v eza &>/dev/null; then
    echo 'eza -1 --color=always ${realpath}'
  elif command -v exa &>/dev/null; then
    echo 'exa -1 --color=always ${realpath}'
  else
    echo 'ls --color=always -1 ${realpath}'
  fi
}
zstyle ':fzf-tab:complete:cd:*' fzf-preview "$(_fzf_tab_cd_preview)"

# --- Better History Search (arrow keys) ---
# Credits: https://coderwall.com/p/jpj_6q/zsh-better-history-searching-with-arrow-keys
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# --- Aliases ---
alias cls='clear'
alias ll='eza -l -g --icons --git'
alias llt='eza -1 --icons --tree --git-ignore --group-directories-first'
alias rg='ripgrep'
alias ssh='ssh.exe'
alias ssh-add='ssh-add.exe'
alias op='op.exe'
alias open='explorer.exe'
alias winget='winget.exe'
alias cda='zoxide add'
alias cdq='zoxide query'
alias cdr='zoxide remove'
alias gitlab-runner='gitlab-runner.exe'
path+=('/home/richard/.dotnet/tools')
path+=('/usr/local/texlive/2025/bin/x86_64-linux')
export PATH

# --- Starship Prompt ---
eval "$(starship init zsh)"

# --- Zoxide ---
eval "$(zoxide init zsh --cmd cd)"

# --- Atuin (better shell history) ---
function _atuin_precmd() {
  if command -v atuin &>/dev/null; then
    eval "$(atuin init zsh)"
    unset -f _atuin_precmd
  fi
}
precmd_functions+=(_atuin_precmd)

# --- Python venv auto-activation ---
function auto_venv_activate() {
    if [[ -f .venv/bin/activate ]]; then
        source .venv/bin/activate
    fi
}
autoload -U add-zsh-hook
add-zsh-hook chpwd auto_venv_activate
auto_venv_activate

# --- Custom Environment ---
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

if [ -e /home/richard/.nix-profile/etc/profile.d/nix.sh ]; then . /home/richard/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
