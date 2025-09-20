#!/usr/bin/env bash
#Always Show Hidden Files in Finder
# defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder


# mkdir -p ~/Documents/Screenshots
#Screenshots location
defaults write com.apple.screencapture location ~/Documents/Screenshots/

# #Quit finder
# defaults write com.apple.finder QuitMenuItem -bool TRUE && killall Finder

