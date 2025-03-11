HOST=$(shell hostname)

all:
	@echo slammin it now!!! $(HOST)
	# delete old entries
	sudo nix-env --delete-generations +10 --profile /nix/var/nix/profiles/system
	sudo nixos-rebuild --flake .#$(HOST) switch --show-trace --max-jobs auto
	# i3-msg reload
	- i3-msg restart
	- systemctl --user restart picom.service
gc:
	nix-env --delete-generations +10
	nix-store --gc
	nix-store --optimise
update:
	nix flake update
repair:
	sudo nix-store --repair --verify --check-contents
# what is thsis here for? i forgor.
refresh-udev:
	sudo udevadm control --reload-rules
	sudo udevadm trigger
# i enabled this to maybe fix the incorrect gleam grammar but it didn't work.
# also this creates a 1.1GB folder in ~/.config/helix/runtime so i don't want to do it
# grammar:
# 	- hx --grammar fetch
# 	hx --grammar build

# todo - make a script to delete cruft caches i don't want or need
# here's a running list of all the cruft directories I have located:
#
# ~/.zoom/data/cefcache (ai binaries?????? this was 19GB!!)
# /var/lib/systemd/coredumb (not cruft but i dont care about core dumps)
