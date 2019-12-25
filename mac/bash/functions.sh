#!/usr/bin/env bash

MY_PIANO_MODE_HOME="$1"
MAC_HOME="$MY_PIANO_MODE_HOME/mac"
MAC_BASH_HOME="$MAC_HOME/bash"
MAC_BASHRC="$MAC_BASH_HOME/rc"

function aoeu() {
  #sh "$MAC_SEIL_DEFAULT";
  /Applications/Karabiner.app/Contents/Library/bin/karabiner select_by_name "Default Key Profile";
  xkbswitch -s 0;
}

function asdf(){
  #sh "$MAC_SEIL_MODIFIED";
  /Applications/Karabiner.app/Contents/Library/bin/karabiner select_by_name "Modified Key Profile";
  xkbswitch -s 4;
}


#open this file for adding alias
function aa(){
  vim +/#new_alias_adding_marker "$MAC_BASH_HOME/aliases"
}

function oneline() {
  pbpaste | tr '\n' ' ' | pbcopy
}


cd() {
  builtin cd "$1"
  if [[ -f .nvmrc ]]; then
    if [[ -d "$HOME/.nvm" ]]; then
      nvm use `cat .nvmrc`
    fi
  fi
}

mkdircd () {
  mkdir -p -- "$1" &&
  cd -P -- "$1"
}

function cdls() {
  cd "$@" &&
  ls;
}


function gitinit() {
  project_name=$1
  git_repo=$2
  git init &&
  echo "*DS_Store" > .gitignore &&
  echo "#README ${project_name}" > README.md &&
  git add . &&
  git commit -m "init commit ${project_name}" &&
  git remote add origin $2 &&
  git push -u origin master
}


gituser()
{
  if [ $# -eq 0 ]; then
    echo 'Current user is: '
    git config user.name
    git config user.email
    echo 'Usage: gituser <athena_id>'
    return 0
  fi

  case $1 in
  peterkty) email=peterkty@gmail.com ;;
  fishr)    email=fishr@mit.edu ;;
  *) echo "$1 is not in the list, please enter your athena id"; return 1 ;;
  esac

  git config --global user.name $1
  git config --global user.email $email
}

weather() {
curl -s wttr.in/chennai
}


function wirelessUsb() {
    adb tcpip 5555
    sleep 3s
    ip=$(adb shell ip route | awk '{print $9}')
    adb connect $ip
}