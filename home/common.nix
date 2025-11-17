{ config, pkgs, ... }:

{
  imports = [
    ./nixvim
    ./wezterm
  ];

  home = {
    username = "pmyjavec";
    stateVersion = "23.11";

    shellAliases = {
      man = "batman";
      diff = "batdiff";
      cnp = "aws-vault exec cert-nonprod --";
      cnpa = "aws-vault exec cert-nonprod-admin --";
      cpr = "aws-vault exec cert-prod --";
      cpra = "aws-vault exec cert-prod-admin --";
      ls = "eza";
      lr = "eza -lrt created";
      k = "kubectl";
      kx = "kubectx";
      v = "nvim";
      vim = "nvim";
      lg = "${pkgs.lazygit}/bin/lazygit";
    };

    sessionVariables = {
      LANG = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";

    };

    # Cross-platform packages only
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
      file
      which
      tree
      gnused
      gnutar
      gawk
      zstd

      # fonts
      pkgs.nerd-fonts.fira-code
      iosevka

      # system utils
      btop # replacement of htop/nmon
      lsof # list open files
      gron

      # Coding / dev tools
      nodejs
      devbox

      fzf
      ripgrep # recursively searches directories for a regex pattern
      jq # A lightweight and flexible command-line JSON processor
      eza
      tree-sitter
      copier

      # CI/CD tools
      gh
      circleci-cli

      aws-vault
      ssm-session-manager-plugin

      #Kubernetes
      k9s
      kubectl
      kubelogin
      kubelogin-oidc
      kubectx

      # Docker tools
      docker
      docker-compose
      docker-buildx
      lazydocker

      # Add claude-code
      claude-code
      gemini-cli
      stripe-cli
      oci-cli
      awscli2

      # GPG and password management (cross-platform)
      gnupg
      pass


      # YubiKey support (cross-platform)
      yubikey-manager
      yubikey-personalization
      yubico-piv-tool

      # Bruno, API explorer.
      bruno
    ];
  };

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;

    # gpg --list-secret-keys --keyid-format=long will give us the "key"
    # value.
    signing = {
      key = "1C8A0D94F1C4F794";
      signByDefault = true;
    };

    ignores = [
      ".DS_Store"
      ".claude"
    ];

    settings = {
      user = {
        name = "Paul Myjavec";
        email = "pauly@myjavec.com";
      };

      url = {
        "ssh://git@github.com/" = {
          insteadOf = "https://github.com/";
        };
      };

      push = {
        autoSetupRemote = true;
      };
    };

    includes = [
      {
        condition = "hasconfig:remote.*.url:git@github.com:LF-Certification/**";
        contents = {
          user = {
            email = "pmyjavec@linuxfoundation.org";
          };
        };
      }
    ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  # lazygit configuration
  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        overrideGpg = true;
      };
      gui = {
        theme = {
          activeBorderColor = [ "#7aa2f7" "bold" ];
          inactiveBorderColor = [ "#565f89" ];
          optionsTextColor = [ "#7aa2f7" ];
          selectedLineBgColor = [ "#283457" ];
          selectedRangeBgColor = [ "#283457" ];
          cherryPickedCommitBgColor = [ "#414868" ];
          cherryPickedCommitFgColor = [ "#7aa2f7" ];
          unstagedChangesColor = [ "#f7768e" ];
          defaultFgColor = [ "#c0caf5" ];
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
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    sessionVariables = {
      DEVBOX_NO_PROMPT = "true";
    };
    initContent = ''
      # Source private aliases if they exist
      [[ -f ~/.aliases ]] && source ~/.aliases
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [
        "aws"
        "history"
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

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*".serverAliveInterval = 30;
  };
}
