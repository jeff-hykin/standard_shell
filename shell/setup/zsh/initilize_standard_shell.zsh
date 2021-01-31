# 
# Get the path to this file
# 
SOURCE="${(%):-%N}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
    TARGET="$(readlink "$SOURCE")"
    if [[ $TARGET == /* ]]; then
        SOURCE="$TARGET"
    else
        DIR="$( dirname "$SOURCE" )"
        SOURCE="$DIR/$TARGET" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    fi
done
folder_containing_this_file="$PWD/$(dirname $SOURCE)"

#
# move old profile hooks out of the way
#
function move_out_of_the_way {
    if [[ -e "$1" ]]
    then
        local original="$1"
        if [[ -e "$1.old" ]]
        then
            move_out_of_the_way "$1.old"
        fi
        mv "$1" "$1.old"
    fi
}

# 
# link the shell folder
# 
move_out_of_the_way "$HOME/.config/shell"
cp -r "$folder_containing_this_file/../../" "$HOME/.config/shell"

# this is normally protected, don't touch it: etc/profile
# this is normally protected, don't touch it: /etc/bashrc
move_out_of_the_way "$HOME/.zshenv"
move_out_of_the_way "$HOME/.zprofile"
move_out_of_the_way "$HOME/.zlogin"
move_out_of_the_way "$HOME/.zshrc"
move_out_of_the_way "$HOME/.zlogout"

#
# add the minimum number of hooks
#
cp "$folder_containing_this_file/setup.zsh" "$HOME/.zshenv"
cp "$folder_containing_this_file/logout.zsh" "$HOME/.zlogout"
