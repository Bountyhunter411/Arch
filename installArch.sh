#!/bin/sh

# Check connection and update mirrorlist

{
	ping -c3 archlinux.org >/dev/null && echo "Network Connected"
	
	sleep 3

	if (which reflector >/dev/null && echo "Updating Mirrorlist")
	then (reflector --sort rate --country "Australia, New Zealand" --save /home/daniel/git/repos/Arch/mirrorlist.conf)
		echo "Mirrorlist Updated"
	fi
}



# Install the BlackArch mirror

#{
#	curl -O https://blackarch.org/strap.sh
#
#	echo 8bfe5a569ba7d3b055077a4e5ceada94119cccef strap.sh | sha1sim -c
#
#	chmod +x strap.sh
#
#	./strap.sh
#
#	pacman -Sy
#
#}

{

	if (cat /etc/pacman.conf | grep blackarch >/dev/null && echo "BlackArch Repo Exists")
	elif ( curl -O https://blackarch.org/strap.sh
		echo 8bfe5a569ba7d3b055077a4e5ceada94119cccef strap.sh | sha1sum -c
		chmod +x strap.sh && ./strap.sh
		pacman -Syu )
	if (cat /etc/pacman.conf | grep blackarch >/dev/null && echo "BlackArch Repo Configured")


}
