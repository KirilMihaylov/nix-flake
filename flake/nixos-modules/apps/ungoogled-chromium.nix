{
  flake.nixosModules'.ungoogled-chromium =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) elem getName mkDefault;

      inherit (pkgs.packages) ungoogled-chromium';

      packages = [
        ungoogled-chromium'
      ];
    in
    {
      environment.systemPackages = packages;

      host.allowUnfree.predicates = [
        (
          pkg:
          elem (getName pkg) [
            "ungoogled-chromium"
            "ungoogled-chromium-unwrapped"
            "widevine-cdm"
          ]
        )
      ];

      xdg.mime = {
        addedAssociationsPackages = packages;

        defaultApplicationsPackages.${getName ungoogled-chromium'} = {
          order = mkDefault 90;

          package = ungoogled-chromium';
        };
      };
    };
}
