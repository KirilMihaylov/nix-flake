{
  flake.nixosModules'.drawy =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) getName mkDefault;

      inherit (pkgs) drawy;

      packages = [
        drawy
      ];
    in
    {
      environment.systemPackages = packages;

      xdg.mime = {
        addedAssociationsPackages = packages;

        defaultApplicationsPackages.${getName drawy} = {
          enable = mkDefault true;

          package = drawy;
        };
      };
    };
}
