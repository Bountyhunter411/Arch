#!/bin/sh

# Functions

	dependentprograms=(reflector dialog)

	aurprograms=(brave-bin gwe mangohud-git mangohud-common-git minecraft-launcher nerd-fonts-complete openrdb-git spotify steam-fonts via-bin xenia-bin)

	p10k=(zsh-theme-powerlevel10k-git)

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

{

	echo "Switching Shell to zsh"

	if (sudo -u "$name" chsh -s /bin/zsh && echo $SHELL == /bin/zsh)
	then (echo "Shell is now zsh")
	else (echo "Shell switch failed!")
	fi
}

# Download and copy dotfiles

{

	if (git clone https://github.com/Bountyhunter411/dotfiles)
	then (cp dotfiles/zsh/.zshrc /home/$name/.zshrc)
			echo "Installing zsh theme"
				sudo -u "$name" yay -Si "$p10k" --noconfirm
					echo "zsh theme installed"
						echo "Installing zsh plugins"
							git clone https://github.com/zsh-users/zsh-syntax-highlighting  /usr/share/zsh/plugins/zsh-autosuggestions/
								git clone https://github.com/zsh-users/zsh-autosuggestions /usr/share/zsh/plugins/zsh-autosuggestions/
									echo "Plugins installed"
	else (echo "Unable to clone dotfiles repo")
	fi

}

# Enable Services and reboot

{

	systemctl enable NetworkManager
	systemctl enable sddm

	reboot

}
