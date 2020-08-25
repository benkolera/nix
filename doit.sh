if [[ $1 == "amend" ]]; then
git add -A && git commit --amend && git push -f && sudo ./update.sh
else
git add -A && git commit && git push && sudo ./update.sh
fi
