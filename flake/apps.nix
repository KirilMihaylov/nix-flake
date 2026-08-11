{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    flip
    id
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

  mkOption' = flip pipe [
    (type: {
      inherit type;
    })
    mkOption
  ];
in
{
  config.perSystem =
    {
      pkgs,
      ...
    }:
    {
      apps = mapAttrs (_: flip id pkgs) config.flake.apps';
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
