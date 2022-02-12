
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
            do: |
                const { ShellManager } = await import("")
                const { Console, FileSystem } = await import("")
                
                const cargoPath = `${FileSystem.home}/.cargo/bin`
                if (FileSystem.exists(`${FileSystem.home}/.cargo/bin`)) {
                    ShellManager.appendToPath(cargoPath)
                }
            # this^ gets wrapped in a funciton and put inside a file like do_stuff.js
            # then another file is created in the shell's native syntax
            # /bin/bash
            # ./do_stuff.js
            # source "/tmp/shell_manager/$!" # source the compiled output from runnning the shell_manager_js file
HEREDOC