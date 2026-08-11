{
  lib,
  ...
}:
{
  options.flake.lib =
    let
      inherit (lib) mkOption types;
    in
    mkOption {
      type = types.anything;
    };
}
