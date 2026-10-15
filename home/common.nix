{ config, pkgs, lib, inputs, ... }:

{

  imports = [
    ./nixvim
    ./wezterm
    ./ghostty
    inputs.omp.homeManagerModules.default
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
      ps = "procs";
      k = "kubectl";
      kx = "kubectx";
      v = "nvim";
      vim = "nvim";
      lg = "${pkgs.lazygit}/bin/lazygit";
      rr = "cd \"$(git rev-parse --show-toplevel)\"";
    };

    sessionVariables = {
      LANG = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";

    };

    # Cross-platform packages only
    packages = with pkgs; [
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

      # system utils
      btop # replacement of htop/nmon
      lsof # list open files
      gron
      procs # replacement of ps; identical output/flags on macOS and Linux
      bandwhich # live per-process network utilization; needs sudo to run
      process-compose

      # Coding / dev tools
      nodejs
      herdr
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

      jsonnet

      vkquake

      # lgit: LLM commit messages, routed through the local omp auth-gateway.
      (pkgs.callPackage ../pkgs/lgit.nix { })

      # opencommit (`oco`): same gateway via OCO_* session variables below.
      (pkgs.callPackage ../pkgs/opencommit.nix { })
    ];
  };

  programs.omp = {
    enable = true;
    settings = {
      startup.quiet = true;
      modelRoles.default = "github-copilot/claude-fable-5.1";
    };
  };

  # ~/.opencommit stays unmanaged so `oco config set` still works.
  # The gateway runs with --no-auth on loopback, so the API key is a dummy.
  # Model ids are provider-prefixed as listed by GET /v1/models on the gateway.
  home.sessionVariables = {
    OMP_AUTH_BROKER_URL = "http://127.0.0.1:8765";
    OCO_AI_PROVIDER = "openai";
    OCO_API_URL = "http://127.0.0.1:4000/v1";
    OCO_API_KEY = "omp-auth-gateway";
    OCO_MODEL = "github-copilot/claude-haiku-4.5";
    OCO_EMOJI = "false";
  };

  # omp auth-broker (credential vault, :8765) and auth-gateway (OpenAI-compatible
  # proxy, :4000): launchd agents on macOS, systemd user units on Linux.
  launchd.agents = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (
    lib.mapAttrs
      (name: args: {
        enable = true;
        config = {
          ProgramArguments = [ "${config.programs.omp.package}/bin/omp" ] ++ args;
          EnvironmentVariables.OMP_AUTH_BROKER_URL = "http://127.0.0.1:8765";
          KeepAlive = true;
          RunAtLoad = true;
          StandardOutPath = "${config.home.homeDirectory}/Library/Logs/${name}.log";
          StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/${name}.err";
        };
      })
      {
        omp-auth-broker = [ "auth-broker" "serve" "--bind=127.0.0.1:8765" ];
        omp-auth-gateway = [ "auth-gateway" "serve" "--bind=127.0.0.1:4000" "--no-auth" ];
      }
  );

  systemd.user.services = lib.mkIf pkgs.stdenv.hostPlatform.isLinux (
    lib.mapAttrs
      (name: cmd: {
        Unit.Description = name;
        Service = {
          ExecStart = "${config.programs.omp.package}/bin/omp ${cmd}";
          Environment = [ "OMP_AUTH_BROKER_URL=http://127.0.0.1:8765" ];
          Restart = "always";
          RestartSec = 5;
        };
        Install.WantedBy = [ "default.target" ];
      })
      {
        omp-auth-broker = "auth-broker serve --bind=127.0.0.1:8765";
        omp-auth-gateway = "auth-gateway serve --bind=127.0.0.1:4000 --no-auth";
      }
  );

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

      source ~/.config/shell/process-compose.sh

      # devbox points HISTFILE at <project>/.devbox/shell_history (after
      # sourcing this file), fragmenting history per project/worktree.
      # Force global history from a precmd hook so it wins regardless of
      # rc ordering.
      _force_global_histfile() {
        [[ "$HISTFILE" != "$HOME/.zsh_history" ]] && export HISTFILE="$HOME/.zsh_history"
      }
      autoload -Uz add-zsh-hook
      add-zsh-hook precmd _force_global_histfile
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [
        "aws"
        "history"
        "git"
        "sudo"
        "vi-mode"
      ];
    };
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      source ~/.config/shell/process-compose.sh
    '';
  };

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Direnv
  programs.direnv.enable = true;

  # zoxide - smarter cd; `z <dir>` jumps to best match, `zi` opens a picker
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

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
    settings."*".ServerAliveInterval = 30;
  };

  # process-compose: a shared, consistent log location + rotation policy for
  # every project, so logs don't end up scattered per-project. See
  # https://f1bonacc1.github.io/process-compose/logging/
  xdg.configFile."process-compose/logging.yaml".text = ''
    log_location: "${config.home.homeDirectory}/.local/state/process-compose/pc.log"
    log_configuration:
      add_timestamp: true
      timestamp_format: "2006-01-02T15:04:05Z07:00"
      flush_each_line: true
      rotation:
        max_size_mb: 50
        max_age_days: 14
        max_backups: 5
        compress: true
  '';

  # `-f`/`PC_CONFIG_FILES` fully replaces process-compose's default file
  # discovery, so we can't just export an env var to inject the shared
  # config above alongside a project's own file. Instead, wrap the CLI:
  # always load the shared config, plus whichever of process-compose's
  # own default filenames exist in the cwd.
  xdg.configFile."shell/process-compose.sh".text = ''
    pc() {
      local files=("$HOME/.config/process-compose/logging.yaml")
      local f
      for f in process-compose.yml process-compose.yaml \
               process-compose.override.yml process-compose.override.yaml; do
        [[ -f "$f" ]] && files+=("$f")
      done

      local flags=()
      for f in "''${files[@]}"; do
        flags+=(-f "$f")
      done

      command process-compose "''${flags[@]}" "$@"
    }
  '';
}
