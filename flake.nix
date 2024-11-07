{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devbox = {
      url = "github:jkinred/devbox";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs @
    { nixpkgs
    , nixvim
    , home-manager
    , devbox
    , ...
    }: {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";


          modules = [
            ./configuration.nix
            ./machines/vm/aarch64.nix
            ./graphical.nix


            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.sharedModules = [
                nixvim.homeManagerModules.nixvim
              ];
              home-manager.extraSpecialArgs = { inherit devbox; };

              home-manager.users.pmyjavec = import ./home;
            }
          ];
        };
      };
    };
}
