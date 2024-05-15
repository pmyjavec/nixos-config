{ config, pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    # Install alpha as an extraPlugin because the
    # alpha plugin in 23.11 module doesn't let us set a theme.
    globals.mapleader = " ";

    extraConfigLua = builtins.readFile ./nvim.lua;	

    extraPlugins = with pkgs.vimPlugins; [ lazygit-nvim go-nvim ];

    keymaps = [
      {
      #Telescope 
        key = "<Leader>fw";
        action = "<cmd>Telescope live_grep<CR>";
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
      auto-session.enable =  false;
      comment-nvim.enable = true;
      copilot-lua.enable = true;
      gitsigns.enable = true;
      gitblame.enable = true;
      diffview.enable = true;
      indent-blankline.enable = true;
      lsp.enable = true;
      lsp.servers.pyright.enable = true;
      lsp.servers.gopls.enable = true;
      lspkind.enable = true;
      lualine.enable = true;
      neo-tree.enable = true;
      nvim-colorizer.enable = true;
      toggleterm.enable = true;
      treesitter.enable = true;
      lastplace.enable = true;

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
	            command = "<CMD>Telescope live_grep<CR>";
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
}
