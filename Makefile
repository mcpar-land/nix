HOST=$(shell hostname)
.PHONY: build build-local clear-generations gc update repair refresh-udev

build: clear-generations
	@echo slammin it now!!! $(HOST)
	sudo nixos-rebuild --flake .#$(HOST) switch --show-trace --max-jobs auto
	nix flake archive --to ssh://nix-ssh@jamrock .
build-local: clear-generations
	@echo slammin it now \(no remote builders\)!!! $(HOST)
	sudo nixos-rebuild --flake .#$(HOST) switch --show-trace --max-jobs auto \
		--builders ""
clear-generations:
	# delete old entries
	sudo nix-env --delete-generations +10 --profile /nix/var/nix/profiles/system
gc: clear-generations
	sudo nix-store --gc
	sudo nix-store --optimise
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
