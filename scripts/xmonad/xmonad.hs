import XMonad
import XMonad.Util.EZConfig (additionalKeysP)

main :: IO ()
main =
  xmonad $
    def {modMask = mod4Mask}
      `additionalKeysP` [ ("M-<Return>", spawn "alacritty")
                        ]
