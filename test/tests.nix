flake:
let
  scenarios = {
    default = { config, ... }: {
      imports = [ flake.nixosModules.default ];

      tests.tux-bitcoin = config.services.tux-bitcoin.enable;
      services.tux-bitcoin.enable = true;

      test.extraTestScript = builtins.readFile ./tests.py;
    };
  };

in {
  inherit scenarios;

  pkgs = system: let
    inherit (flake.inputs.nix-bitcoin.legacyPackages.${system}) makeTest;
  in
    {
      tests = {
        default = makeTest {
          name = "tux-bitcoin";
          config = {
            imports = [ scenarios.default ];

            # Run shellcheck on all services defined by this flake
            test.shellcheckServices.sourcePrefix = toString ./..;
          };
        };
      };
    };
}
