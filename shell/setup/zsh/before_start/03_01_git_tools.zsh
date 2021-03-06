function git_delete_changes {
    # unstage everything
    git reset --
    $result="$(git stash save --keep-index --include-untracked)"
    # stash everything and delete stash
    if [[ $result == "No local changes to save" ]] 
    then
        echo no changes to delete
    else
        git stash drop
    fi
}

# git push && git pull
function git_sync {
    args="$@"
    if [[ $args = "" ]]; then
        git add -A && git commit -m "-";git pull --no-edit;git push
    else
        git add -A && git commit -m "$args";git pull --no-edit;git push
    fi
}

function git_force_push {
    args="$@"
    git push origin $args --force
}

function git_force_pull { 
    # get the latest
    git fetch --all
    # delete changes
    git_delete_changes
    # reset to match origin
    git reset --hard "origin/$(git_current_branch_name)"
}

function git_new_branch {
    git checkout master && git checkout -b "$@" && git push --set-upstream origin "$@"
}

# 
# short names
# 
alias gs="git status"
alias gp="git_sync"
alias gm="git merge"
alias gfpull="git_force_pull"
alias gfpush="git_force_push"
alias gc="git checkout"
alias gb="git branch"
alias gnb="git_new_branch"
alias gd="git_delete_changes"
alias gcp="git add -A;git stash"
alias gpst="git stash pop;git add -A"
alias gundo="git reset --soft HEAD~1"