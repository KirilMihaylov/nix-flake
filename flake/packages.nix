{
  config.perSystem =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) const filterAttrs isDerivation;
    in
    {
      packages = filterAttrs (const isDerivation) pkgs.packages;
    };
}
