#!/usr/bin/env bash

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
  .background-image
  .xmonad/xmonad.hs
  .xmonad/xmobar.hs
  .config/taffybar/taffybar.hs
  .config/dunst/dunstrc
  .workrave/workrave.ini
  $(find ./bin/)
)

dirs=(
  .zsh.d
)

for d in ${mkdirs[@]}; do
  mkdir -p $HOME/$d
done

for f in ${files[@]}; do
  echo $f
  ln -sf $(pwd)/$f $HOME/$f
done;

for d in ${dirs[@]}; do
  ln -sfn $(pwd)/$d $(dirname $HOME/$d)
done;
