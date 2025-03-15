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

  light = {
    red = color "#ff809f";
    orange = color "#fdaa82";
    yellow = color "#ffdf80";
    green = color "#bfe599";
    blue = color "#92e3ec";
    magenta = color "#9f8ef0";
    cyan = color "#80ffff";
  };

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

  white = color "#ffffff";
  black = color "#000000";

  gap = 8;
  barHeight = gap * 4;
  hexAttrSet = {
    red = red.hex;
    orange = orange.hex;
    yellow = yellow.hex;
    green = green.hex;
    blue = blue.hex;
    magenta = magenta.hex;
    cyan = cyan.hex;
    base0 = base0.hex;
    base1 = base1.hex;
    base2 = base2.hex;
    base3 = base3.hex;
    base4 = base4.hex;
    base5 = base5.hex;
    base6 = base6.hex;
    base7 = base7.hex;
    base8 = base8.hex;
    light = {
      red = light.red.hex;
      orange = light.orange.hex;
      yellow = light.yellow.hex;
      green = light.green.hex;
      blue = light.blue.hex;
      magenta = light.magenta.hex;
      cyan = light.cyan.hex;
    };
    gap = gap;
    barHeight = barHeight;
  };
  asJson = builtins.toJSON hexAttrSet;
  asLua = pkgs.lib.generators.toLua {} hexAttrSet;
}
