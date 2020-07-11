cfg_dir=/mnt/etc/nixos/
if [ -z "$1" ]; then
  echo "$0 <machine_name>"
  exit
fi

cd $(dirname $0)

../update.sh $cfg_dir/thunk.json
cat <<CONFIG > $cfg_dir/configuration.nix
let thunk = builtins.fromJSON (builtins.readFile /etc/nixos/thunk.json);
in (import (builtins.fetchGit {
  inherit (thunk) url rev;
})) "$1"
CONFIG

#stub out obsidian and private
mkdir -p $cfg_dir/obsidian 
echo "{...}: {}" > $cfg_dir/obsidian
echo "{...}: {}" > $cfg_dir/private
