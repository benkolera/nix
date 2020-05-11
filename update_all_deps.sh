#! /usr/bin/env nix-shell
#! nix-shell -i bash -p niv
cd "$(dirname "$0")"
niv update
cd home-manager
niv update
