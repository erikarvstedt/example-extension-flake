{
  description = "A demo flake that shows how extend nix-bitcoin.";

  inputs.nix-bitcoin.url = "github:erikarvstedt/nix-bitcoin/flake-tests";

  outputs = { self, nix-bitcoin }: let
    inherit (nix-bitcoin.inputs)
      nixpkgs
      flake-utils;

    makePkg = pkgs: pkgs.callPackage ./pkgs/tux-bitcoin {};

    tests = import ./test/tests.nix self;
  in {
    lib = {
      inherit (tests) scenarios;
    };

    nixosModules.default = { pkgs, ... }: {
      imports = [ ./modules/tux-bitcoin.nix ];

      services.tux-bitcoin.package = makePkg pkgs;
    };
  }
  // (flake-utils.lib.eachSystem nix-bitcoin.lib.supportedSystems (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages = rec {
        tux-bitcoin = makePkg pkgs;
        default = tux-bitcoin;
      };

      legacyPackages = tests.pkgs system;
    }
  ));
}
