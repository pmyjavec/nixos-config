{ config, pkgs, ... }:
{
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
}
