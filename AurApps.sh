#!/bin/sh

# script to install AUR packages

programs=(brave-bin gwe mangohud-git mangohud-common-git minecraft-launcher nerd-fonts-complete openrdb-git spotify steam-fonts via-bin xenia-bin)

{

for program in "${programs[@]}"; do
	if ! command -v "$program" > /dev/null 2>&1; then
		echo "Installing $program"
			sudo -u "$name" yay -Si "$program" --noconfirm
	fi
done

}
