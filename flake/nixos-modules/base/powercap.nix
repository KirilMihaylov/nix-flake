{
  flake.nixosModules'.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib)
        escapeShellArg
        foldl'
        getExe'
        mkOption
        types
        ;

      inherit (pkgs) coreutils;

      inherit (types) listOf passwdEntry str;

      chgrp = escapeShellArg (getExe' coreutils "chgrp");

      chmod = escapeShellArg (getExe' coreutils "chmod");
    in
    {
      config = {
        services.udev.extraRules = ''
          SUBSYSTEM=="powercap", KERNEL=="intel-rapl:0", RUN+="${chgrp} 'powercap' '/sys/%p/energy_uj'", RUN+="${chmod} 'g+r' '/sys/%p/energy_uj'"
        '';

        users = {
          groups.powercap = { };

          users = foldl' (
            acc: user:
            acc
            // {
              ${user}.extraGroups = [
                "powercap"
              ];
            }
          ) { } config.host.powercap.users;
        };
      };

      options.host.powercap.users = mkOption {
        description = "Represents a list of users who should be given permissions to read the Power Capping Framework's energy usage.";

        type = listOf (passwdEntry str);
      };
    };
}
