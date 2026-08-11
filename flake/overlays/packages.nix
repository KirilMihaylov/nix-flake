args@{
  self,
  ...
}:
{
  flake.overlays.packages =
    final: prev:
    let
      inherit (final) lib newScope;

      inherit (lib)
        attrNames
        filesystem
        foldl'
        isFunction
        makeScope
        ;
    in
    {
      packages = makeScope newScope (
        scope:
        let
          modules = filesystem.listFilesRecursive (self + "/packages");

          importedModules = map import modules;

          importedModules' = map (module: if isFunction module then module args else module) importedModules;
        in
        foldl' (
          acc: module:
          foldl' (
            acc: name:
            assert !(acc ? name);
            acc
            // {
              ${name} = scope.callPackage module.${name} { };
            }
          ) acc (attrNames module)
        ) { } importedModules'
      );
    };
}
