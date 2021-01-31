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
        # if something is in the way, move it out of the way
        # (recursively)
        if [[ -e "$1.old" ]]
        then
            move_out_of_the_way "$1.old"
        fi
        
        # now that anything that would be in the way
        # has been moved
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
move_out_of_the_way "$HOME/.profile"
move_out_of_the_way "$HOME/.bash_profile"
move_out_of_the_way "$HOME/.bash_login"
move_out_of_the_way "$HOME/.bashrc"
move_out_of_the_way "$HOME/.bash_logout"

# 
# add the minimum number of hooks
# 
cp "$folder_containing_this_file/setup.bash" "$HOME/.bash_profile"
cp "$folder_containing_this_file/logout.bash" "$HOME/.bash_logout"