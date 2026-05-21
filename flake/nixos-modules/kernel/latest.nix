{
  flake.nixosModules.kernel-latest =
    {
      pkgs,
      ...
    }:
    {
      host.kernel = pkgs.linuxPackages_latest.kernel;
    };
}
