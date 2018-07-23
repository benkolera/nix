module Main where

import DBus.Client
import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.SetWMName
import System.Taffybar.Hooks.PagerHints (pagerHints)

main = do
  xmonad . ewmh .pagerHints $ desktopConfig {
    modMask            = mod1Mask
  , terminal           = "terminology"
  , normalBorderColor  = "#2a2b2f"
  , focusedBorderColor = "DarkOrange"
  , borderWidth        = 1
  , startupHook        = setWMName "LG3D"
  }
