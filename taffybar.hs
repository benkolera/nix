import Data.Unique (newUnique)
import Graphics.UI.GIGtkStrut (defaultStrutConfig, StrutSize(ExactSize), strutHeight)
import System.Taffybar (dyreTaffybar)
import System.Taffybar.Context (defaultTaffybarConfig, BarConfig(..), getBarConfigsParam)
import System.Taffybar.Information.Memory (parseMeminfo, memoryUsedRatio)
import System.Taffybar.Information.CPU (cpuLoad)
import System.Taffybar.Widget.Battery (textBatteryNew)
import System.Taffybar.Widget.SNITray (sniTrayNew)
import System.Taffybar.Widget.Workspaces (defaultWorkspacesConfig, workspacesNew)
import System.Taffybar.Widget.SimpleClock (textClockNew)
import System.Taffybar.Widget.FreedesktopNotifications (notifyAreaNew, defaultNotificationConfig, notificationMaxTimeout)
import System.Taffybar.Widget.Generic.PollingGraph (defaultGraphConfig, pollingGraphNew, graphDataColors, graphLabel)

memCallback = do
  mi <- parseMeminfo
  return [memoryUsedRatio mi]

cpuCallback = do
  (userLoad, systemLoad, totalLoad) <- cpuLoad
  return [totalLoad, systemLoad]

main = do
  u <- newUnique
  dyreTaffybar $ defaultTaffybarConfig
    { getBarConfigsParam = pure . pure $ BarConfig
      { strutConfig = defaultStrutConfig { strutHeight = ExactSize 35 }
      , widgetSpacing = 5
      , startWidgets = [ pager ]
      , centerWidgets = [ ]
      , endWidgets = [ tray, clock, mem, cpu, bat ]
      , barId = u
      }
    }
  where
    memCfg = defaultGraphConfig
             { graphDataColors = [(1, 0, 0, 1)]
             , graphLabel = Just "mem"
             }
    cpuCfg = defaultGraphConfig
             { graphDataColors = [ (0, 1, 0, 1) , (1, 0, 1, 0.5)]
             , graphLabel = Just "cpu"
             }
    clock = textClockNew Nothing "<span fgcolor='orange'>%a %b %_d %H:%M</span>" 1
    pager = workspacesNew $ defaultWorkspacesConfig
    mem = pollingGraphNew memCfg 1 memCallback
    cpu = pollingGraphNew cpuCfg 0.5 cpuCallback
    --note = notifyAreaNew $ defaultNotificationConfig { notificationMaxTimeout = Nothing }
    tray = sniTrayNew
    bat = textBatteryNew "batt: $percentage$%"
