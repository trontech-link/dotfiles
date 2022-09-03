{
  description =
    "Flake to manage my laptop, my nur and my hosts on Tencent Cloud";

  inputs = {
    # Core Dependencies
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };

    emacs = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";      
    };

    xddxdd = {
      url = "github:xddxdd/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    bttc = {
      #url = "github:xiongchenyu6/bttc";
      url = "/home/freeman/private/bttc";
      inputs.nixpkgs.follows = "nixpkgs";
     # inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, emacs, xddxdd, bttc, flake-utils
    , home-manager, ... }:
    let pkgsFor = system: import nixpkgs { inherit system; };
    in with nixpkgs;
    rec {
      # replace 'joes-desktop' with your hostname here.
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-hardware.nixosModules.lenovo-thinkpad-x1-9th-gen
          nixos-hardware.nixosModules.common-gpu-intel
          bttc.nixosModules.bttc
          ./nixos/configuration.nix
          ({ pkgs, ... }: {
            nixpkgs.overlays = [
              emacs.overlay
              (final: prev: {
                myRepo = self.packages."${prev.system}";
                xddxdd = xddxdd.packages."${prev.system}";
                b = bttc.packages."${prev.system}";
              })
            ];
          })
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = false;
            home-manager.users.freeman = import ./nixos/home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }

        ];
      };

      nixopsConfigurations = with lib; {
        default = rec {
          inherit nixpkgs;
          network.storage.legacy.databasefile = "~/.nixops/deployments.nixops";
          network.description = "tron sg";
          network.enableRollback = true;
          prometheus = rec {
            _module.args = with nixpkgs.lib; {
              inherit region;
              #  awsConfig = traceVal(fromTOML (builtins.readFile /home/freeman/.aws/credentials.toml));
            };
            # imports = [ ./ec2-info.nix ./prometheus.nix ./node-exporter.nix ];
          };
        };
      };

    } // flake-utils.lib.eachDefaultSystem (system:
      let pkgs = pkgsFor system;
      in rec {
        packages = import ./default.nix { inherit pkgs; };
        libs = import ./lib/default.nix { inherit pkgs; };
        overlays = import ./overlays/default.nix { inherit pkgs; };

        # used by nix develop and nix shell
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            # to test with nix (Nix) 2.7.0 and NixOps 2.0.0-pre-7220cbd use
            nix
            nixopsUnstable
          ];
        };
      });
}