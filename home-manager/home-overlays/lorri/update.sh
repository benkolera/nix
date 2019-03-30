#! /usr/bin/env nix-shell
#! nix-shell -p nix-prefetch-git -i bash
nix-prefetch-git --rev refs/heads/rolling-release --no-deepClone https://github.com/target/lorri.git > $(dirname $0)/git.json
