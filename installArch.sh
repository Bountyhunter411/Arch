#!/bin/sh

# Functions

	programs=(reflector)

	#applications="zsh plasma konsole dolphin kate yay virt-manager bashtop bless burpsuite deluge deluge-gtk discord enum4linux filelight github-cli gnome-keyring gnu-netcat guvcview htop hydra john kdenlive linux-headers lutris metasploit mpv neofetch nmap ntfs-3g obs-studio obsidian openvpn s-tui signal-desktop speedtest-cli sqlmap steam tree unrar wget youtube-dl"

	#aur="brave-bin gwe mangohud-git mangohud-common-git minecraft-launcher nerd-fonts-complete openrdb-git spotify steam-fonts via-bin xenia-bin"

# Install dependencies

{

	pacman -Sy

	for program in "${programs[@]}"; do
		if ! command -v "$program" > /dev/null 2>&1; then
			pacman -Sy "$program" --noconfirm
		fi
	done
}

# Check connection and update mirrorlist

{
	ping -c3 archlinux.org >/dev/null && echo "Network Connected"
	sleep 3
	echo "Updating Mirrorlist"
	reflector --sort rate --country "Australia, New Zealand" --save /home/daniel/git/repos/Arch/mirrorlist.conf
		echo "Mirrorlist Updated"

}

# Add BlackArch repo

{

	if (cat /etc/pacman.conf | grep blackarch >/dev/null)
	then (echo "BlackArch Repo Exists" sleep 3)
	else (echo "Adding BlackArch Repo" sleep 3)
	       	curl -O https://blackarch.org/strap.sh
		echo 8bfe5a569ba7d3b055077a4e5ceada94119cccef strap.sh | sha1sum -c
		chmod +x strap.sh && ./strap.sh
		pacman -Syu --noconfirm --needed
	fi

	if (cat /etc/pacman.conf | grep blackarch >/dev/null)
	then (echo "BlackArch Repo Configured")
	fi

}

# Install applications

{

	echo "Installing Applications" sleep 3
	if (pacman -Sy sh plasma konsole dolphin kate yay virt-manager bashtop bless burpsuite deluge deluge-gtk discord enum4linux filelight github-cli gnome-keyring gnu-netcat guvcview htop hydra john kdenlive linux-headers lutris metasploit mpv neofetch nmap ntfs-3g obs-studio obsidian openvpn s-tui signal-desktop speedtest-cli sqlmap steam tree unrar wget youtube-dl --noconfirm --needed)
	then (echo "Applications Installed")
	else (echo "Application Install Failed" sleep 3)
	fi

}

# Install Programs From AUR

{

	echo "Installing AUR Applications" sleep 3
	if (yay -si -a brave-bin gwe mangohud-git mangohud-common-git minecraft-launcher nerd-fonts-complete openrdb-git spotify steam-fonts via-bin xenia-bin --noconfirm)
	then (echo "AUR Applications Installed" sleep 3)
	else ( echo "AUR Applications Install Failed" sleep 3)
	fi
}
