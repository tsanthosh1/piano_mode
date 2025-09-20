#!/usr/bin/env bash

MY_PIANO_MODE_HOME="$HOME/piano_mode"
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


function gtag() {
  if [ -z "$1" ]; then
    echo "Usage: gtag <tag_name> [<message>]"
    return 1
  fi

  tag_name="$1"
  if [ -z "$2" ]; then
    git tag "$tag_name" &&
    git push origin "$tag_name"
  else
    message="$2"
    git tag -a "$tag_name" -m "$message" &&
    git push origin "$tag_name"
  fi
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

function gpl()
{
  branch=$(git branch | grep "* " | sed 's/* //')
  git pull origin $branch --no-rebase
}

function gplr()
{
  branch=$(git branch | grep "* " | sed 's/* //')
  git pull origin $branch --rebase
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

# Set git user/email to personal
function gituser_personal() {
  git config --global user.name "Santhosh Thamaraiselvan"
  git config --global user.email "tsanthosh.bk1@gmail.com"
  echo "Git user set to personal (tsanthosh.bk1@gmail.com)"
}

# Set git user/email to work
function gituser_work() {
  git config --global user.name "Santhosh Thamaraiselvan"
  git config --global user.email "santhosh.thamaraiselvan@chargebee.com"
  echo "Git user set to work (santhosh.thamaraiselvan@chargebee.com)"
}

# weather() {
#   curl -s wttr.in/chennai
# }

# Make directories, cd into the first one
function md {
    mkdir -p "$@" && cd "$1"
}

function wirelessUsb() {
    adb tcpip 5555
    sleep 3s
    ip=$(adb shell ip route | awk '{print $9}')
    adb connect $ip
}

function tabname() {
  echo -ne "\033]0;$1\007"
}


function hg {
  history | grep ${1}
}

function yt {
  sh /Users/tsanthosh/piano_mode/mac/bash/scripts/ytrim.sh ${1}
}

download_image() {
  local url="$1"
  echo "url $url"
  local dir="$HOME/searchmemes/public/feed-images"

  # Extract the token from the URL using parameter expansion
  local token=$(echo "$url" | grep -oP '(?<=token=)[^&]+')

  # Check if token is found
  if [ -z "$token" ]; then
    echo "Error: Token not found in URL."
    return 1
  fi

  # Create the directory if it doesn't exist
  mkdir -p "$dir"

  # Download the image and save it as <token>.webp
  curl -L "$url" -o "$dir/${token}.webp"

  # Prepare the relative URL
  local relative_url="/feed-images/${token}.webp"

  # Copy the relative URL to the clipboard
  echo "$relative_url" | pbcopy

  echo "Image downloaded and saved as ${token}.webp in $dir"
  echo "Relative URL copied to clipboard: $relative_url"
}

function generate_otp() {
  oathtool --base32 --totp $1  | cc
}

function generate_otp_with_secret_from_clipboard() {
  oathtool --base32 --totp $(pbpaste) | cc
}


convert_timestamp() {
  input="$1"

  # If no input, read from clipboard
  if [ -z "$input" ]; then
    if command -v pbpaste >/dev/null 2>&1; then
      input=$(pbpaste)   # macOS
    elif command -v xclip >/dev/null 2>&1; then
      input=$(xclip -o -selection clipboard) # Linux with xclip
    elif command -v xsel >/dev/null 2>&1; then
      input=$(xsel --clipboard --output)     # Linux with xsel
    else
      echo "❌ No clipboard utility found"
      return 1
    fi
  fi

  # Remove non-numeric leading/trailing characters
  ts=$(echo "$input" | sed 's/^[^0-9]*//; s/[^0-9]*$//')

  # Detect if timestamp is in milliseconds
  if [ ${#ts} -gt 10 ]; then
    sec=$((ts / 1000))
    ms=$((ts % 1000))
  else
    sec=$ts
    ms=0
  fi

  # Choose the correct date command
  if date --version >/dev/null 2>&1; then
    # GNU date (Linux)
    gmt_date=$(date -u -d "@$sec" +"%A, %d %B %Y %H:%M:%S")
    local_date=$(date -d "@$sec" +"%A, %d %B %Y %H:%M:%S")
    now=$(date +%s)
  else
    # BSD date (macOS)
    gmt_date=$(date -u -r $sec +"%A, %d %B %Y %H:%M:%S")
    local_date=$(date -r $sec +"%A, %d %B %Y %H:%M:%S")
    now=$(date +%s)
  fi

  # Relative calculation
  diff=$((now - sec))
  if [ $diff -lt 60 ]; then
    rel="$diff seconds ago"
  elif [ $diff -lt 3600 ]; then
    rel="$((diff / 60)) minutes ago"
  elif [ $diff -lt 86400 ]; then
    rel="$((diff / 3600)) hours ago"
  else
    rel="$((diff / 86400)) days ago"
  fi

  echo "Input timestamp : $ts"
  echo "GMT             : $gmt_date.$ms"
  echo "Your time zone  : $local_date.$ms"
  echo "Relative        : $rel"
}

mkfile() { 
    mkdir -p $( dirname "$1") && touch "$1" 
   }