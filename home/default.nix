{ config, pkgs, ... }:

{
  imports = [
    ./i3
    ./nixvim
    ./wezterm
  ];

  #++ import ./programs
  #++ import ./shell
  #++ [
  #];

  # TODO please change the username & home directory to your own
  home = {

    username = "pmyjavec";
    homeDirectory = "/home/pmyjavec";
    shellAliases = {
      man = "batman";
      diff = "batdiff";
      cnp = "aws-vault exec cert-nonprod --";
      cnpa = "aws-vault exec cert-nonprod-admin --";
      cpr = "aws-vault exec cert-prod --";
      cpra = "aws-vault exec cert-prod-admin --";
      ls = "eza";
      lr = "eza -lrt created";
    };

    stateVersion = "23.11";

    sessionVariables = {
      LANG = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
    };

    # Packages that should be installed to the user profile.
    packages = with pkgs; [
      neofetch
      nnn

      # archives
      zip
      xz
      unzip
      p7zip

      # networking tools
      mtr # A network diagnostic tool
      iperf3
      dnsutils # `dig` + `nslookup`
      ldns # replacement of `dig`, it provide the command `drill`
      aria2 # A lightweight multi-protocol & multi-source command-line download utility
      socat # replacement of openbsd-netcat
      nmap # A utility for network discovery and security auditing
      ipcalc # it is a calculator for the IPv4/v6 addresses

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
      yubikey-personalization-gui
      yubikey-manager
      pass

      # fonts
      (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })
      iosevka

      # system utils
      btop # replacement of htop/nmon
      iotop # io monitoring
      iftop # network monitoring
      strace # system call monitoring
      ltrace # library call monitoring
      lsof # list open files
      sysstat
      ethtool
      pciutils # lspci
      usbutils # lsusb

      # Coding / dev tools
      devbox
      nodejs

      fzf
      ripgrep # recursively searches directories for a regex pattern
      jq # A lightweight and flexible command-line JSON processor
      eza
      tree-sitter
      lazygit

      # CI/CD tools
      gh
      circleci-cli


      chromium

      aws-vault

      #Kubernetes
      k9s
      kubectl
    ];
  };

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Paul Myjavec";
    userEmail = "pauly@myjavec.com";

    # gpg --list-secret-keys --keyid-format=long will give us the "key"
    # value.
    signing = {
      key = "1C8A0D94F1C4F794";
      signByDefault = true;
    };

    delta = {
      enable = true;
    };

    push = {
      autoSetupRemote = true;
    };

    extraConfig = {
      url = {
        "ssh://git@github.com/" = {
          insteadOf = "https://github.com/";
        };
      };
    };
  };

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      aws.disabled = true;
      nix_shell.disabled = true;
      package.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  programs.zsh = {
    enable = true;
    sessionVariables = {
      DEVBOX_NO_PROMPT = "true";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "vi-mode"
        "z"
      ];
    };
  };

  programs.bash.enable = true;


  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Direnv
  programs.direnv.enable = true;

  # GPG Agent setup, setup is a little more complicated
  # due to my Yubikey setup.
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableScDaemon = true;
    pinentryPackage = pkgs.pinentry-tty;
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };

  # Apparently this stops GPG from talking to ccid and
  # forces it to use the "SC" Daemon enabled above.
  #programs.gpg.scdaemonSettings = {
  #  disable-ccid = true;
  #};

  # Find and manage installed fonts from packages.
  fonts.fontconfig.enable = true;


  programs.bat = {
    enable = true;

    config = {
      pager = "less -FR";
      theme = "tokyonight";
    };

    themes = {
      tokyonight = {
        src = pkgs.fetchFromGitHub {
          owner = "folke";
          repo = "tokyonight.nvim"; # Bat uses sublime syntax for its themes
          rev = "main";
          sha256 = "vUEPbgDen3ubcyJZdWCgnChOo1T0LFvZI++8RgGGx1Y=";
        };

        file = "extras/sublime/tokyonight_storm.tmTheme";
      };
    };

    extraPackages = with pkgs.bat-extras; [ batdiff batman ];
  };
}
