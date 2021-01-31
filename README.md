## What problem does this repo solve?

Note this repo is still in alpha. If you've ever needed to edit your path, add a new command, set and environment variable, you've probably had to deal with bash/zsh/shell profiles. Right now programs have to tell YOU to make those changes because the status-quo is jank mess. This repo is a alpha attempt at standardizing things in a way that allow for automated PATH/ENV/command changes while also being transparent to the user about what is going on.

## Who can use it?
Hopefully anyone on a unix based systems (including WSL)

## How do I install/use it?
Download this repository, and then run the "initilize_standard_shell.bash" file that is inside `shell -> setup -> bash`. If your comfy with the command line:
```
git clone https://github.com/jeff-hykin/standard_shell.git
bash standard_shell/shell/setup/bash/initilize_standard_shell.bash
```

## How does it work?
Instead of every program needing to edit a single file (like a bash profile) a file can be added to the `~/.config/shell/setup/bash/before_start` folder, (or alternatively the `~/.config/shell/setup/zsh/before_start` folder etc). This way the commands added by one program dont get confused or mixed up when added by another program.

### What about order? 
Order is very important. Currently the files are merely sorted in alphanumerical order, and each file is expected to start with `00_00_` where the `0`s are number-based priority (0 being the highest).