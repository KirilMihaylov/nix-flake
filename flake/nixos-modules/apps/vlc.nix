{
  flake.nixosModules.vlc =
    {
      pkgs,
      ...
    }:
    let
      packages = [
        pkgs.vlc
      ];
    in
    {
      environment.systemPackages = packages;

      xdg.mime.defaultApplicationsPackages = packages;
    };
}
