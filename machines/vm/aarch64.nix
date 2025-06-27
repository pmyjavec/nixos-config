{ config, pkgs, lib, ... }: {

  imports = [
    ../../modules/vmware-guest.nix
  ];

  # Setup qfmu so we can run x86_64 binaries
  boot.binfmt.emulatedSystems = [ "x86_64-linux" ];
  # boot.binfmt.matchCredentials = true;

  boot.binfmt.registrations."x86_64" = {
    interpreter = "${pkgs.qemu}/bin/qemu-x86_64";
    matchCredentials = true;
    magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x3e\x00'';
  };

  # Disable the default module and import our override. We have
  # customizations to make this work on aarch64.
  disabledModules = [ "virtualisation/vmware-guest.nix" ];

  # Interface is this on M1
  # networking.interfaces.ens160.useDHCP = true;

  # Lots of stuff that uses aarch64 that claims doesn't work, but actually works.
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  # This works through our custom module imported above
  virtualisation.vmware.guest.enable = true;

  hardware.opengl.enable = true;

  # Share our host filesystem
  #fileSystems."/host" = {
  #  fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
  #  device = ".host:/";
  #  options = [
  #    "umask=22"
  #    "uid=1000"
  #    "gid=1000"
  #    "allow_other"
  #    "auto_unmount"
  #    "defaults"
  #  ];
  #};
}
