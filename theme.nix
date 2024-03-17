{pkgs}: let
  utils = import ./utils.nix {inherit pkgs;};
in rec {
  color = colorHex: rec {
    r = utils.hexToDec (builtins.substring 1 2 colorHex);
    g = utils.hexToDec (builtins.substring 3 2 colorHex);
    b = utils.hexToDec (builtins.substring 5 2 colorHex);
    rgb = "${toString r}, ${toString g}, ${toString b}";
    hex = colorHex;
    hexTransparent = transparency: colorHex + (utils.decToHex (builtins.floor (transparency * 255)));
  };
  red = color "#ff6188";
  orange = color "#fc9867";
  yellow = color "#ffd866";
  green = color "#a9dc76";
  blue = color "#78dce8";
  magenta = color "#ab9df2";
  cyan = color "#00ffff"; #TODO
  # base colors, sorted from darkest to lightest
  base0 = color "#19181a";
  base1 = color "#221f22";
  base2 = color "#2d2a2e";
  base3 = color "#403e41";
  base4 = color "#5b595c";
  base5 = color "#727072";
  base6 = color "#939293";
  base7 = color "#c1c0c0";
  base8 = color "#fcfcfa";

  gap = 8;
}
