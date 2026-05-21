{
  flake.nixosModules.razer-hardware =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = {
        environment.systemPackages = with pkgs; [
          polychromatic
        ];

        hardware.openrazer = {
          inherit (config.host.hardware.razer) users;

          enable = true;
        };
      };

      options.host.hardware.razer.users =
        let
          inherit (lib) mkOption types;

          inherit (types) listOf passwdEntry str;
        in
        mkOption {
          description = "Represents a list of users who should be given permissions to use OpenRazer capabilities.";

          type = listOf (passwdEntry str);
        };
    };
}
