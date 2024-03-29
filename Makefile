HOST=$(shell hostname)

all: update
	@echo slammin it now!!! $(HOST)
	# delete old entries
	sudo nix-env --delete-generations +10 --profile /nix/var/nix/profiles/system
	sudo nixos-rebuild --flake .#$(HOST) switch --show-trace
	# i3-msg reload
	i3-msg restart
	systemctl --user restart picom.service
	systemctl --user restart polybar.service
gc:
	nix-env --delete-generations +10
	nix-store --gc
wallpaper:
	# this weird package manages its images itself instead of just being able
	# to take a path like it should.
	betterlockscreen -u ./wallpapers/martinaise.png
update:
	# nix flake update
grammar:
	- hx --grammar fetch
	hx --grammar build
