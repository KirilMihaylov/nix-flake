{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
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
      type = attrsOf (oneOf [
        deferredModule
        (listOf deferredModule)
      ]);
    };
}
