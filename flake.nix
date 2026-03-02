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

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
    # Create an overlay or just separate import for unstable
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations = {
      # 🖥️ Host 1: Remote
      nix-remote = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs pkgs-unstable;};
        modules = [
          ./hosts/nix-remote/default.nix
        ];
      };

      # 💻 Host 2: Client
      nix-client = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs pkgs-unstable;};
        modules = [
          ./hosts/nix-client/default.nix
        ];
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      name = "nixos-config-shell";
      buildInputs = with pkgs; [
        statix
        deadnix
        alejandra
        pre-commit
        gitleaks
      ];
    };
  };
}
