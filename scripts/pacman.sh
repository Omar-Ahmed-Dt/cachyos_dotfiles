#!/bin/bash
# pacman=$(checkupdates | wc -l)
# echo "$pacman updates"

repo=$(checkupdates 2>/dev/null | wc -l)
aur=$(yay -Qua 2>/dev/null | wc -l)
# echo " $repo pkgs"
# echo " $repo - $aur pkgs"
echo " $repo - $aur pkgs"
