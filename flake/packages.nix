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
      inherit (lib) mkOption pipe types;

      inherit (types) functionTo lazyAttrsOf package;
    in
    mkOption {
      type = pipe package [
        functionTo
        lazyAttrsOf
      ];
    };
}
