# accepts the following input format to create a rofi menu that evaluates scripts:
# [
#   {
#     "label": "Simple List",
#     "exec": "ls"
#   },
#   {
#     "label": "Complex List",
#     "exec": "ls -l"
#   },
#   {
#     "label": "Launch Helix",
#     "exec": "hx ."
#   },
#   {
#     "label": "Scrongbongle",
#     "exec": "echo i am beginning to scrongbongle && i have finished scrongbongling"
#   }
# ]
{pkgs}: scriptName: {
  options,
  prompt ? "",
  message ? "",
}: let
  rofiCmd = pkgs.lib.strings.concatStringsSep " " [
    "rofi"
    "-dmenu"
    "-i"
    "-p \"${prompt}\""
    (
      if message != ""
      then "-mesg \"${message}\""
      else ""
    )
  ];
in
  pkgs.writeShellScriptBin scriptName ''
    INPUT=$(cat <<EOF
      ${builtins.toJSON options}
    EOF)
    SELECTION=$(echo $INPUT | jq '.[] | .label' -r | ${rofiCmd})
    COMMAND=$(echo $INPUT | jq ".[] | select(.label == \"$SELECTION\") | .exec" -r)
    eval $COMMAND
  ''
