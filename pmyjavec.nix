# Home manager config 
{ config, pkgs, ... }:

let
  sources = import ../../nix/sources.nix;
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  # For our MANPAGER env var
  # https://github.com/sharkdp/bat/issues/1145
  manpager = (pkgs.writeShellScriptBin "manpager" (if isDarwin then ''
    sh -c 'col -bx | bat -l man -p'
    '' else ''
    cat "$1" | col -bx | bat --language man --style plain
  ''));
in {

  # TODO please change the username & home directory to your own
   home.username = "pmyjavec";
   home.homeDirectory = "/home/pmyjavec";
   home.shellAliases = { 
     cat = "bat";
   };

   home.sessionVariables = {
     LANG = "en_US.UTF-8";
     LC_CTYPE = "en_US.UTF-8";
     LC_ALL = "en_US.UTF-8";
     EDITOR = "nvim";
     PAGER = "less -FirSwX";
     MANPAGER = "${manpager}/bin/manpager";
   };

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # Whether to enable management of XDG base directories.
  xdg.enable = true;

  xdg.configFile = {
    "i3/config".text = builtins.readFile ./users/pmyjavec/dotfiles/i3;
  };

  xresources.extraConfig = builtins.readFile ./users/pmyjavec/dotfiles/Xresources;	

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them

#    neofetch
#    nnn # terminal file manager

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    # yq-go # yaml processor https://github.com/mikefarah/yq
    # eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils  # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc  # it is a calculator for the IPv4/v6 addresses

    # man pages
    man

    # misc
    #cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd

    # GPG, Yubikey & Friends
    gnupg
    yubikey-personalization
    yubico-piv-tool

    # Maybe yubico rqeuired stuff
    yubikey-personalization-gui
    yubikey-manager
    pass

    # fonts
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })
    iosevka 
    
    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    # nix-output-monitor

    # productivity
    # hugo # static site generator
    # glow # markdown previewer in terminal

    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb

    # Coding tools
    devbox
  ];

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Paul Myjavec";
    userEmail = "paul@myjavec.com";
  };

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
  	"sudo"
	"vi-mode"
      ];
    };
  };

  programs.bash.enable = true;

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

  # GPG Agent setup, setup is a little more complicated
  # due to my Yubikey setup.
  services.gpg-agent = {
    enable = true; 
    enableSshSupport = true;
    pinentryFlavor = "qt";
    enableScDaemon = true;
  };

  # Apparently this stops GPG from talking to ccid and 
  # forces it to use the "SC" Daemon enabled above.
  #programs.gpg.scdaemonSettings = { 
  #  disable-ccid = true;
  #};

  # Find and manage installed fonts from packages.
  fonts.fontconfig.enable = true;

  programs.wezterm = {
    enable = true;
    # TODO (pmyjavec) move this to a file.
    extraConfig = ''
      local wezterm = require 'wezterm'
      local config = {}

      if wezterm.config_builder then
        config = wezterm.config_builder()
      end

      config.audible_bell = 'Disabled'
      config.color_scheme = 'Tokyo Night Storm'
      config.enable_scroll_bar = true
      config.enable_wayland = true 
      config.font = wezterm.font 'FiraCode Nerd Font Mono Ret'
      config.font_size = 14.0
      config.hide_mouse_cursor_when_typing = true
      config.inactive_pane_hsb = {
        saturation = 0.6,
        brightness = 0.8,
      }
      config.pane_focus_follows_mouse = true
      config.scrollback_lines = 20000
      config.tab_bar_at_bottom = false 
      config.use_fancy_tab_bar = false
      config.window_background_opacity = 1.0
      
      config.visual_bell = {
        fade_in_function = 'EaseIn',
        fade_in_duration_ms = 150,
        fade_out_function = 'EaseOut',
        fade_out_duration_ms = 150,
      }

       config.colors = {
         visual_bell = '#202020',
       } 

      return config
    '';
  };

  # Make cursor not tiny on HiDPI screens
  home.pointerCursor = {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
    x11.enable = true;
  };
}
