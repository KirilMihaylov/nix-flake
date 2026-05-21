{
  flake.nixosModules.gwenview =
    {
      pkgs,
      ...
    }:
    let
      packages = [
        pkgs.kdePackages.gwenview
      ];
    in
    {
      environment.systemPackages = packages;

      xdg.mime.defaultApplicationsPackages = packages;
    };
}
