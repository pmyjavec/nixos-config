{
  description = "Cross-platform dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    onepassword-shell-plugins.url = "github:1Password/shell-plugins";
  };

  outputs =
    inputs @
    { nixpkgs
    , nixpkgs-darwin
    , nixvim
    , home-manager
    , onepassword-shell-plugins
    , ...
    }:
    let
      system-linux = "aarch64-linux";
      system-darwin = "aarch64-darwin";
    in
    {
      # NixOS configuration (Linux only)
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = system-linux;
          modules = [
            ./configuration.nix
            ./machines/vm/aarch64.nix
            ./graphical.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.sharedModules = [
                nixvim.homeModules.nixvim
              ];

              home-manager.users.pmyjavec = import ./home/linux.nix;
            }
          ];
        };
      };

      # Standalone Home Manager for macOS
      homeConfigurations = {
        pmyjavec = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs-darwin.legacyPackages.${system-darwin};
          extraSpecialArgs = { inherit inputs; };
          modules = [
            nixvim.homeModules.nixvim
            onepassword-shell-plugins.hmModules.default
            ./home/darwin.nix
          ];
        };
      };
    };
}
