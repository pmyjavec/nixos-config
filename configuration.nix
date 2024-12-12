{ config, pkgs, ... }:

{
  imports = [
    # Includenixpkgs the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  system.stateVersion = "23.11";

  # ......
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [
    # Flakes clones its dependencies through the git command,
    # so git must be installed first
    git
    neovim
    wget
    curl
    nmap
  ];

  # Set the default editor to vim
  environment.variables.EDITOR = "neovim";

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;
  services.openssh.settings.PermitRootLogin = "yes";
  #users.users.root.initialPassword = "root";

  environment.shellAliases = {
    vim = "nvim";
  };


  # NOTE: There seems to be a bit of cross over between what is defined here
  # and what is found in the home manager (home.nix), find out why and if that
  # can be avoided...

  programs.nix-ld.enable = true;
  programs.zsh.enable = true;
  users.users.pmyjavec = {
    name = "pmyjavec";
    home = "/home/pmyjavec";
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    group = "pmyjavec";
    shell = pkgs.zsh;
    hashedPassword = "$y$j9T$gKBywVHsXk90f0R8W5nQD0$1EXQ/5al7Mq.UkI.RKdQuFWwPRG3AiOpJoML7WmExc0";
  };

  users.groups.pmyjavec = { };

  security.polkit.enable = true;

  # Added to support home manager.
  # Removes "dbus" errors.
  programs.dconf.enable = true;

  # The following is required by "aws-vault".
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;

  virtualisation.docker.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 8000 ];
  };
}
