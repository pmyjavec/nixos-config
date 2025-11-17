{ config, pkgs, inputs, ... }:

{
  imports = [ 
    ./common.nix 
    ./i3
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  home = {
    homeDirectory = "/home/pmyjavec";
    
    # Linux-specific packages
    packages = with pkgs; [
      _1password-cli
      xclip
      chromium

      # Linux-specific system tools
      iotop # io monitoring
      iftop # network monitoring
      strace # system call monitoring
      ltrace # library call monitoring
      sysstat
      ethtool
      pciutils # lspci
      usbutils # lsusb

      # Yubikey & Friends
      yubikey-personalization-gui
    ];
  };

  # GPG Agent setup, setup is a little more complicated
  # due to my Yubikey setup.
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableScDaemon = true;
    pinentryPackage = pkgs.pinentry-tty;
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };

  # Apparently this stops GPG from talking to ccid and
  # forces it to use the "SC" Daemon enabled above.
  #programs.gpg.scdaemonSettings = {
  #  disable-ccid = true;
  #};
}
