{
  flake.nixosModules'.gwenview =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) getName mkDefault;

      inherit (pkgs.kdePackages) gwenview;

      packages = [
        gwenview
      ];
    in
    {
      environment.systemPackages = packages;

      xdg.mime = {
        addedAssociationsPackages = packages;

        defaultApplicationsPackages.${getName gwenview} = {
          enable = mkDefault true;

          package = gwenview;
        };
      };
    };
}
