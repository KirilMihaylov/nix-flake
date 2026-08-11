{
  flake.nixosModules'.krita =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) getName mkDefault;

      inherit (pkgs) krita;

      packages = [
        krita
      ];
    in
    {
      environment.systemPackages = packages;

      xdg.mime = {
        addedAssociationsPackages = packages;

        defaultApplicationsPackages.${getName krita} = {
          enable = mkDefault true;

          package = krita;
        };
      };
    };
}
