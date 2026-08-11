{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkOption pipe types;

  inherit (types)
    attrsOf
    deferredModule
    listOf
    oneOf
    ;
in
{
  config.flake.nixosModules = config.flake.nixosModules';

  options.flake.nixosModules' = mkOption {
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
