#!/bin/sh

# Functions

	programs=(reflector)

	#applications=(zsh plasma konsole dolphin kate yay virt-manager bashtop bless burpsuite deluge deluge-gtk discord enum4linux filelight github-cli gnome-keyring gnu-netcat guvcview htop hydra john kdenlive linux-headers lutris metasploit mpv neofetch nmap ntfs-3g obs-studio obsidian openvpn s-tui signal-desktop speedtest-cli sqlmap steam tree unrar wget youtube-dl)

{

# Enable Multilib and Parallel Dowloads

	#From Evan Graham on Stack Overflow
	if (sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf)
	then (sed -i '/ParallelDownloads/s/^#//g' /etc/pacman.conf)
	fi

}

# Check connection and update mirrorlist

{

	ping -c3 archlinux.org >/dev/null && echo "Network Connected"
	sleep 3
		pacman -Sy

	for program in "${programs[@]}"; do
		if ! command -v "$program" > /dev/null 2>&1; then
			pacman -Sy "$program" --noconfirm
		fi
	done

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

	if 	(pacman -Sy zsh plasma konsole dolphin kate yay virt-manager bashtop bless burpsuite deluge deluge-gtk discord enum4linux filelight github-cli gnome-keyring gnu-netcat guvcview htop hydra john kdenlive linux-headers lutris metasploit mpv neofetch nmap ntfs-3g obs-studio obsidian openvpn s-tui signal-desktop speedtest-cli sqlmap steam tree unrar wget youtube-dl)
	then (echo "Applications Installed")
	else (echo "Application Install Failed")
	fi

}

# Enable Services

{

	systemctl enable NetworkManager
	systemctl enable sddm

	reboot
