{ config, pkgs, ... }:
{
  programs.wezterm = {
    enable = true;
    # TODO (pmyjavec) move this to a file.
    extraConfig = builtins.readFile ./wezterm.lua;
  };
}
