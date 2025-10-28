{
  pkgs,
  theme,
  ...
}: {
  services.mako.enable = true;
  services.mako.settings = {
    sort = "+time";
    layer = "overlay";

    margin = 4;
    outer-margin = 8;

    width = 400;
    height = 250;
    text-color = theme.base8.hex;
    background-color = theme.base1.hex;
    border-size = 1;
    border-color = theme.blue.hex;
    progress-color = "source ${theme.base4.hex}";
    font = "GohuFont 11";

    icons = 1;
    icon-location = "left";
    max-icon-size = 48;

    default-timeout = 5000;
    ignore-timeout = 0;
    max-visible = 7;
    anchor = "top-right";
    markup = 1;
    actions = 1;
    history = 0;
  };
}
