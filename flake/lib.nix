{
  lib,
  ...
}:
{
  options.flake.lib =
    let
      inherit (lib) mkOption types;

      inherit (types) anything attrsOf;
    in
    mkOption {
      type = attrsOf anything;
    };
}
