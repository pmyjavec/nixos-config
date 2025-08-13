{ config, pkgs, ... }:
{

  imports = [
    ./welcome.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    # Install alpha as an extraPlugin because the
    # alpha plugin in 23.11 module doesn't let us set a theme.
    globals.mapleader = " ";

    extraConfigLua = builtins.readFile ./nvim.lua;

    extraPlugins = with pkgs.vimPlugins; [ go-nvim ];

    keymaps = [
      {
        key = "<Leader>n";
        action = "<cmd>ene<CR>";
        options.desc = "New File";
      }
      {
        key = "<Leader>fw";
        action = "<cmd>Telescope live_grep<CR>";
        options.desc = "Find word";
      }
      {
        key = "<Leader>fo";
        action = "<cmd>Telescope oldfiles<CR>";
        options.desc = "Find Recents";
      }
      {
        key = "<Leader>ff";
        action = "<cmd>Telescope find_files<CR>";
        options.desc = "Find File(s)";
      }
      {
        key = "<Leader>fb";
        action = "<cmd>Telescope buffers<CR>";
        options.desc = "Find Buffers";
      }
      {
        key = "<Leader>fm";
        action = "<cmd>Telescope marks<CR>";
        options.desc = "Find Marks";
      }
      {
        key = "<Leader>fd";
        action = "<cmd>Telescope lsp_definitions<CR>";
        options.desc = "Find LSP Definitions";
      }
      {
        key = "<Leader>fr";
        action = "<cmd>Telescope lsp_references<CR>";
        options.desc = "Find LSP References";
      }
      {
        key = "<Leader>fm";
        action = "<cmd>Telescope marks<CR>";
        options.desc = "Find Marks";
      }
      {
        key = "<Leader>tf";
        action = "<cmd>ToggleTerm direction=float<CR>";
        options.desc = "ToggleTerm float";
      }
      {
        key = "<Leader>tf";
        action = "<cmd>ToggleTerm direction=horizontal<CR>";
        options.desc = "ToggleTerm horizontal";
      }
      {
        key = "<Leader>tr";
        action = "<cmd>Neotest run<CR>";
        options.desc = "Neotest Run";
      }
      {
        key = "<Leader>e";
        action = "<cmd>Neotree toggle<CR>";
        options.desc = "Explorer";
      }
      {
        key = "<Leader>gd";
        action = "<cmd>Diffview open<CR>";
        options.desc = "toggle diff";
      }
      {
        key = "<Leader>gg";
        action = "<cmd>LazyGit<CR>";
        options.desc = "Lazygit terminal";
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
      spell = true;
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
      settings = {
        style = "storm";
        transparent = false;
        terminal_colors = true;
        dim_inactive = true;
        lualine_bold = true;
        styles = {
          comments = { italic = true; };
          keywords = { italic = true; };
          functions = {};
          variables = {};
          sidebars = "dark";
          floats = "dark";
        };
        on_colors = ''
          function(colors)
            colors.bg = "#1a1b26"
            colors.bg_dark = "#1a1b26"
            colors.bg_float = "#1a1b26"
            colors.bg_popup = "#1a1b26"
            colors.bg_sidebar = "#1a1b26"
            colors.bg_statusline = "#1a1b26"
          end
        '';
      };
    };

    plugins = {
      auto-save.enable = true;
      auto-session.enable = false;
      comment.enable = true;
      conform-nvim.enable = true;
      diffview.enable = true;
      gitblame.enable = true;
      gitsigns.enable = true;
      hardtime.enable = true;
      indent-blankline.enable = true;
      lazygit.enable = true;
      lastplace.enable = true;
      leap.enable = false;
      lsp.enable = true;
      lsp.servers.gopls.enable = true;
      # Fixed: renamed from golangci-lint-ls to golangci_lint_ls
      lsp.servers.golangci_lint_ls.enable = true;
      lsp.servers.marksman.enable = true;
      lsp.servers.pyright.enable = true;
      lsp.servers.terraformls.enable = true;
      lsp.servers.bashls.enable = true;
      lspkind.enable = true;
      lualine.enable = true;
      luasnip.enable = true;
      friendly-snippets.enable = true;
      neo-tree.enable = true;
      neoscroll.enable = true;
      noice.enable = true;
      # Fixed: renamed from nvim-colorizer to colorizer
      colorizer.enable = true;
      tagbar.enable = true;
      toggleterm.enable = true;
      treesitter.enable = true;
      # Fixed: renamed from surround to vim-surround
      vim-surround.enable = true;
      trouble.enable = true;
      twilight.enable = true;
      copilot-vim.enable = false;
      # Fixed: explicitly enable web-devicons to avoid deprecation warning
      web-devicons.enable = true;
      copilot-lua = {
        enable = true;

        # Fixed: moved all settings under settings.*
        settings = {
          suggestion = {
            enabled = false;
            auto_trigger = false;  # Fixed: renamed from autoTrigger

            keymap = {
              accept = "<C-l>";
              next = "<C-j>";
              prev = "<C-k>";
              dismiss = "<C-h>";
            };
          };

          panel = {
            enabled = false;
            keymap = {
              open = false;
              accept = "<cr>";
              jump_next = "<C-j>";  # Fixed: renamed from jumpNext
              jump_prev = "<C-k>";  # Fixed: renamed from jumpPrev
              refresh = "<C-r>";
            };
          };

          filetypes = {
            javascript = true;
            typescript = true;
            css = true;
            rust = true;
            python = true;
            java = true;
            c = true;
            cpp = true;
            nix = true;
            lua = true;

            yaml = false;
            markdown = false;
            help = false;
            gitcommit = false;
            gitrebase = false;
            hgcommit = false;
            svn = false;
            cvs = false;
            "." = false;
          };
        };
      };
      cmp = {
        enable = true;
        settings.sources =
          [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
            { name = "luasnip"; }
            { name = "cmdline"; }
            { name = "copilot"; }
          ];

        settings.mapping = {
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-e>" = "cmp.mapping.close()";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
        };

        settings.snippet.expand = ''
        function(args)
        require('luasnip').lsp_expand(args.body)
        end
        '';
      };
      cmp-cmdline.enable = true;
      copilot-cmp.enable = true;
      telescope = {
        enable = true;
        settings = {
          defaults = {
            set_env.COLORTERM = "truecolor";
            sorting_strategy = "ascending";
            selection_caret = "> ";
            layout_config.prompt_position = "top";
          };
        };
      };

      neotest = {
        enable = true;
        adapters = {
          python.enable = true;
          go.enable = true;
        };
      };

      which-key = {
        enable = true;
        # Fixed: replaced deprecated registrations with settings.spec
        settings = {
          spec = [
            {
              __unkeyed-1 = "<Leader>f";
              group = " Find";
            }
            {
              __unkeyed-1 = "<Leader>t";
              group = " Terminal";
            }
          ];

          plugins = {
            registers = false;
            spelling = {
              enabled = true;
              suggestions = 20;
            };
          };
        };
      };
    };
  };
}
