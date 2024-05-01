{ config, pkgs, ... }:

let
  sources = import ../../nix/sources.nix;
in {
   # TODO please change the username & home directory to your own
   home.username = "pmyjavec";
   home.homeDirectory = "/home/pmyjavec";
   home.shellAliases = { 
     man = "batman";
     diff = "batdiff";

    
     cnp = "aws-vault exec cert-nonprod --";
     cnpa = "aws-vault exec cert-nonprod-admin --";
     cpr = "aws-vault exec cert-prod --";
     cpra = "aws-vault exec cert-prod-admin --";
   };

   home.sessionVariables = {
     LANG = "en_US.UTF-8";
     LC_CTYPE = "en_US.UTF-8";
     LC_ALL = "en_US.UTF-8";
     # Stop devbox from changing my prompt.
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
    nodejs
    # The following are specifically required for AstroNvim
    # even though things like fzf are just nice to have.
    # If I remove astronvim, I might not required somne of these
    # packages. 
    fzf
    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    # yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    tree-sitter
    lazygit
    gh

    chromium

    aws-vault
  ];

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
      config.enable_scroll_bar = false
      config.enable_wayland = false
      config.enable_tab_bar = false
      config.font = wezterm.font 'FiraCode Nerd Font Mono Ret'
      config.font_size = 9.0
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

       config.term = 'wezterm'

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

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    # Install alpha as an extraPlugin because the
    # alpha plugin in 23.11 module doesn't let us set a theme.
    globals.mapleader = " ";

    extraConfigLua = builtins.readFile ./users/pmyjavec/dotfiles/nvim.lua;	

    extraPlugins = with pkgs.vimPlugins; [ lazygit-nvim ];

    keymaps = [
      {
      #Telescope 
        key = "<Leader>fw";
        action = "<cmd>Telescope grep_string<CR>";
        options.desc = "Find word";
      }
      {
        key = "<Leader>fo";
        action = "<cmd>Telescope oldfiles";
        options.desc = "ToggleTerm old";
      }
      {
        key = "<Leader>tf";
        action = "<cmd>ToggleTerm direction=float<CR>";
        options.desc = "ToggleTerm float";
      }
    ];

    opts = {
      # backspace = vim.list_extend(vim.opt.backspace:get(), { "nostop" }) don't stop backspace at insert
      hidden = true; # Required for toggle term to persist shells
      breakindent = true; #wrap indent to match  line start
      clipboard = "unnamedplus"; #connection to the system clipboard
      cmdheight = 0; #hide command line unless needed
      #completeopt = { "menu", "menuone", "noselect" }; #Options for insert mode completion
      confirm = true; #raise a dialog asking if you wish to save the current file(s)
      copyindent = true; #copy the previous indentation on autoindenting
      cursorline = true; #highlight the text line of the cursor
      #diffopt = vim.list_extend(vim.opt.diffopt:get(), { "algorithm:histogram", "linematch:60" }); #enable linematch diff algorithm
      expandtab = true; #enable the use of space in tab
      fileencoding = "utf-8"; #file content encoding for the buffer
      #fillchars = { eob = " " }; #disable `~` on nonexistent lines
      foldcolumn = "1"; #show foldcolumn
      foldenable = true; #enable fold for nvim-ufo
      foldlevel = 99; #set high foldlevel for nvim-ufo
      foldlevelstart = 99; #start with all code unfolded
      history = 100; #number of commands to remember in a history table
      ignorecase = true; #case insensitive searching
      infercase = true; #infer cases in keyword completion
      laststatus = 3; #global statusline
      linebreak = true; #wrap lines at 'breakat'
      mouse = "a"; #enable mouse support
      number = true; #show numberline
      preserveindent = true; #preserve indent structure as much as possible
      pumheight = 10; #height of the pop up menu
      relativenumber = true; #show relative numberline
      shiftwidth = 2; #number of space inserted for indentation
      #shortmess = vim.tbl_deep_extend("force", vim.opt.shortmess:get(), { s = true, I = true }); #disable search count wrap and startup messages
      showmode = false; #disable showing modes in command line
      showtabline = 1; #always display tabline
      signcolumn = "yes"; #always show the sign column
      smartcase = true; #case sensitive searching
      splitbelow = true; #splitting a new window below the current one
      splitright = true; #splitting a new window at the right of the current one
      tabstop = 2; #number of space in a tab
      termguicolors = true; #enable 24-bit RGB color in the TUI
      timeoutlen = 500; #shorten key timeout length a little bit for which-key
      title = true; #set terminal title to the filename and path
      undofile = true; #enable persistent undo
      updatetime = 300; #length of time to wait before triggering the plugin
      #viewoptions = vim.tbl_filter(function(val) return val ~= "curdir" end, vim.opt.viewoptions:get())
      virtualedit = "block"; #allow going past end of line in visual block mode
      wrap = false; #disable wrapping of lines longer than the width of window
      writebackup = false; #disable making a backup before overwriting a file


    };
    
    colorschemes.tokyonight = {
      enable = true;
      style = "storm";
    };

    plugins = {
      auto-save.enable = true;
      comment-nvim.enable = true;
      copilot-lua.enable = true;
      gitsigns.enable = true;
      indent-blankline.enable = true;
      lsp.enable = true;
      lsp.servers.pyright.enable = true;
      lspkind.enable = true;
      lualine.enable = true;
      neo-tree.enable = true;
      nvim-colorizer.enable = true;
      toggleterm.enable = true;
      treesitter.enable = true;

      telescope = {
        enable = true;
        defaults = {
            set_env.COLORTERM = "truecolor";
            sorting_strategy = "ascending";
            selection_caret = "> ";
            layout_config.prompt_position = "top";
        };
      };
      which-key = {
	      enable = true;
	      registrations = {
          "<Leader>f" = " Find";
          "<Leader>t" = " Terminal";
	      };

        plugins = {
          marks = false;
          registers = false;
          spelling = {
            enabled = false;
            suggestions = 20;
          };
        };

      };
      alpha = {
       enable = true;
       iconsEnabled = true;
       layout = [
          {
            type = "padding";
            val = 2;
          }
          {
            type = "text";
            val = [
              "  ███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗  "
              "  ████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║  "
              "  ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║  "
              "  ██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║  "
              "  ██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║  "
              "  ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝  "
            ];
            opts = {
              position = "center";
              hl = "Type";
            };
          }
          {
            type = "padding";
            val = 2;
          }
          {
            type = "group";
	          opts.spacing = 1;
	          val = [
              {
                shortcut = "n";
                desc = " New file";
                command = "<CMD>ene <CR>";
              }
              {
	            shortcut = "SPC f f"; 
	            desc = "󰈞 Find file";
	            command = "<CMD>Telescope find_files<CR>";
	            }
                    {
	            shortcut = "SPC f o"; 
	            desc = "󰊄  Recently opened files";
	            command = "<CMD>Telescope oldfiles<CR>";
	            }
                    {
	            shortcut = "SPC f w"; 
	            #desc = "󰈬 Find word";
	            desc = "󰈬 Find word";
	            command = "<CMD>Telescope grep_string<CR>";
	            }
                    {
	            shortcut = "SPC f '"; 
	            desc = " Jump to bookmarks";
	            command = "<CMD>Telescope marks<CR>";
	            }
                    {
	            shortcut = "SPC s l"; 
	            desc = " Open last session";
	            command = "";
	            }
            ];
          }
          {
            type = "padding";
            val = 2;
          }
          {
            type = "text";
            val = "Inspiring quote here.";
            opts = {
              position = "center";
              hl = "Keyword";
            };
          }
        ];
      };

      #tagbar.enable = true;
      nvim-cmp = {
        enable = true;

        sources = [ [ { name = "nvim_lsp"; } ] ];
      };
    };
  };

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
