#! /usr/bin/env nix-shell
#! nix-shell -p nix-prefetch-git -i bash
nix-prefetch-git https://github.com/mawww/kakoune.git > $(dirname $0)/git.json
