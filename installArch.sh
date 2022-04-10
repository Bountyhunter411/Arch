#!/bin/sh

# Functions

	dependentprograms=(reflector dialog)

	aurprograms=(brave-bin gwe mangohud-git mangohud-common-git minecraft-launcher nerd-fonts-complete openrgb-git spotify steam-fonts via-bin xenia-bin)

	#zshthemes=(zsh-theme-powerlevel10k-git)

	#applications=(zsh plasma konsole dolphin kate yay virt-manager bashtop bless burpsuite deluge deluge-gtk discord enum4linux filelight github-cli gnome-keyring gnu-netcat guvcview htop hydra john kdenlive linux-headers lutris metasploit mpv neofetch nmap ntfs-3g obs-studio obsidian openvpn s-tui signal-desktop speedtest-cli sqlmap steam tree unrar wget youtube-dl)

# Get user input for username

	getusername() {
		name=$(\
				dialog --title "Please Enter Username" \
				--inputbox "Enter Username" 8 40 \
				3>&1 1>&2 2>&3- \
				)
				}

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

	for dependentprogram in "${dependentprograms[@]}"; do
		if ! command -v "$dependentprogram" > /dev/null 2>&1; then
			pacman -Sy "$dependentprogram" --noconfirm
		fi
	done

	echo "Installed Dialog and Reflector"
	echo "Updating Mirrorlist"
	reflector --sort rate --country "Australia, New Zealand" --save /etc/pacman.d/mirrorlist
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

	if 	(pacman -Sy zsh plasma konsole dolphin kate yay virt-manager qemu libvirt edk2-ovmf ebtables dnsmasq bashtop bless burpsuite deluge deluge-gtk discord enum4linux filelight github-cli gnome-keyring gnu-netcat guvcview htop hydra john kdenlive linux-headers lutris metasploit mpv neofetch nmap ntfs-3g obs-studio obsidian openvpn s-tui signal-desktop speedtest-cli sqlmap steam tree unrar wget youtube-dl)
	then (echo "Applications Installed")
	else (echo "Application Install Failed" && exit 1)
	fi

}

# Install Programs from AUR

{

	getusername

	for aurprogram in "${aurprograms[@]}"; do
		if ! command -v "$aurprogram" > /dev/null 2>&1; then
			echo "Installing $aurprogram"
				sudo -u "$name" yay -S "$aurprogram" --noconfirm
		fi
	done

}

# Switch shell to zsh

# {
#
# 	echo "Switching Shell to zsh"
#
# 	if (sudo -u "$name" chsh -s /bin/zsh && echo $SHELL == /bin/zsh)
# 	then (echo "Shell is now zsh")
# 	else (echo "Shell switch failed!")
# 	fi
# }

# Download and copy dotfiles (comment out; need to fix; doesn't work)

# Download and install zsh theme

# {
#
# 	if (sudo -u "$name" yay -S zsh-theme-powerlevel10k-git --noconfirm)
# 	then (echo "zsh theme installed")
# 	fi
# }
#
# # Add zsh plugins
#
# {
#
# 	if (git clone https://github.com/zsh-users/zsh-syntax-highlighting)
# 	then (mkdir -p /usr/share/zsh/plugins/zsh-syntax-highlighting && cp -r zsh-syntax-highlighting/* /usr/share/zsh/plugins/zsh-syntax-highlighting/ && echo "Syntax Highlighting Installed")
# 	fi
#
# 	sleep 3
#
# 	if (git clone https://github.com/zsh-users/zsh-autosuggestions)
# 	then (mkdir -p /usr/share/zsh/plugins/zsh-autosuggestions && cp -r zsh-autosuggestions/* /usr/share/zsh/plugins/zsh-autosuggestions && echo "Autosuggentions Installed")
# 	fi
# }
#
# # Copy dotfiles
#
# {
#
# 	if (git clone https://github.com/Bountyhunter411/dotfiles)
# 	then (cp dotfiles/zsh/.zshrc /home/$name/.zshrc && rm -rf /usr/share/zsh-theme/powerlevel10k/* && cp -r dotfiles/zsh/themes/zsh-theme-powerlevel10k/* /usr/share/zsh-theme/powerlevel10k/)
# 	else ( echo "Dotfile install failed")
# 	fi
#
# }
#
# Enable Services and reboot

{

	echo "Enabling Services"
	sleep 3
	systemctl enable NetworkManager
	systemctl enable libvirtd
	systemctl enable virtlogd.socket
	systemctl enable sddm

	echo "REBOOTING IN 5 SECOUNDS!"

	sleep 7

	reboot

}
