{
  inputs,
  self,
  ...
}:
{
  perSystem =
    {
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

        overlays = with self.overlays; [
          packages
        ];
      };
    };
}
