{
  flake.nixosModules'.vlc =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) getName mkDefault;

      inherit (pkgs) vlc;

      packages = [
        vlc
      ];
    in
    {
      environment.systemPackages = packages;

      xdg.mime = {
        addedAssociationsPackages = packages;

        defaultApplicationsPackages.${getName vlc} = {
          enable = mkDefault true;

          package = vlc;
        };
      };
    };
}
