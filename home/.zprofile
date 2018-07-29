export NIX_REMOTE=daemon

for i in $(find .zsh.d/ -type f); do
  source $i;
done;
