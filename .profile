os_raw="$(uname -s)"
case "${os_raw}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    *)          machine="UNKNOWN:${unameOut}"
esac

# append to the history file, don't overwrite it
shopt -s histappend
unset HISTCONTROL
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

export EDITOR=vi


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# Configure colors, if available.                                                                                                                          
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    c_reset='\[\e[0m\]'
    c_user='\[\e[1;33m\]'
    c_path='\[\e[0;33m\]'
    c_git_cleancleann='\[\e[0;36m\]'
    c_git_dirty='\[\e[0;35m\]'
    c_k8s='\[\e[2;33m\]'
else
    c_reset=
    c_user=
    c_git_cleancleann_path=
    c_git_clean=
    c_git_dirty=
    c_k8s=
fi

git_prompt ()
{
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
    return 0
    fi

    git_branch=$(git branch 2>/dev/null | sed -n '/^\*/s/^\* //p')

    if git diff --quiet 2>/dev/null >&2; then
    git_color="$c_git_clean"
    else
    git_color="$c_git_dirty"
    fi

    echo "[$git_color$git_branch${c_reset}]"
}

k8_prompt ()
{
    cluster=$(kubectl ctx -c)
    ns=$(kubectl ns -c)
    echo "${c_k8s}$cluster/$ns${c_reset}"
}

# Thy holy prompt.
PROMPT_COMMAND='PS1="${c_user}\u${c_reset}@$(k8_prompt):${c_path}\w${c_reset}$(git_prompt)\$ "'

# TZ settings                                                                                                                                              
export TZ=/usr/share/zoneinfo/Europe/Stockholm
alias TZ-UTC=TZ=/usr/share/zoneinfo/UTC
alias TZ-NYC=TZ=/usr/share/zoneinfo/America/New_York
alias TZ-STH=TZ=/usr/share/zoneinfo/Europe/Stockholm


PATH=${PATH}:/opt/homebrew/Cellar/git/$(git version | cut -d" " -f 3)/share/git-core/contrib/diff-highlight/diff-highlight
PATH=${PATH}:~/bin
export PATH="$PATH:/Users/magru/Library/Application Support/JetBrains/Toolbox/scripts"

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Brew Bash completion config
if type brew &>/dev/null
then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
  then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
    do
      [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
    done
  fi
fi


# Python settings
export PIP_REQUIRE_VIRTUALENV=true
export PIPENV_VENV_IN_PROJECT=1
export PIPENV_VERBOSITY=-1

# Go settings
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Rust settings
. "$HOME/.cargo/env"


# Kubernetes
if command -v kubectl > /dev/null; then
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
alias k=kubectl
source <(kubectl completion bash)
fi


# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/magru/.lmstudio/bin"
# End of LM Studio CLI section

