{
  inputs,
  self,
  ...
}:
{
  perSystem =
    {
      lib,
      system,
      ...
    }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;

        config = {
          allowUnfree = true;

          allowUnsupportedSystem = true;
        };

        overlays = lib.attrValues self.overlays;
      };
    };
}
