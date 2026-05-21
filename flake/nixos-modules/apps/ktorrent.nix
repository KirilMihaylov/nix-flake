{
  flake.nixosModules.ktorrent =
    {
      pkgs,
      ...
    }:
    let
      packages = [
        pkgs.kdePackages.ktorrent
      ];
    in
    {
      environment.systemPackages = packages;

      xdg.mime.defaultApplicationsPackages = packages;
    };
}
