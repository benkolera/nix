#! /usr/bin/env nix-shell
#! nix-shell -p nix-prefetch-git -i bash
nix-prefetch-git --no-deepClone https://github.com/obsidiansystems/obelisk.git > $(dirname $0)/git.json
