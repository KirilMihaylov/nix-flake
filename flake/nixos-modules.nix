{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkOption pipe types;
in
{
  config.flake.nixosModules = config.flake.nixosModules';

  options.flake.nixosModules' =
    let
      inherit (types)
        attrsOf
        deferredModule
        listOf
        oneOf
        ;
    in
    mkOption {
      type = pipe deferredModule [
        (type: [
          type
          (listOf type)
        ])
        oneOf
        attrsOf
      ];
    };
}
