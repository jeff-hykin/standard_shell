## What problem does this repo solve?

Have you ever needed to edit your `.bashrc` or `.bashprofile` just as part of an installation step, and thought "there's got to be a better way to automate this"?
Right now a tool that wants to do ANYTHING that modifies your shell (permantly) has to edit miscellaneous files in an unstructured guess-and-check way.

#### Problems:
- Figuring out which-tool-added-what-code is impossible to do reliably
- All auto-edit-shell scripts are shell-specific, even if the operation itself (like setting an ENV var) is generic to POSIX
- "Uninstalling" code that was added to the bash profile is error prone and unstructured (grepping the file, searching for delimiters)
- Adding code BEFORE some 3rd party shell-startup tasks but AFTER other shell-startup tasks is completely impractial, because there's no way to consistently detect code added by other tools
- Adding text without duplicating an entry is a pain
- User-added code often looks the same as automatically-added code
- Allowing any user program to edit profile/rc-files is a huge security risk 
    1. Half the time users don't even know its being edited
    2. Failing to fully understanding all commands being added effectively hands attacker the keys
        - they can search for private keys
        - they can create a wrapper around `sudo` and extract the user's password
        - (these are effortless)
    3. Sometimes its not even intentional, but they screw up the path and prioritize other binaries over core system commands


It is 2022, we should NOT be echoing text into a bash profile like neanderthals.

## Who can use it?
Anyone on a POSIX system with either `curl` or `wget` (aka, everything but Windows)

## How do I install/use it?

FIXME: there will be a single script to run that will create the following folder structure:

```
$HOME/
    settings/
        commands/
        shell_manager/
            default_shell
            protected_commands/
            hash_checks/
            extensions/
                extension1/
                    0.0.1/
                        hooks/
                            generic/
                            basic/
                            versioned/
                        executables/
                            hello_world
        shells/
            bash/
                5.1.8/
                    info/
                        executable_path
                    home/
                        .bashrc
                        .profile
                        .bash_logout
                        .bash_login
                        .bash_profile
                    interface/
                        execute
                        get_var
                        set_var
                    events/
                        profile/
                        rc/
                        login/
                        logout/
            zsh/
                5.8/
            
```


Download this repository, and then run the "initilize_standard_shell.bash" file that is inside `shell -> setup -> bash`. If your comfy with the command line:
```
git clone https://github.com/jeff-hykin/standard_shell.git
zsh standard_shell/shell/setup/zsh/initilize_standard_shell.zsh
```

## How does it work?
Instead of every program needing to edit a single file (like a bash profile) a file can be added to the `~/.config/shell/setup/bash/before_start` folder, (or alternatively the `~/.config/shell/setup/zsh/before_start` folder etc). This way the commands added by one program dont get confused or mixed up when added by another program.

### What about order? 
Order is very important. Currently the files are merely sorted in alphanumerical order, and each file is expected to start with `00_00_` where the `0`s are number-based priority (0 being the highest).