-- Imports
import XMonad
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

-- Actions
import XMonad.Actions.WithAll(killAll, sinkAll)
import XMonad.Actions.CopyWindow(kill1)
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves(rotSlavesDown, rotAllDown)

-- Layouts
import XMonad.Layout.Spacing

-- Data
import Data.Monoid
import qualified Data.Map as M

-- Utilities
import XMonad.Util.EZConfig(additionalKeysP)
import XMonad.Util.SpawnOnce

-- Variable
myTerm :: String
myTerm = "kitty"

myLauncher :: String
myLauncher = "rofi -modi drun,run -show drun -show-icons -sidebar-mode"

myModMask :: KeyMask
myModMask = mod4Mask

myFocusWhenClick :: Bool
myFocusWhenClick = False

myBorderWidth :: Dimension
myBorderWidth = 4

myNormalColor :: String
myNormalColor   = "#817c9c"

myFocusColor :: String
myFocusColor  = "#9ccfd8"

-- Rules
myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
  [
  (className =? "firefox" <&&> resource =? "Toolkit") --> doFloat,
  (className =? "Gimp") --> doFloat
  ]

-- Layout Hook
myLayout = tiled ||| Mirror tiled ||| Full
  where
     tiled   = Tall nmaster delta ratio
     nmaster = 1
     ratio   = 1/2
     delta   = 3/100

-- Keys Binding
myKeys :: [(String, X ())]
myKeys = 
  [
  -- General
  ("M-<Return>", spawn myTerm),
  ("M-d", spawn myLauncher),
  ("M-q", kill1),
  ("M-S-q", killAll),

  -- Window Control
  ("M-m", windows W.focusMaster),
  ("M-j", windows W.focusDown),
  ("M-k", windows W.focusUp),
  ("M-m", windows W.swapMaster),
  ("M-S-j", windows W.swapDown),
  ("M-S-k", windows W.swapUp),
  ("M-S-h", sendMessage Shrink),
  ("M-S-l", sendMessage Expand),
  ("M-t", withFocused $ windows . W.sink),
  ("M-S-t", sinkAll),
  ("M-<Tab>", rotAllDown),
  ("M-S-<Tab>", rotSlavesDown),

  -- FN
  ("<XF86AudioMute>", spawn "amixer set Master toggle"),
  ("<XF86AudioRaiseVolume>", spawn "amixer set Master 2%+"),
  ("<XF86AudioLowerVolume>", spawn "amixer set Master 2%-"),
  ("<XF86MonBrightnessUp>", spawn "brightnessctl s 2%+"),
  ("<XF86MonBrightnessDown>", spawn "brightnessctl s 2%-"),

  -- Xmonad
  ("M-C-r", spawn "xmonad --recompile && xmonad --restart"),
  ("M-C-q", io exitSuccess)
  ]

-- Default Keys (Do not touch)
myDefaultKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [
    ((modm,               xK_space ), sendMessage NextLayout),
    ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf),
    ((modm,               xK_n     ), refresh),
    ((modm              , xK_comma ), sendMessage (IncMasterN 1)),
    ((modm              , xK_period), sendMessage (IncMasterN (-1)))
    ]
    ++
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

-- Main
main = xmonad $ def 
  {
  modMask = myModMask,
  terminal = myTerm,
  focusFollowsMouse = myFocusWhenClick /= True,
  clickJustFocuses = myFocusWhenClick,
  borderWidth = myBorderWidth,
  keys = myDefaultKeys,
  normalBorderColor = myNormalColor,
  focusedBorderColor = myFocusColor,
  layoutHook = spacingRaw True (Border 1 1 1 1) True (Border 1 1 1 1) True 
             $ myLayout
  } `additionalKeysP` myKeys
