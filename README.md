# Nix

My nix config. I'm no good at this, so here are the articles I'm referring to

https://borretti.me/article/nixos-for-the-impatient

https://drakerossman.com/blog/how-to-add-home-manager-to-nixos

https://heywoodlh.io/nixos-gnome-settings-and-keyboard-shortcuts

# Notable Fixes

## Steam

[Fix for installed games on external NTFS drive](https://github.com/ValveSoftware/Proton/wiki/Using-a-NTFS-disk-with-Linux-and-Windows#preventing-ntfs-read-errors)

```sh
mkdir -p ~/.steam/steam/steamapps/compatdata
ln -s ~/.steam/steam/steamapps/compatdata /mnt/attic/SteamLibrary/steamapps
```
