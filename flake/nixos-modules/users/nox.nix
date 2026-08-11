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

          shell =
            let
              inherit (config.programs.fish) enable package;
            in
            assert enable;
            package;
        };
      };
    };
}
