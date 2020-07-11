#! /usr/bin/env nix-shell
#! nix-shell -p nix-prefetch-git -i bash
path=${1:-/etc/nixos/thunk.json}
nix-prefetch-git https://github.com/benkolera/nix $1 > $path
