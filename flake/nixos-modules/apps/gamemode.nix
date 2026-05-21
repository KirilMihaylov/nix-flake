{
  flake.nixosModules.gamemode =
    {
      lib,
      ...
    }:
    {
      config.programs.gamemode.enable = true;

      options.host.gaming.users =
        let
          inherit (lib) mkOption types;

          inherit (types) listOf passwdEntry str;
        in
        mkOption {
          description = "Represents a list of users who should be given permissions to use Feral's GameMode capabilities.";

          type = listOf (passwdEntry str);
        };
    };
}
