# .bash_profile


# 
# shell-agnostic setup
# 
export SHELL_SOURCE="$HOME/.config/shell/"
export SHELL_STANDARD_ENV_VERSION_MAJOR="0"
export SHELL_STANDARD_ENV_VERSION_MINOR="0"
export SHELL_STANDARD_ENV_VERSION_PATCH="1"

# 
# connect commands
# 
__user_commands_path__="$SHELL_SOURCE/commands"
for file in "$__user_commands_path__/"*
do
    # make sure each command is executable
    chmod ugo+x "$file" &>/dev/null || sudo chmod ugo+x "$file"
done
export PATH="${PATH}:$__user_commands_path__"

__setup_folder__="$SHELL_SOURCE/setup/bash/"

# 
# load setup
# 
mkdir -p "$__setup_folder__/before_start/"
for file in "$__setup_folder__/before_start/"*
do
    # make sure its a file
    if [[ -f "$file" ]]; then
        echo "loading $(basename "$file")"
        source "$file"
    fi
done

# 
# if interactive
# 
__setup_folder__="$SHELL_SOURCE/setup/bash/"
if [[ $- == *i* ]]
then
    # 
    # interactive-only stuff
    # 
    mkdir -p "$__setup_folder__/berfore_interactive_start/"
    for file in "$__setup_folder__/berfore_interactive_start/"*
    do
        # make sure its a file
        if [[ -f "$file" ]]; then
            echo "loading $(basename "$file")"
            source "$file"
        fi
    done
    
    # 
    # login-only
    # 
    if shopt -q login_shell
    then
        mkdir -p "$__setup_folder__/on_login/"
        for file in "$__setup_folder__/on_login/"*
        do
            # make sure its a file
            if [[ -f "$file" ]]; then
                echo "loading $(basename "$file")"
                source "$file"
            fi
        done
    fi
else
    # 
    # non-interactive-only stuff
    # 
    mkdir -p "$__setup_folder__/berfore_non_interactive_start/"
    for file in "$__setup_folder__/berfore_non_interactive_start/"*
    do
        # make sure its a file
        if [[ -f "$file" ]]; then
            source "$file"
        fi
    done
fi