{
  programs.nixvim.plugins.alpha = {
    enable = true;
    settings.layout = [
      {
        type = "padding";
        val = 4;
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
        val = "N   E   O   V   I   M";
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
            on_press.__raw = "function() vim.cmd[[ene]] end";
            opts = {
              shortcut = "<leader>n<CR>";
              position = "center";
              cursor = 3;
              width = 50;
              align_shortcut = "right";
              hl_shortcut = "Keyword";
            };
            type = "button";
            val = "📄 New file";
          }
          {
            type = "padding";
            val = 1;
          }
          {
            val = "📂 Find File";
            type = "button";
            on_press.__raw = "require('telescope.builtin').find_files";
            opts = {
              shortcut = "<leader>ff<CR>";
              position = "center";
              cursor = 3;
              width = 50;
              align_shortcut = "right";
              hl_shortcut = "Keyword";
            };
          }
          {
            type = "padding";
            val = 1;
          }
          {
            on_press.__raw = "require('telescope.builtin').oldfiles";
            opts = {
              shortcut = "<leader>fo<CR>";
              position = "center";
              cursor = 3;
              width = 50;
              align_shortcut = "right";
              hl_shortcut = "Keyword";
            };
            type = "button";
            val = "🕑 Open Recent";
          }
          {
            type = "padding";
            val = 1;
          }
          {
            on_press.__raw = "require('telescope.builtin').live_grep";
            opts = {
              shortcut = "<leader>fw<CR>";
              position = "center";
              cursor = 3;
              width = 50;
              align_shortcut = "right";
              hl_shortcut = "Keyword";
            };
            type = "button";
            val = "🔍 Find Word";
          }
          {
            type = "padding";
            val = 1;
          }
          {
            on_press.__raw = "require('telescope.builtin').marks";
            opts = {
              shortcut = "<leader>fm<CR>";
              position = "center";
              cursor = 3;
              width = 50;
              align_shortcut = "right";
              hl_shortcut = "Keyword";
            };
            type = "button";
            val = "📘 Bookmarks";
          }
        ];
      }
    ];
  };
}
