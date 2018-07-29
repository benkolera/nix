#!/usr/bin/env bash

this_dir=$(dirname $(pwd)/$0)
machine_file="$this_dir/machine.$1.nix"

usage () {
    echo "$0 <machine name>"
    echo $1
    exit 1;
}

if [[ -z "$1" ]]; then
    usage "No argument supplied";
fi;

if [[ ! -f $machine_file ]]; then
    usage "$machine_file not found"
fi;

pushd /etc/nixos/;
sudo ln -f ../../$machine_file machine.nix
sudo ln -f ../../$this_dir/configuration.nix
sudo ln -fns ../../$this_dir/lib
popd
