
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

JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
PLAY2_HOME=$HOME/Development/play

export JAVA_HOME PLAY2_HOME

PATH=/usr/local/bin:$PATH:$PLAY2_HOME

# Python settings

export PIP_REQUIRE_VIRTUALENV=true

# DOCKER

eval $(docker-machine env dev)
alias docker-env='eval $(docker-machine env dev)'
