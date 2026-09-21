{ config, lib, pkgs, inputs, ... }:

{
  imports = [ ./common.nix ];

  programs._1password-shell-plugins = {
    enable = true;
    plugins = with pkgs; [ gh awscli2 ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Override fish to skip failing tests on macOS
  nixpkgs.overlays = [
    (final: prev: {
      fish = prev.fish.overrideAttrs (old: {
        doCheck = false;
      });
    })
  ];

  # Weekly garbage collection of old home-manager generations (launchd agent).
  # Only prunes this user's profiles; the daemon's own roots need `sudo nix-collect-garbage -d`.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  # HM's launchd agent passes `options` as one argv element, which nix-collect-garbage
  # rejects ("unrecognised flag '--delete-older-than 30d'"). Split it ourselves.
  launchd.agents.nix-gc.config.ProgramArguments = lib.mkForce (
    [ "${pkgs.nix}/bin/nix-collect-garbage" ] ++ lib.splitString " " config.nix.gc.options
  );

  home = {
    homeDirectory = "/Users/pmyjavec";

    # macOS-specific session variables
    sessionVariables = {
      # aws-vault configuration for macOS
      AWS_VAULT_BACKEND = "keychain";
      AWS_VAULT_KEYCHAIN_NAME = "aws-vault";
    };

    # macOS-specific packages
    packages = with pkgs; [
      # Note: Some packages like 1Password may work differently on macOS
      # You might want to install 1Password via App Store or direct download
      # For now, including compatible versions
      pinentry_mac

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
    defaultCacheTtlSsh = 31536000;
    maxCacheTtlSsh = 31536000;
    extraConfig = ''
      allow-preset-passphrase
    '';
  };

  # GPG configuration for YubiKey - resolves CCID conflicts
  programs.gpg = {
    enable = true;
    scdaemonSettings = {
      disable-ccid = true;
      # This might stop some extra prompting for my YK pin :shruggie...
      disable-application = "piv";
    };
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
