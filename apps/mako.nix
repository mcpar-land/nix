{
  pkgs,
  theme,
  ...
}: let
  center-controller = app-name: {
    "app-name=${app-name}" = {
      layer = "overlay";
      history = 0;
      anchor = "top-center";
      # Group all volume notifications together
      group-by = "app-name";
      # Hide the group-index
      format = "<b>%s</b>\\n%b";
    };
    "app-name=${app-name} group-index=0" = {
      # Only show last notification
      invisible = 0;
    };
  };
in {
  services.mako.enable = true;
  services.mako.settings =
    {
      sort = "+time";
      layer = "overlay";

      margin = theme.gap / 2;
      outer-margin = theme.gap;

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
      markup = true;
      actions = true;
      history = 1;
      "mode=gamemode-shush" = {
        invisible = 1;
      };
    }
    // (center-controller "notify-volume") // (center-controller "notify-brightness");
}
