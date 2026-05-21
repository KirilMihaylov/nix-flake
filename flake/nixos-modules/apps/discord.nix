{
  flake.nixosModules.discord =
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
        (pkg: lib.getName pkg == "discord")
      ];
    };
}
