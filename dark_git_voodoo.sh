# You shoud change it to use git status --porcelain
# It will me mutch easyer to parse
# git statis -s (short)
# eller
# git statis --porcelain
#
# http://git-scm.com/docs/git-status

# Added by simon


function ask_user_for_action() {
  # you will need tree git sublime or other editor grep cat
  # $1 file or folder
  # $2 string new or modified

  # echo "enterint ask_user_for_action "
  if [[ -d $1 ]]; then
    # echo "$1 is a folder"
    tree $1
    cd $1
    for i in * ; do
      # echo_red_text "$i"
      ask_user_for_action $i new
    done
    cd ..

  elif [[ -f $1 ]]; then
    if [[ "$2" == "new" ]]; then
      printf "=="
      echo_yellow_text $(pwd)/$1 " start ============"
      cat $1
      if [[ -z `cat $1` ]]; then
        echo EMPTY FILE
      fi
      echo "==new to git === File end =="
      read -p "what do you whant to do with $1?" yn
      if [[ $yn == 'add' ]]; then
        git add $1
      elif [[ $yn == 'ch' || $yn == 'checkout' || $yn == 'rm' || $yn == 'remove' ]]; then
        rm $1
      elif [[ $yn == 'subl' || $yn == 'edit' ]]; then
        subl $1
      elif [[ $yn == 'trim' ]]; then
        trim_files $1
      fi
    else
      printf "modified : You are working on "
      echo_yellow_text "$1"
      if [[ $(git diff $1) ]]; then
        git diff $1
        read -p "what do you whant to do?" yn
        if [[ $yn == 'add' ]]; then
          git add $1
        elif [[ $yn == 'ch' || $yn == 'checkout' || $yn == 'rm' || $yn == 'remove' ]]; then
          git checkout -- $1
        elif [[ $yn == 'subl' || $yn == 'edit' ]]; then
          subl $1
        elif [[ $yn == 'trim' ]]; then
          trim_files $1
          ask_user_for_action $1 modifyed
        fi
      fi
    fi
  fi
}

function g {
  # if you not in a repo STOP now
  is_in_git_repo=`git status | grep -v "Not a git repos"`
  is_in_git_repo_error=$?
  reINT='^[0-9]+$'
  if [ $is_in_git_repo_error -ne 0 ] ; then
    echo "I think you are not in a repo: we have an exit code of $is_in_git_repo_error";
    return
  fi

  case $1 in
    '' )
        git status
      ;;
    loop |'lo+([o]*)p' )
        git_status_res_without_delete=$(git status | grep -v 'On branch' | grep -v 'Your branch is' | grep -v 'use "git push" to publish' | grep -v 'Changes to be committed' | grep -v 'use "git reset HEAD' | grep -v 'Changes not staged for' | grep -v 'to update what will be committed' | grep -v 'discard changes in working directory' | grep -v 'include in what will be committed' | grep -v "grep -v 'include in what will be committed'"| grep -v "git branch --unset-upstream" | grep -v "added to commit but untracked files present" | grep -v "nothing to commit, working dir" |     grep -v " deleted: " | grep -v "Your branch and" | grep -v "different commits each, respectively." | grep -v "to merge the remote branch into yours)" | grep -v "You have unmerged paths" | grep -v "(fix conflicts and run " | grep -v "Unmerged paths:" | grep -v "to mark resolution)" | grep -v "renamed: ")

        git_status_res_only_delete=$(git status | grep "deleted: " | awk '{print $2}')

        woirking_on_new_file_for_git=0
        for line in $git_status_res_without_delete; do
          if [[ $line == "modified:" ]]; then
            continue
          fi
          # echo $line
          # echo $woirking_on_new_file_for_git
          # echo Want_to_entered
          if [[ "$line" == "Untracked" ]]; then
              # echo hahhahah
              woirking_on_new_file_for_git=1
          fi

          if [[ -d $line || -f $line ]]; then
            # echo entered
            if [[ "$woirking_on_new_file_for_git" -eq "1" ]]; then
              # echo "$line is a regular file or directory that is new"
              ask_user_for_action $line new
            else
              # echo "$line is a file ordirectory that is modifyed"
              ask_user_for_action $line modifyed
            fi
          fi
          # echo =================
        done
        for file in $git_status_res_only_delete; do
          echo "$file is removed from git"
          read -p "what do you whant to do(rm/re(move from git), add( back),(nothing))?" yn
          if [[ $yn == 'add' ]]; then
            git checkout --  $file
          elif [[ $yn == 'rm' || $yn == 're' || $yn == 'remove' ]]; then
            git rm $file
          fi
        done

        empty_if_ready_to_commit=`git status | grep 'Changes not staged for commit:\|Untracked files:\|nothing to commit, working directory clean\|Unmerged paths:'`
        if [[ -z $empty_if_ready_to_commit ]]; then
          echo  "Working directory is clean, do you want to commit?"
          read -p " enter message to commit/leave blank to continue whitout commit: " yn_pre
          yn=`echo $yn_pre | tr -d '"'`
          if [[ ! -z $yn ]]; then
            echo -e git commit -m \"$yn\"
            git commit -m "$yn"
          fi
        fi

        git status
      ;;
    GLB | Glogbranch)
        echo 'no longer in use'
        return
        currentBranch=$(git branch | grep "*" | awk '{print $2}')

        echo -e "${Cyan}This is what is on $currentBranch but not on $2${NC}"
        git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative $2..$currentBranch

        echo -e "${Cyan}This is what is on $2 but not on $currentBranch${NC}"
        git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative $currentBranch..$2
      ;;
    b | branch)
      last_gitbranch_iter_file=~/tmp/last_gitbranch_iter_file
      # and option to ender name on branch
      var=0
      currentBranch=$(git branch | grep "*" | awk '{print $2}' )

      if [[ -n $2 ]]; then
        if [[ $2 =~ $reINT ]]; then
          if [[ -z `cat $last_gitbranch_iter_file | grep '^\s*$2' ` ]]; then
            echo `cat $last_gitbranch_iter_file | grep "^\s*$2 " | awk '{print $2}'`
            git checkout `cat $last_gitbranch_iter_file | grep "^\s*$2 " | awk '{print $2}'`
          else
            echo "Thit not get a valid int. ($2)"
          fi
          return
        else
          echo $2 is text
          git checkout $2
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
    ;;

    m | merge)
      if [[ -n $2 && $2 =~ $reINT ]]; then
      queryed_branch=$(cat $last_gitbranch_iter_file | grep "^\s*$2" | awk '{print $2}')
        if [[ -n $queryed_branch ]]; then
          read -r -p "Do you want to merge $queryed_branch into $(git branch | grep "*" | awk '{print $2}') ? [y/N] " response
          if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
            git merge --no-ff $queryed_branch
            echo "merge $queryed_branch into $(git branch | grep "*" | awk '{print $2}') with --no-ff"
          fi
        fi
      fi
    ;;

    pull )
      git pull origin $(git branch | grep "*" | awk '{print $2}')
      # echo git pull origin $(git branch | grep "*" | awk '{print $2}')
    ;;
    push )
      git push origin $(git branch | grep "*" | awk '{print $2}')
      # echo git push origin $(git branch | grep "*" | awk '{print $2}')
    ;;
  esac
}
