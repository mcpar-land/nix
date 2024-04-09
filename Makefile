HOST=$(shell hostname)

all:
	@echo slammin it now!!! $(HOST)
	# delete old entries
	sudo nix-env --delete-generations +10 --profile /nix/var/nix/profiles/system
	sudo nixos-rebuild --flake .#$(HOST) switch --show-trace
	# i3-msg reload
	- i3-msg restart
	- systemctl --user restart picom.service
	- systemctl --user restart udiskie.service
	- ~/.config/ewwscripts/launch
gc:
	nix-env --delete-generations +10
	nix-store --gc
wallpaper:
	# this weird package manages its images itself instead of just being able
	# to take a path like it should.
	betterlockscreen -u ./wallpapers/martinaise.png
update:
	nix flake update
# i enabled this to maybe fix the incorrect gleam grammar but it didn't work.
# also this creates a 1.1GB folder in ~/.config/helix/runtime so i don't want to do it
# grammar:
# 	- hx --grammar fetch
# 	hx --grammar build
