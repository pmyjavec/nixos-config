{ pkgs
, config
, ...
}: {
  home.file.".config/i3/config".source = ./config;

  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xft.dpi" = 240;
    "Xft.autohint" = true;
    "Xft.antialias" = true;
    "Xft.hinting" = true;
    "Xft.hintstyle" = "hintslight";
    "Xft.rgba" = "rgb";
    "Xft.lcdfilter" = "lcddefault";
  };

  xresources.extraConfig = ''
    ${builtins.readFile (
        pkgs.fetchFromGitHub {
          owner = "folke";
          repo = "tokyonight.nvim";
          rev = "main";
          sha256 = "vUEPbgDen3ubcyJZdWCgnChOo1T0LFvZI++8RgGGx1Y=";
        } + "/extras/xresources/tokyonight_storm.Xresources"
      )}
  '';

  programs.i3status = {
    enable = true;

    general = {
      colors = true;
      color_good = "#9ece6a";
      color_bad = "#f7768e";
      color_degraded = "#ff9e64";
    };

    modules = {
      ipv6.enable = false;
      "wireless _first_".enable = false;
      "battery all".enable = false;
    };
  };

  # Make cursor not tiny on HiDPI screens
  home.pointerCursor = {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
    x11.enable = true;
  };
}
