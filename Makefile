HOST=$(shell hostname)

all: update
	@echo slammin it now!!! $(HOST)
	# delete old entries
	sudo nix-env --delete-generations +10 --profile /nix/var/nix/profiles/system
	sudo nixos-rebuild --flake .#$(HOST) switch --show-trace
	i3-msg reload
	i3-msg restart
	systemctl --user restart picom.service
gc:
	nix-env --delete-generations +10
	nix-store --gc
update:
	# nix flake update
