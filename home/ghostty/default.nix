{ config, pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    package = null; # Ghostty is not available in nixpkgs on macOS
    enableZshIntegration = true;
    installVimSyntax = true;
    settings = {
      theme = "tokyonight";
      font-family = "FiraCode Nerd Font";
      font-size = 14;
    };
  };
}
