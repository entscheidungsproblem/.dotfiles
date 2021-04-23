#!/usr/bin/env bash

function check_package(){
    if (($# > 0)) ; then
		    if ! command -v $1 &> /dev/null
        then
            return 1
        else
            return 0
        fi
	  fi

}

function check_os(){
    case "$OSTYPE" in
        linux*)   if check_package "yum"; then
                      echo "yum"
                  elif check_package "apt"; then
                      echo "apt"
                  else
                      echo "linux"
                  fi;;
        darwin*)  echo "osx" ;;
    esac
}

os=$(check_os)

if [[ "$os" -eq "osx" ]] && [[ $(xcode-select -p 1>/dev/null;echo $?) -eq 2 ]]; then
    echo "Xcode CLI tools not found. Installing now"
    xcode-select -install
fi

# Check if brew is installed
if  ! check_package brew && [[ "$os" -eq "osx" ]]; then
    echo "Brew not found. Installing now"
    # Install
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Update path for brew packages
    PATH=/usr/local/bin:$PATH
    # Unshallow clone of homebre-core to allow updates
    git -C /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core fetch --unshallow
    brew update
fi

# Check if zsh is installed
if ! check_package "zsh"; then
    echo "Zsh not found. Installing now"
    case $os in
        apt)   sudo apt update
               sudo apt upgrade
               sudo apt install zsh
               chsh -s $(which zsh);;
        yum)   sudo yum upgrade
               sudo yum install zsh
               chsh -s $(which zsh);;
        osx)   brew install zsh
               sudo sh -c "echo $(which zsh) >> /etc/shells" && chsh -s $(which zsh);;
    esac
fi

github_print="$(ssh-keyscan github.com)"
if [ ! -f ~/.ssh/known_hosts ] || grep -q $github_print ~/.ssh/known_hosts ; then
    echo "$github_print" >> ~/.ssh/known_hosts
fi

# Zplug
if ! check_package zplug; then
    echo "Zplug not found. Installing now"
    case $os in
        osx)    brew install zplug;;
        *)      curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
    esac
    # Use zsh
    #zsh
    #export ZPLUG_HOME=/usr/local/opt/zplug
    #source $ZPLUG_HOME/init.zsh
    zplug load --verbose
fi

# Dotfiles
cd ~
mkdir projects
cd projects
git clone git@github.com:entscheidungsproblem/.dotfiles.git
cd .dotfiles

# Link zshrc
ln -s ~/projects/.dotfiles/.zshrc ~/.zshrc

# Install Zplugs
if ! zplug check --verbose; then
    zplug install
fi


#brew_list: kitty, yamllint, wget, telnet, ripgrep, neovim, nvm, markdown, jq, go, golangci-lint, gnutls, gnu-sed, exa, coreutils, bat
# brew terraform list: tfsec, tflint, terraform-docs, imagemagick, graphviz, pre-commit
# pip aws list: boto3, botocore
