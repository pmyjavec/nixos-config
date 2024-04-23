{ config, pkgs, lib, currentSystem, currentSystemName,... }:

{
  # setup windowing environment
  services.xserver = {
    enable = true;
    layout = "us";
    dpi = 220;
  
    desktopManager = {
      xterm.enable = false;
      wallpaper.mode = "fill";
    };
  
    displayManager = {
      defaultSession = "none+i3";
      lightdm.enable = true;
  
      # AARCH64: For now, on Apple Silicon, we must manually set the
      # display resolution. This is a known issue with VMware Fusion.
      sessionCommands = ''
        ${pkgs.xorg.xset}/bin/xset r rate 200 40
      '';
    };
  
    windowManager = {
      i3.enable = true;
    };
  };
  
  fonts = {
    fontDir.enable = true;
  
    packages = [
      pkgs.fira-code
      pkgs.jetbrains-mono
    ];
  };
  
  
  environment.systemPackages = with pkgs; [
    cachix
    gnumake
    killall
    niv
    rxvt_unicode
    xclip
  
    # For hypervisors that support auto-resizing, this script forces it.
    # I've noticed not everyone listens to the udev events so this is a hack.
    (writeShellScriptBin "xrandr-auto" ''
      xrandr --output Virtual-1 --auto
    '')
  ] ++ lib.optionals (currentSystemName == "vm-aarch64") [
    # This is needed for the vmware user tools clipboard to work.
    # You can test if you don't need this by deleting this and seeing
    # if the clipboard sill works.
    gtkmm3
  ];
}
