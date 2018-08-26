#!/usr/bin/env bash

this_dir=$(dirname $(pwd)/$0)

mkdirs=(
  .config/dunst
  .config/taffybar
  bin
  .workrave
)

files=(
  .zshrc
  .xprofile
  .zprofile
  .zshenv
  .stalonetray
  .spacemacs
  .background-image
  .xmonad/xmonad.hs
  .xmonad/xmobar.hs
  .config/taffybar/taffybar.hs
  .config/dunst/dunstrc
  .workrave/workrave.ini
  $(ls $this_dir/bin/ | sed "s|^|bin/|g")
)

dirs=(
  .zsh.d
)

for d in ${mkdirs[@]}; do
  mkdir -p $HOME/$d
done

for f in ${files[@]}; do
  echo $f
  ln -sf $this_dir/$f $HOME/$f
done;

for d in ${dirs[@]}; do
  ln -sfn $this_dir/$d $(dirname $HOME/$d)
done;
