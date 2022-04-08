#!/bin/sh

# Check connection and update mirrorlist

{
	ping -c3 archlinux.org >/dev/null && echo "Network Connected"
	
	sleep 3

	if (which reflector >/dev/null && echo "Updating Mirrorlist")
	else (pacman -Sy reflector --noconfirm --needed)
	then (reflector --sort rate --country "Australia, New Zealand" --save /home/daniel/git/repos/Arch/mirrorlist.conf)
		echo "Mirrorlist Updated"
	fi
}

# Add BlackArch repo

{

	if (cat /etc/pacman.conf | grep blackarch >/dev/null)
	then (echo "BlackArch Repo Exists" sleep 2)
	else (echo "Adding BlackArch Repo" sleep 2)
	       	curl -O https://blackarch.org/strap.sh
		echo 8bfe5a569ba7d3b055077a4e5ceada94119cccef strap.sh | sha1sum -c
		chmod +x strap.sh && ./strap.sh
		pacman -Syu --noconfirm --needed
	fi

	if (cat /etc/pacman.conf | grep blackarch >/dev/null)
	then (echo "BlackArch Repo Configured")
	fi

}


