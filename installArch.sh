#!/bin/sh


# Install dependencies

{

	pacman -Sy
	programs=(reflector)

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
