{
  lib,
  ...
}:
{
  options.flake.packages-generic =
    let
      inherit (lib) mkOption types;

      inherit (types) functionTo lazyAttrsOf package;
    in
    mkOption {
      type = lazyAttrsOf (functionTo package);
    };
}
