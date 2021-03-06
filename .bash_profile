
# GIT-prompt
############

# Configure colors, if available.
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    c_reset='\[\e[0m\]'
    c_user='\[\e[1;33m\]'
    c_path='\[\e[0;33m\]'
    c_git_cleancleann='\[\e[0;36m\]'
    c_git_dirty='\[\e[0;35m\]'
else
    c_reset=
    c_user=
    c_git_cleancleann_path=
    c_git_clean=
    c_git_dirty=
fi

# Function to assemble the Git parsingart of our prompt.
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

# Thy holy prompt.
PROMPT_COMMAND='PS1="${c_user}\u${c_reset}@${c_user}\h${c_reset}:${c_path}\w${c_reset}$(git_prompt)\$ "'


# TZ settings
export TZ=/usr/share/zoneinfo/Europe/Stockholm
alias TZ-UTC=TZ=/usr/share/zoneinfo/UTC
alias TZ-NYC=TZ=/usr/share/zoneinfo/America/New_York
alias TZ-STH=TZ=/usr/share/zoneinfo/Europe/Stockholm


# Java settings
alias JAVA_7=JAVA_HOME=$(/usr/libexec/java_home -v 1.7)
alias JAVA_8=JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
alias JAVA_9=JAVA_HOME=$(/usr/libexec/java_home -v 9)
alias JAVA_10=JAVA_HOME=$(/usr/libexec/java_home -v 10)

JAVA_HOME=$(/usr/libexec/java_home -v 10)

export JAVA_HOME

PATH=/usr/local/bin:/usr/local/sbin:$PATH:/usr/local/share/git-core/contrib/diff-highlight:~/bin

# Python settings

export PIP_REQUIRE_VIRTUALENV=true

# GPG

if [ -S "${GPG_AGENT_INFO%%:*}" ]; then
    export GPG_AGENT_INFO
else
    type gpg-agent >/dev/null 2>&1 && eval $( gpg-agent --daemon )
fi


# DOCKER

#docker-machine ls -q | grep -q dev && eval $(docker-machine env dev)
#alias docker-env='eval $(docker-machine env dev)'


# SSH-agent
eval "$(ssh-agent)"
ssh-add -A

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

source <(kubectl completion bash)

