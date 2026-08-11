{
  flake.nixosModules'.librecad =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) getName mkDefault;

      inherit (pkgs) librecad;

      packages = [
        librecad
      ];
    in
    {
      environment.systemPackages =
        with pkgs;
        packages
        ++ [
          libredwg
        ];

      xdg.mime = {
        addedAssociationsPackages = packages;

        defaultApplicationsPackages.${getName librecad} = {
          enable = mkDefault true;

          package = librecad;
        };
      };
    };
}
