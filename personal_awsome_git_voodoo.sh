reINT='^[0-9]+$'
last_gitbranch_iter_file=~/tmp/last_gitbranch_iter_file



unset -f git_log_two_branches
git_log_two_branches(){
  currentBranch=$(git branch | grep "*" | awk '{print $2}')

  echo -e "${Cyan}This is what is on $currentBranch but not on $1${NC}"
  git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative $1..$currentBranch

  echo -e "${Cyan}This is what is on $1 but not on $currentBranch${NC}"
  git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative $currentBranch..$1
}



unset -f list_branches
function list_branches() {
  var=0
  currentBranch=$(git branch | grep "*" | awk '{print $2}' )

  if [[ -n $1 ]]; then
    if [[ $1 =~ $reINT ]]; then
      if [[ -z `cat $last_gitbranch_iter_file | grep '^\s*$1' ` ]]; then
        echo `cat $last_gitbranch_iter_file | grep "^\s*$1 " | awk '{print $2}'`
        git checkout `cat $last_gitbranch_iter_file | grep "^\s*$1 " | awk '{print $2}'`
      else
        echo "Thit not get a valid int. ($1)"
      fi
      return
    else
      echo $1 is text
      git checkout $1
      return
    fi
  else
    truncate_file $last_gitbranch_iter_file
  fi

  for branch in `git branch | sed 's/^..//'`; do
    if [[ $var -lt 10 ]]; then
      if [[ $branch == $currentBranch ]]; then
        echo_blue_text " $var $branch (current branch)"
        echo " $var $branch  (current branch)" >> $last_gitbranch_iter_file
      else
        echo " $var $branch "
        echo " $var $branch " >> $last_gitbranch_iter_file
      fi
    else
      if [[ $branch == $currentBranch ]]; then
        echo_blue_text "$var $branch (current branch)"
        echo "$var $branch (current branch)" >> $last_gitbranch_iter_file
      else
        echo "$var $branch "
        echo "$var $branch " >> $last_gitbranch_iter_file
      fi
    fi
    var=$(($var + 1))
  done
}

unset -f delete_branch
function delete_branch() {
  currentBranch=$(git branch | grep "*" | awk '{print $2}' )

  if [[ -n $1 ]]; then
    if [[ $1 =~ $reINT ]]; then
      if [[ -z `cat $last_gitbranch_iter_file | grep '^\s*$1' ` ]]; then
        echo `cat $last_gitbranch_iter_file | grep "^\s*$1 " | awk '{print $2}'`
        git branch -d `cat $last_gitbranch_iter_file | grep "^\s*$1 " | awk '{print $2}'`
      else
        echo "Thit not get a valid int. ($1)"
      fi
      return
    else
      echo $1 is text
      git branch -d $1
      return
    fi
  fi
}

alias GLB="git_log_two_branches"
alias gb="list_branches"
alias gbd="delete_branch"
