# fish is lovely but not that compatible with bash.
# Here we try and put all the best bits of fish in zsh.
# 
# The following lines were added by compinstall
zstyle :compinstall filename '/home/gilescope/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit


setopt autocd
# Appends every command to the history file once it is executed
setopt inc_append_history
# Reloads the history whenever you use it
setopt share_history

alias tig="tig status"
alias s="git status"
alias ci="clear && RUSTFLAGS=\"-Dwarnings\" SKIP_WASM_BUILD=1 mold --run cargo"
alias c="clear && SKIP_WASM_BUILD=1 mold --run cargo"
alias m="~/m.sh"
alias nix-shell="nix-shell --run $SHELL"
alias dir="ls -l"
alias md="mkdir"

function cargoenvhere {
  dirname="$(basename $(pwd))"
  echo "Cargo as a virtual environment in" "$dirname" "dir"
  docker volume inspect cargo-cache > /dev/null || docker volume create cargo-cache
  docker run --rm -it -w /shellhere/"$dirname" \
                    -v "$(pwd)":/shellhere/"$dirname" \
                    -v cargo-cache:/cache/ \
                    -e CARGO_HOME=/cache/cargo/ \
                    -e SCCACHE_DIR=/cache/sccache/ "$@"
}




# Make sure that the terminal is in application mode when zle is active, since
# only then values from $terminfo are valid
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init() {
    echoti smkx
  }
  function zle-line-finish() {
    echoti rmkx
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

# Use emacs key bindings
bindkey -v

#autoload -U select-word-style
#select-word-style bash
bindkey '^H' backward-kill-word
bindkey '^[[3;5~' kill-word

#bindkey '^V' 
#bindkey -M viins '^H' kill-line

# [PageUp] - Up a line of history
if [[ -n "${terminfo[kpp]}" ]]; then
  bindkey -M emacs "${terminfo[kpp]}" up-line-or-history
  bindkey -M viins "${terminfo[kpp]}" up-line-or-history
  bindkey -M vicmd "${terminfo[kpp]}" up-line-or-history
fi
# [PageDown] - Down a line of history
if [[ -n "${terminfo[knp]}" ]]; then
  bindkey -M emacs "${terminfo[knp]}" down-line-or-history
  bindkey -M viins "${terminfo[knp]}" down-line-or-history
  bindkey -M vicmd "${terminfo[knp]}" down-line-or-history
fi

bindkey -M viins "^V" quoted-insert

# Start typing + [Up-Arrow] - fuzzy find history forward
if [[ -n "${terminfo[kcuu1]}" ]]; then
  autoload -U up-line-or-beginning-search
  zle -N up-line-or-beginning-search

  bindkey -M emacs "${terminfo[kcuu1]}" up-line-or-beginning-search
  bindkey -M viins "${terminfo[kcuu1]}" up-line-or-beginning-search
  bindkey -M vicmd "${terminfo[kcuu1]}" up-line-or-beginning-search
fi
# Start typing + [Down-Arrow] - fuzzy find history backward
if [[ -n "${terminfo[kcud1]}" ]]; then
  autoload -U down-line-or-beginning-search
  zle -N down-line-or-beginning-search

  bindkey -M emacs "${terminfo[kcud1]}" down-line-or-beginning-search
  bindkey -M viins "${terminfo[kcud1]}" down-line-or-beginning-search
  bindkey -M vicmd "${terminfo[kcud1]}" down-line-or-beginning-search
fi

# [Home] - Go to beginning of line
if [[ -n "${terminfo[khome]}" ]]; then
  bindkey -M emacs "${terminfo[khome]}" beginning-of-line
  bindkey -M viins "${terminfo[khome]}" beginning-of-line
  bindkey -M vicmd "${terminfo[khome]}" beginning-of-line
fi
# [End] - Go to end of line
if [[ -n "${terminfo[kend]}" ]]; then
  bindkey -M emacs "${terminfo[kend]}"  end-of-line
  bindkey -M viins "${terminfo[kend]}"  end-of-line
  bindkey -M vicmd "${terminfo[kend]}"  end-of-line
fi

# [Shift-Tab] - move through the completion menu backwards
if [[ -n "${terminfo[kcbt]}" ]]; then
  bindkey -M emacs "${terminfo[kcbt]}" reverse-menu-complete
  bindkey -M viins "${terminfo[kcbt]}" reverse-menu-complete
  bindkey -M vicmd "${terminfo[kcbt]}" reverse-menu-complete
fi

# [Backspace] - delete backward
bindkey -M emacs '^?' backward-delete-char
bindkey -M viins '^?' backward-delete-char
bindkey -M vicmd '^?' backward-delete-char
# [Delete] - delete forward
if [[ -n "${terminfo[kdch1]}" ]]; then
  bindkey -M emacs "${terminfo[kdch1]}" delete-char
  bindkey -M viins "${terminfo[kdch1]}" delete-char
  bindkey -M vicmd "${terminfo[kdch1]}" delete-char
else
  bindkey -M emacs "^[[3~" delete-char
  bindkey -M viins "^[[3~" delete-char
  bindkey -M vicmd "^[[3~" delete-char

  bindkey -M emacs "^[3;5~" delete-char
  bindkey -M viins "^[3;5~" delete-char
  bindkey -M vicmd "^[3;5~" delete-char
fi

# [Ctrl-Delete] - delete whole forward-word
bindkey -M emacs '^[[3;5~' kill-word
bindkey -M viins '^[[3;5~' kill-word
bindkey -M vicmd '^[[3;5~' kill-word

# [Ctrl-RightArrow] - move forward one word
bindkey -M emacs '^[[1;5C' forward-word
bindkey -M viins '^[[1;5C' forward-word
bindkey -M vicmd '^[[1;5C' forward-word
bindkey -M viins '^i' forward-word
# [Ctrl-LeftArrow] - move backward one word
bindkey -M emacs '^[[1;5D' backward-word
bindkey -M viins '^[[1;5D' backward-word
bindkey -M vicmd '^[[1;5D' backward-word
bindkey -M viins '^u' backward-kill-word
function myls {
    [[ "$CONTEXT" = cont ]] && return
    zle push-input
    zle -R
    zle accept-line
    print -n $(ls --color=always --indicator-style=slash)
}

zle -N myls
bindkey -- '^[l' myls


#bindkey "\M-\e0B" backward-word
#bindkey "\M-\e0D" forward-word

git_prompt() {
  ref="@$(git symbolic-ref HEAD 2> /dev/null | cut -d'/' -f3 2> /dev/null )"
  #if [[ ref != "fatal: not a git repository (or any of the parent directories): .git" ]] ; then
    echo $ref
  #fi
}
source "$HOME/.config/zsh/plugins/zsh-system-clipboard/zsh-system-clipboard.zsh"
setopt prompt_subst
PROMPT='$SHLVL%F{green}%0~%f$(git_prompt)> '
RPROMPT="%(?..%F{red}%?.DONT PANIC%f)"

#prompt_nix_shell_setupprompt_nix_shell_setup
#export ZSH_SYSTEM_CLIPBOARD_TMUX_SUPPORT=true
export PATH=$HOME/.cargo/bin:$HOME/.radicle/bin:$PATH
export RUST_BACKTRACE=1
#export RUST_LOG=info
export BROWSER=firefox
export SSH_AUTH_SOCK="/run/user/1000/gnupg/S.gpg-agent.ssh"
eval "$(direnv hook zsh)"
