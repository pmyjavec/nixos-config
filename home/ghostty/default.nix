{ config, pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    package = null; # Ghostty is not available in nixpkgs on macOS
    enableZshIntegration = true;
    settings = {
      # Theme & Appearance
      theme = "TokyoNight Storm";
      gtk-custom-css = "tab-style.css";
      window-theme = "ghostty";
      maximize = true;
      unfocused-split-opacity = 0.6;
      font-size = 14;
      cursor-style = "block";
      bell-features = "border";

      # Window & Tab Chrome
      window-new-tab-position = "end";
      window-subtitle = false;
      gtk-tabs-location = "bottom";
      gtk-toolbar-style = "flat";

      # Shell & Integration
      shell-integration = "detect";
      shell-integration-features = "no-cursor,sudo,title";
      split-inherit-working-directory = true;
      tab-inherit-working-directory = false;
      quit-after-last-window-closed = true;
      quit-after-last-window-closed-delay = "5m";

      # Scrollback & Mouse
      scrollback-limit = 104857600;
      mouse-hide-while-typing = true;
      mouse-scroll-multiplier = 3;

      # Keybinds
      keybind = [
        # General
        "shift+enter=text:\\x1b\\x0d"
        "ctrl+left_bracket=text:\\x1b"

        # Split Management
        "ctrl+j>shift+five=new_split:right"
        "ctrl+j>shift+apostrophe=new_split:down"
        "ctrl+j>x=close_surface"
        "ctrl+j>z=toggle_split_zoom"
        "ctrl+j>shift+e=equalize_splits"

        # Split Navigation (Vi-style)
        "ctrl+j>h=goto_split:left"
        "ctrl+j>j=goto_split:down"
        "ctrl+j>k=goto_split:up"
        "ctrl+j>l=goto_split:right"

        # Split Resizing
        "ctrl+j>alt+h=resize_split:left,100"
        "ctrl+j>alt+j=resize_split:down,100"
        "ctrl+j>alt+k=resize_split:up,100"
        "ctrl+j>alt+l=resize_split:right,100"

        # Tab Navigation
        "ctrl+j>c=new_tab"
        "ctrl+j>n=next_tab"
        "ctrl+j>p=previous_tab"
        "ctrl+j>comma=prompt_surface_title"
        "ctrl+j>one=goto_tab:1"
        "ctrl+j>two=goto_tab:2"
        "ctrl+j>three=goto_tab:3"
        "ctrl+j>four=goto_tab:4"
        "ctrl+j>five=goto_tab:5"
        "ctrl+j>six=goto_tab:6"
        "ctrl+j>seven=goto_tab:7"
        "ctrl+j>eight=goto_tab:8"
        "ctrl+j>nine=goto_tab:9"

        # Scrollback Search & Scroll Mode
        "ctrl+j>shift+slash=start_search"
        "ctrl+j>ctrl+n=navigate_search:next"
        "ctrl+j>ctrl+p=navigate_search:previous"
        "ctrl+j>bracket_left=activate_key_table:scroll"
        "scroll/catch_all=ignore"
        "scroll/shift+slash=start_search"
        "scroll/ctrl+u=scroll_page_fractional:-0.5"
        "scroll/ctrl+d=scroll_page_fractional:0.5"
        "scroll/k=scroll_page_lines:-1"
        "scroll/j=scroll_page_lines:1"
        "scroll/escape=scroll_to_bottom"
        "chain=deactivate_key_table"
        "scroll/q=scroll_to_bottom"
        "chain=deactivate_key_table"
        "scroll/ctrl+bracket_left=scroll_to_bottom"
        "chain=deactivate_key_table"

        # Miscellaneous
        "ctrl+j>r=reload_config"
        "ctrl+j>shift+semicolon=toggle_command_palette"

        # Quick Terminal
        "global:super+shift+backquote=toggle_quick_terminal"
      ];

      # Quick Terminal
      quick-terminal-size = "100%,100%";
      quick-terminal-position = "bottom";
      quick-terminal-screen = "mouse";
    };
  };
}
