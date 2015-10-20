#!/bin/bash

set -eu
IFS=$(echo -en "\n\b")  # for filenames with spaces
bold="\e[1;37m"; green="\e[00;32m"; normal="\e[00m"

cd $(dirname "$0"); REPO_PATH=$(pwd)
echo -e "\nInstalling dotfiles from $REPO_PATH.\n"

# find all dotfiles in this repo (ignore .git dir, README and this script)
# and link them to $HOME, making backups of user's existing dotfiles
for f in `find ./ -name .git -prune -or -type f -path './.*' -printf '%P\n'`; do
    mkdir --parents "$HOME/$(dirname $f)"
    if [ "$REPO_PATH/$f" -ef "$HOME/$f" ]; then
        echo "Already linked: $f"
    elif [ -L "$HOME/$f" ]; then
        echo "Updating link: $f"
        ln -s --force "$REPO_PATH/$f" "$HOME/$f"
    else
        if [ -e "$HOME/$f" ]; then
            echo -e "Renaming your existing ${bold}${f}${normal} to $f.old"
            mv "$HOME/$f" "$HOME/$f.old" --backup=numbered
        fi
        echo "Linking $f"
        ln -s "$REPO_PATH/$f" "$HOME/$f"
    fi
done

echo -e "\n${green}Done. Open a new terminal to see the effects.${normal}"