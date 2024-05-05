{
  pkgs,
  lib,
  ...
}: {
  name,
  id,
  isDefault ? false,
  primaryColor ? "#000000",
  extraSettings ? {},
}: {
  name = name;
  id = id;
  isDefault = isDefault;
  settings =
    {
      "gfx.webrender.all" = true;
    }
    // extraSettings;
  userChrome = ''

    :root {
      --primary: ${primaryColor};
    }

    ${builtins.readFile ./firefox-theme.css}
  '';
}
