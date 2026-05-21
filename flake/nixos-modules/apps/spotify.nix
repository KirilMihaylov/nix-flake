{
  flake.nixosModules.spotify =
    {
      lib,
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        spotify
      ];

      host.allowUnfree.predicates = [
        (pkg: (lib.getName pkg) == "spotify")
      ];
    };
}
