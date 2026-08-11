{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mapAttrs
    mkOption
    pipe
    toList
    types
    ;

  inherit (types)
    attrs
    enum
    functionTo
    loaOf
    path
    submodule
    ;

  mkOption' =
    type:
    mkOption {
      inherit type;
    };
in
{
  config.perSystem =
    {
      pkgs,
      ...
    }:
    {
      apps = mapAttrs (_: pkg: pkg pkgs) config.flake.apps';
    };

  options.flake.apps' =
    pipe
      {
        meta = mkOption' attrs;

        program = mkOption' path;

        type = pipe "app" [
          toList
          enum
          mkOption'
        ];
      }
      [
        (options: {
          inherit options;
        })
        submodule
        functionTo
        loaOf
        mkOption'
      ];
}
