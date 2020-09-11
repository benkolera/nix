#! /usr/bin/env nix-shell
#! nix-shell -p nix-prefetch-git -i bash
set -e
path=${1:-/etc/nixos/thunk.json}
nix-prefetch-git https://github.com/benkolera/nix $1 > $path
#nixos-rebuild switch
sudo nixos-rebuild switch -I nixpkgs=https://api.github.com/repos/NixOS/nixpkgs/tarball/pull/97438/head
