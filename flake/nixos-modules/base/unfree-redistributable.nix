{
  flake.nixosModules.unfree-redistributable =
    {
      lib,
      ...
    }:
    {
      nixpkgs.config.allowlistedLicenses = [
        lib.licenses.unfreeRedistributable
      ];
    };
}
