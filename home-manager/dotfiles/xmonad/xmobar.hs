Config {
    position = Top,
    font = "xft:Source Code Pro:size=10:antialias=true",
    bgColor = "#111111",
    fgColor = "#ffffff",
    lowerOnStart = True,
    overrideRedirect = True,
    allDesktops = True,
    persistent = False,
    commands = [
          Run MultiCpu ["-t","Cpu: <total0> <total1> <total2> <total3>","-L","30","-H","60","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC","-w","3"] 10
        , Run Memory ["-t","Mem: <usedratio>%","-H","8192","-L","4096","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10
        , Run Swap ["-t","Swap: <usedratio>%","-H","1024","-L","512","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10
        , Run Date "%a %b %_d %H:%M" "date" 10
        , Run Com "tray-pad-icon" [] "trayerpad" 10
        , Run Battery [ "--template" , "Batt: <acstatus>"
                      , "--Low"      , "10"        -- units: %
                      , "--High"     , "80"        -- units: %
                      , "--low"      , "darkred"
                      , "--normal"   , "darkorange"
                      , "--high"     , "darkgreen"

                      , "--" -- battery specific options
                            -- discharging status
                      , "-o"	, "<left>% (<timeleft>)"
                      -- AC "on" status
                      , "-O"	, "<fc=#dAA520>Charging</fc>"
                      -- charged status
                      , "-i"	, "<fc=#006000>Charged</fc>"
                      ] 50
        , Run StdinReader
    ],
    sepChar = "%",
    alignSep = "}{",
    template = "%StdinReader% }{ %multicpu%   %memory%   %swap%   %battery%   <fc=#FFFFCC>%date%</fc> %trayerpad%"
}
