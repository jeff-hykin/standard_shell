if [[ -n "$SHELL_SOURCE" ]]
then
    __setup_folder__="$SHELL_SOURCE/setup/bash/"
    # 
    # interactive-only stuff
    # 
    mkdir -p "$__setup_folder__/on_logout/"
    for file in "$__setup_folder__/on_logout/"*
    do
        # make sure its a file
        if [[ -f "$file" ]]; then
            source "$file"
        fi
    done
fi