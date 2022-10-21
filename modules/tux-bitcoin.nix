{ config, pkgs, lib, ... }:

with lib;
let
  options = {
    services.tux-bitcoin = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable tux-bitcoin, a dummy service to showcase extending nix-bitcoin with Flakes.
          This service writes a tux-flavored cowsay output of `bitcoin-cli -getinfo` to file `${dataDir}/status`.
        '';
      };

      package = mkOption {
        type = types.package;
        description = ''
          The package providing the tux-bitcoin binary.
        '';
      };
    };
  };

  cfg = config.services.tux-bitcoin;
  nbLib = config.nix-bitcoin.lib;
  dataDir = "/var/lib/tux-bitcoin";
  inherit (config.services) bitcoind;
in {
  inherit options;

  config = mkIf cfg.enable {
    services.bitcoind.enable = true;

    systemd.services.tux-bitcoin = {
      wantedBy = [ "multi-user.target" ];
      after = [ "bitcoind.service" ];
      requires = [ "bitcoind.service" ];
      path = [ bitcoind.cli ];
      script = ''
        isReady=
        while :; do
          ${cfg.package}/bin/tux-bitcoin -getinfo > ${dataDir}/status
          if [[ ! $isReady ]]; then
            /run/current-system/systemd/bin/systemd-notify --ready
            isReady=1
          fi
          sleep 1
        done
      '';
      serviceConfig = nbLib.defaultHardening // {
        Type = "notify";
        NotifyAccess = "all";
        StateDirectory = "tux-bitcoin";
        User = bitcoind.user;
        Group = bitcoind.group;
        IPAddressAllow = [ (nbLib.address bitcoind.address) ];
      };
    };
  };
}
