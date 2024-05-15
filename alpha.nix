{
  plugins.alpha = {
    enable = true;
    layout = [
      {
        type = "padding";
        val = 4;
      }
      {
        opts = {
          hl = "Type";
          position = "center";
        };
        type = "text";
        val = [
        "              ██████              "
        "          ████▒▒▒▒▒▒████          "
        "        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒██        "
        "      ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██      "
        "    ██▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒        "
        "    ██▒▒▒▒▒▒  ▒▒▓▓▒▒▒▒▒▒  ▓▓▓▓    "
        "    ██▒▒▒▒▒▒  ▒▒▓▓▒▒▒▒▒▒  ▒▒▓▓    "
        "  ██▒▒▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒    ██  "
        "  ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██  "
        "  ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██  "
        "  ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██  "
        "  ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██  "
        "  ██▒▒██▒▒▒▒▒▒██▒▒▒▒▒▒▒▒██▒▒▒▒██  "
        "  ████  ██▒▒██  ██▒▒▒▒██  ██▒▒██  "
        "  ██      ██      ████      ████  "
        ];
      }
      {
        type = "padding";
        val = 2;
      }
      {
        opts = {
          hl = "Keyword";
          position = "center";
        };
        type = "text";
        val = "Boo";
      }
      {
        type = "padding";
        val = 4;
      }
      {
      	type = "group";
	opts = {
	  position = "center";
	};
        val = [
	  {
	    val = " Open File";
	    type = "button";
	    on_press.__raw = "require('telescope.builtin').find_files";
	    opts = {
	      shortcut = "<leader>sf";
	      position = "center";
	      cursor = 3;
	      width = 50;
	      align_shortcut = "right";
	      hl_shortcut = "Keyword";
	    };
	  }
	  {
	    on_press.__raw = "require('telescope.builtin').oldfiles";
	    opts = {
	      shortcut = "<leader>?";
	      position = "center";
	      cursor = 3;
	      width = 50;
	      align_shortcut = "right";
	      hl_shortcut = "Keyword";
	    };
	    type = "button";
	    val = " Open Recent";
	  }
	  {
	    on_press.__raw = "require('telescope.builtin').live_grep";
	    opts = {
	      shortcut = "<leader>sg";
	      position = "center";
	      cursor = 3;
	      width = 50;
	      align_shortcut = "right";
	      hl_shortcut = "Keyword";
	    };
	    type = "button";
	    val = " Search";
	  }
	  {
	    on_press.__raw = "function() vim.cmd[[qa]] end";
	    opts = {
	      keymap = ["n" "q" ":q<cr>" {noremap = true; silent = true; nowait = true;}];
	      shortcut = "q";
	      position = "center";
	      cursor = 3;
	      width = 50;
	      align_shortcut = "right";
	      hl_shortcut = "Keyword";
	    };
	    type = "button";
	    val = "󰩈 Quit Neovim";
          }
	];
      }
    ];
  };
}
