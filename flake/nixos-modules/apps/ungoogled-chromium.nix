{
  flake.nixosModules.gwenview =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) elem getName;

      packages = [
        pkgs.packages.ungoogled-chromium'
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

      xdg.mime.defaultApplicationsPackages = packages;
    };
}
