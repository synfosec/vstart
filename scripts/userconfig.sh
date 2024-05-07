#!/bin/bash
#
#   User script: Grabs config files from GitHub and puts them in config locations
#
#

# default branch name
BRANCH="main"
USER=$(whoami)

# SSH MESSAGE
ssh_message() {
    clear
    echo -e "[+] Running as $USER\n"
    echo -e "MAKE SURE THE SSH KEYS ARE THERE\n"
    sleep 3
    clear
}

# GITHUB CONFIG
setGit() {
    read -p "[?] Enter GitHub username: " USERNAME
    read -p "[?] Enter GitHub email: " EMAIL

    git config --global user.name $USERNAME
    git config --global user.email $EMAIL
    git config --global init.defaultBranch $BRANCH

    echo -e "\n[+] GitHub config is set\n"

    mkdir .config

    getConf $USERNAME
}

# OHMYZSH
get_ohMyZsh() {
    clear
    echo -e "\n[+] Downloading OhMyZsh\n"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

# GET CONFIG FROM GITHUB
getConf() {
    mkdir confs
    cd confs
    git init
    git remote add origin git@github.com:$1/dotfiles.git
    git fetch --all
    git checkout main

    mv nvim ~/.config; cat zshrc >> ~/.zshrc

	sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
}

get_rust() {
	clear
	echo -e "[*] Downloading Rust"
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

get_meta() {
    curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall
    echo "[+] downloaded metasploit - PENTESTING FRAMEWORK"
}

# INIT
ssh_message
clear
get_rust
get_ohMyZsh
setGit
get_meta
