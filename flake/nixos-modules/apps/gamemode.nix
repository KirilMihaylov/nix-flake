{
  flake.nixosModules'.gamemode =
    {
      config,
      lib,
      ...
    }:
    let
      inherit (lib) foldl';
    in
    {
      programs.gamemode = {
        enable = true;

        enableRenice = true;

        settings.general.renice = 20;
      };

      users = {
        users = foldl' (
          acc: user:
          acc
          // {
            ${user}.extraGroups = [
              "gamemode"
            ];
          }
        ) { } config.host.gaming.users;
      };
    };
}
