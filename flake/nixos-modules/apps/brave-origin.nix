{
  flake.nixosModules'.brave-origin =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) getName mkDefault;

      inherit (pkgs.packages) brave-origin';

      packages = [
        brave-origin'
      ];
    in
    {
      environment.systemPackages = packages;

      xdg.mime = {
        addedAssociationsPackages = packages;

        defaultApplicationsPackages.${getName brave-origin'} = {
          order = mkDefault 85;

          package = brave-origin';
        };
      };
    };
}
