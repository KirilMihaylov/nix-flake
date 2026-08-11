{
  lib,
  ...
}:
{
  config.perSystem =
    {
      pkgs,
      ...
    }:
    {
      inherit (pkgs) packages;
    };

  options.flake.packages' =
    let
      inherit (lib) mkOption types;

      inherit (types) functionTo lazyAttrsOf package;
    in
    mkOption {
      type = lazyAttrsOf (functionTo package);
    };
}
