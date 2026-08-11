{
  flake.nixosModules'.easyeffects =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) getName mkDefault;

      inherit (pkgs) easyeffects;

      packages = [
        easyeffects
      ];
    in
    {
      environment.systemPackages = packages;

      xdg.mime = {
        addedAssociationsPackages = packages;

        defaultApplicationsPackages.${getName easyeffects} = {
          enable = mkDefault true;

          package = easyeffects;
        };
      };
    };
}
