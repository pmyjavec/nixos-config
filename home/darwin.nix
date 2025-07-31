{ config, pkgs, inputs, ... }:

{
  imports = [ ./common.nix ];

  programs._1password-shell-plugins = {
    enable = true;
    plugins = with pkgs; [ gh awscli2 ];
  };

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
      
      # Docker Desktop (install manually from docker.com)
      # docker-desktop not available in nixpkgs
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
    extraConfig = ''
      allow-preset-passphrase
      pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
      card-timeout 86400
    '';
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

  # Configure aws-vault and keyring settings
  home.sessionVariables = {
    AWS_VAULT_KEYCHAIN_NAME = "login";
    AWS_SESSION_TOKEN_TTL = "12h";
    AWS_ASSUME_ROLE_TTL = "1h";
    AWS_VAULT_BACKEND = "keychain";
    GPG_TTY = "$(tty)";
  };

}
