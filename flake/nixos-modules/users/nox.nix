let
  user = "nox";
in
{
  flake.nixosModules'."user-${user}" =
    {
      config,
      lib,
      ...
    }:
    {
      programs.fish.enable = true;

      home-manager.users.${user} = { };

      users = {
        groups.${user} = { };

        users.${user} = {
          description = "Nox Æterna";

          group = user;

          extraGroups = [
            "users"
            "wheel"
          ]
          ++ lib.optional config.networking.networkmanager.enable "networkmanager";

          initialPassword = "initpass";

          isNormalUser = true;

          shell = config.programs.fish.package;
        };
      };
    };
}
