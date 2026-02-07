{
  description = "NixOS Workstation Flake";

  inputs = {
    # --- Official NixOS Packages ---
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # --- Home Manager ---
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- Browsers ---
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    helium.url = "github:FKouhai/helium2nix/main";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    # Create an overlay or just separate import for unstable
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations = {
      nix-workstation = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs pkgs-unstable; };
        modules = [
          ./hosts/nix-workstation/default.nix
        ];
      };
    };
  };
}