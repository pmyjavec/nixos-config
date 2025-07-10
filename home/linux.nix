{ config, pkgs, ... }:

{
  imports = [ 
    ./common.nix 
    ./i3
  ];

  home = {
    homeDirectory = "/home/pmyjavec";
    
    # Linux-specific packages
    packages = with pkgs; [
      _1password
      xclip
      chromium

      # GPG, Yubikey & Friends
      gnupg
      yubikey-personalization
      yubico-piv-tool
      yubikey-personalization-gui
      yubikey-manager
      pass
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