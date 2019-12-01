./deps/home-manager/update.sh
for i in $(find home-manager/home-overlays -name update.sh); do $i; done;
