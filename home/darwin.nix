{ config, pkgs, inputs, ... }:

{
  imports = [ ./common.nix ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  home = {
    homeDirectory = "/Users/pmyjavec";

    # macOS-specific packages
    packages = with pkgs; [
      # Note: Some packages like 1Password may work differently on macOS
      # You might want to install 1Password via App Store or direct download
      # For now, including compatible versions
      pinentry_mac
    ];
  };

  # macOS-specific GPG configuration
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableScDaemon = true;
    pinentry.package = pkgs.pinentry_mac;
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };

  # macOS-specific configurations
  targets.darwin.defaults = {
    # System preferences can be configured here
    # Example: dock settings, finder preferences, etc.
    "com.apple.dock" = {
      autohide = true;
      orientation = "bottom";
      tilesize = 48;
    };

    "com.apple.finder" = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "clmv"; # Column view
    };
  };

}
