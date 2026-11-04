{
  description = "NixOS Workstation Flake";

  inputs = {
    # --- Official NixOS Packages ---
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # --- Home Manager ---
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- Browsers ---
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    helium = {
      url = "github:FKouhai/helium2nix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- VS Code Extensions ---
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- ActivityWatch (PR #578526) ---
    nixpkgs-activitywatch.url = "github:NixOS/nixpkgs/pull/578526/head";
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
    pkgs-activitywatch = import inputs.nixpkgs-activitywatch {
      inherit system;
      config.allowUnfree = true;
    };
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        (_final: _prev: {
          inherit
            (pkgs-activitywatch)
            activitywatch
            aw-server-rust
            aw-qt
            aw-notify
            aw-watcher-afk
            aw-watcher-window
            ;
          aw-sync = pkgs-activitywatch.rustPlatform.buildRustPackage {
            pname = "aw-sync";
            version = pkgs-activitywatch.aw-server-rust.version;
            src = pkgs-activitywatch.aw-server-rust.src;
            cargoHash = "sha256-x6Qp8nW3EbQbeVPrvV1UQdKMkU83qachrtNOGh30HWw=";
            auditable = false;
            nativeBuildInputs = [
              pkgs-activitywatch.pkg-config
              pkgs-activitywatch.perl
            ];
            buildInputs = [
              pkgs-activitywatch.openssl
            ];
            cargoBuildFlags = ["--package" "aw-sync"];
            cargoTestFlags = ["--package" "aw-sync"];
            doCheck = false;
            meta = {
              description = "ActivityWatch sync daemon";
              homepage = "https://github.com/ActivityWatch/aw-server-rust";
              mainProgram = "aw-sync";
            };
          };
        })
      ];
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
