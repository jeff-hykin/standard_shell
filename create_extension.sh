
# provides us with `shell_manager`
. <(curl -fsSL installers/posix.sh || wget -qO- installers/posix.sh)
shell_manager establish_extension <<'HEREDOC'
# this is yaml syntax
name: "YOUR_EXTENSION_NAME"
version: "YOUR_EXTENSION_VERSION"

# 
# all the rest are optional 
# 

# export PATH, but shell-generic
path:
    $inject: [ "/bin" ]             # put at the front (highest priority)
    $append: [ "$HOME/.cargo/bin" ] # put at the back (lowest priority)
    append: [ "$HOME/cargo/bin" ]   # in bash this be '$HOME' instead of "$HOME"

# add a single command instead of adding folder of commands
commands:
    - name: "COMMAND_NAME"
      path: "PATH_TO_COMMAND"

# the lazy way to do shell-specific things (defaults to rc file, defaults to running after existing stuff in rc file)
hardcoded:
    bash: |
        # enabling globbing (just as example)
        shopt -s globstar &>/dev/null # allow ** to search directories
        shopt -s dotglob &>/dev/null  # globbing can see hidden files
    zsh: |
        # enabling globbing (just as example)
        setopt extended_glob &>/dev/null

# lazy way for generic (defaults to running these on_start (similar to rc))
generic:
    # "var", "check", "if", "execute", "exists", "all", "one_of" are from the shell manager API
    
    - var: PATH
      $colon-append: "$HOME/.cargo/bin"
    
    - check:
        if: $exists: "$HOME/.cargo/bin"
        then:
            - var: PATH
              $colon-append: "$HOME/.cargo/bin"

# professional way to do shell-specific things
hardcoded:
    bash:
        rc:
            -
                name: enable_globbing
                placement: [ 5,5,5 ]
                source: |
                    # enabling globbing (just as example)
                    shopt -s globstar &>/dev/null # allow ** to search directories
                    shopt -s dotglob &>/dev/null  # globbing can see hidden files
            -
                name: set_prompt
                placement: [ 9,9,9,1 ]
                source: |
                    export PS1="$ "
        logout:
            -
                name: clear_screen
                placement: [ 9,9,9 ]
                source: |
                    clear
    zsh:
        env:
            -
                name: enable_globbing
                placement: [ 9,9,9 ]
                source: |
                    setopt extended_glob &>/dev/null
        profile:
            - 
                name: welcome_message
                placement: [ 5, 6, 5, ]
                source: |
                    echo "Welcome"

# the professional way to do generic
generic:
    on_start:
        -
            name: add_cargo_bin
            default_placement: [ 4, 2, 2 ]
            do:
                - check:
                    if: $exists: "$HOME/.cargo/bin"
                    then:
                        - var: PATH
                          $colon-append: "$HOME/.cargo/bin"
        -
            name: setup_cuda
            default_placement: [ 7, 2, 5]
            do:
                - check:
                    if: folder_exists: "/usr/local/cuda-10.1/bin/"
                    then:
                        - var PATH
                          $colon-append: "/usr/local/cuda-10.1/bin/"
                        - var LD_LIBRARY_PATH
                          $colon-append: "/usr/local/cuda-10.1/lib64"
                
                # # would look like this in bash:
                # if [ -d "/usr/local/cuda-10.1/bin/" ]; then
                #     export PATH="${PATH}:/usr/local/cuda-10.1/bin/"
                #     export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/cuda-10.1/lib64"
                # fi
HEREDOC