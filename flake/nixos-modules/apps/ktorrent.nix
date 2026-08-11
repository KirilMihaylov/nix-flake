{
  flake.nixosModules'.ktorrent =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) getName mkDefault;

      inherit (pkgs.kdePackages) ktorrent;

      packages = [
        ktorrent
      ];
    in
    {
      environment.systemPackages = packages;

      xdg.mime = {
        addedAssociationsPackages = packages;

        defaultApplicationsPackages.${getName ktorrent} = {
          enable = mkDefault true;

          package = ktorrent;
        };
      };
    };
}
