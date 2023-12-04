HOST=$(shell hostname)

rebuild:
	nixos-rebuild switch --flake ".#$(HOST)"
