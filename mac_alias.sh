alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'


alias cdsubl='cd ~/dev/sublime_folder/Packages/'
alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'

eval "$(rbenv init -)"
export PATH="/usr/local/git/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:$PATH"
