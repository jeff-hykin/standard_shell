# needs: perl, sed, awk

if [[ "$OSTYPE" == "darwin"* ]]; then
    IS_MAC=true
    IS_LINUX=false
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    IS_MAC=false
    IS_LINUX=true
fi

# create a verbal alias
alias previous_succeed='[ $? -eq 0 ]'

function is_command {
    command -v "$@" >/dev/null 2>&1
}

function edit {
    is_command "$EDITOR" && $EDITOR "$@" || is_command 'nano' && nano "$@" || vim "$@"
}

function relative_path {
    # both $1 and $2 are absolute paths beginning with /
    # $1 must be a canonical path; that is none of its directory
    # components may be ".", ".." or a symbolic link
    #
    # returns relative path to $2/$target from $1/$source
    source="$1"
    target="$2"

    common_part=$source
    result=

    while [ "${target#"$common_part"}" = "$target" ]; do
        # no match, means that candidate common part is not correct
        # go up one level (reduce common part)
        common_part=$(dirname "$common_part")
        # and record that we went back, with correct / handling
        if [ -z "$result" ]; then
            result=..
        else
            result=../$result
        fi
    done

    if [ "$common_part" = / ]; then
        # special case for root (no common path)
        result=$result/
    fi

    # since we now have identified the common part,
    # compute the non-common part
    forward_part=${target#"$common_part"}

    # and now stick all parts together
    if [ -n "$result" ] && [ -n "$forward_part" ]; then
        result=$result$forward_part
    elif [ -n "$forward_part" ]; then
        # extra slash removal
        result=${forward_part#?}
    fi

    printf '%s\n' "$result"
}

function absolute_path {
    echo "$(builtin cd "$(dirname "$1")"; pwd)/$(basename "$1")"
}

function del {
    arg1=$1
    args=$@
    # if exists
    if [[ -e $1 ]]
    then
        # if dir
        if [[ -d $1 ]]
        then
            rm -rf $1
        else
            rm $1
        fi
    fi
}

# 
# handy navigation
# 
function cd {
    new_directory="$*";
    if [ $# -eq 0 ]; then
        new_directory=${HOME};
    fi;
    if [[ "$OSTYPE" == "darwin"* ]]; then
        builtin cd "${new_directory}" && ls -lAFG
    elif [[ "$OSTYPE" == "linux-gnu" ]]; then
        builtin cd "${new_directory}" && ls -lAF
    fi
}

function f  {
    args="$@"
    ls -lA | grep "$args"
}

function flocal  {
    args="$@"
    find . -iname "$args"
}

alias ll='ls -lAF'

# list out all the directories in $PATH
function path  {
    echo $PATH | sed 's/:/\
/g'
}

# basically find everything in the current directory, seperate it with \0, and then make the paths relative
function ls0 {
    # escape the current directory for a regex search
    escaped_path="$(pliteral $PWD)"
    # list the dirs seperated by \0             then make each path relative    then remove the first line (its just the current directory)
    find "$PWD" -maxdepth 1 -print0 | perl -p -e 's/\0'$escaped_path'\//\0/g' | psub '^.+?\0' ''
}

# 
# regex
# 
function escape_grep_regex {
    sed 's/[][\.|$(){}?+*^]/\\&/g' <<< "$*"
}

function psub  {
    perl -0pe 's/'"$1"'/'"$2"'/g'
}

# this allows strings to be interpolated with perl regex find
function pliteral  {
    ESCAPED_FORWARDSLASHES=$(psub '\/' '\\\/' <<< $@)
    ESCAPED_DOLLARSIGN=$(psub '\$' '\\\$' <<< $ESCAPED_FORWARDSLASHES)
    ESCAPED_ATSYMBOL=$(psub '\@' '\\\@' <<< $ESCAPED_DOLLARSIGN)
    ESCAPED_ENDESCAPE=$(psub '\\E' '\\\\E' <<< $ESCAPED_ATSYMBOL)
    OUTPUT='\Q'$ESCAPED_ENDESCAPE'\E'
    echo $OUTPUT
}

# Split text up by a specific string or character
function split_by  {
    sed 's/'"$@"'/\'$'\n''/g'
}

function process_on_port {
    lsof -i tcp:$@
}

function most_recent_file {
    ls -1rtp "$@" | egrep '.+[^/]$' | tail -1
}

#
#   Owners and Groups
#
function all_users {
    IS_MAC && dscacheutil -q user
    IS_LINUX && getent passwd
}

function owner_of {
    ls -ld "$@" | awk '{print $3}'
}

function group_of {
    ls -ld "$@" | awk '{print $4}'
}

function set_group_of__file_to__group {
    chgrp $2 $1
}

function members_of {
    awk -F':' '/'"$@"'/{print $4}' /etc/group
}

function add__to__group {
    usermod -a -G $2 $1
}

# 
# shells
# 
function update_bash {
    builtin cd
    source .bash_profile
    source .bashrc
    echo
    echo Bash Updated
}

function update_zsh {
    builtin cd
    source .zshrc
    echo
    echo Zsh Updated
}

function edit_bash {
    edit "$HOME/.bash_profile"
}

function edit_zsh {
    edit "$HOME/.zshrc"
}

function desk {
    cd "$HOME/Desktop"
}