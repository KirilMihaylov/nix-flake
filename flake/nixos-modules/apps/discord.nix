{
  flake.nixosModules'.discord =
    {
      lib,
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        discord
      ];

      host.allowUnfree.predicates = [
        (
          pkg:
          let
            name = lib.getName pkg;
          in
          name == "discord" || name == "discord-unwrapped"
        )
      ];
    };
}
