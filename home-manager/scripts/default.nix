{ writeScriptBin, upower, procps, xorg, emacs, pulseaudio, ... }:
rec {
  batman = writeScriptBin "batman" ''
    ${upower}/bin/upower -i /org/freedesktop/UPower/devices/battery_BAT0
  '';
  dunst-pause = writeScriptBin "dunst-pause" ''
    kill -USR1 $(${procps}/bin/pidof dunst)
  '';
  dunst-resume = writeScriptBin "dunst-resume" ''
    kill -USR2 $(${procps}/bin/pidof dunst)
  '';
  screen-home = writeScriptBin "screen-home" ''
    ${xorg.xrandr}/bin/xrandr \
      --output DP-1 --mode 1920x1080 --pos 0x394 --rotate normal \
      --output DP-3.1 --primary --mode 1920x1080 --pos 1920x394 --rotate normal \
      --output DP-3.2 --mode 1920x1080 --pos 3840x0 --rotate right \
      --output DP-0 --off \
      --output DP-2 --off \
      --output DP-3 --off \
      --output DP-4 --off \
      --output DP-5 --off \
      --output DP-6 --off
  '';

  screen-laptop = writeScriptBin "screen-laptop" ''
    ${xorg.xrandr}/bin/xrandr \
      --output DP-4 --mode 3840x2160 --scale 0.5x0.5 --primary \
      --output DP-0 --off \
      --output DP-1 --off \
      --output DP-2 --off \
      --output DP-3 --off \
      --output DP-3.1 --off \
      --output DP-3.2 --off \
      --output DP-5 --off \
      --output DP-6 --off
  '';
  emcf = writeScriptBin "emcf" ''${emacs}/bin/emacsclient -c $@'';
  emct = writeScriptBin "emct" ''${emacs}/bin/emacsclient -t $@'';
  pa-speakers-toggle-mute = writeScriptBin "pa-mute" ''${pulseaudio}/bin/pactl set-sink-mute 0 toggle'';
  all = [ batman dunst-pause dunst-resume screen-laptop screen-home emcf emct pa-speakers-toggle-mute ];
}
