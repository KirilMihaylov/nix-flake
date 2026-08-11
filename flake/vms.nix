{
  lib,
  self,
  ...
}:
{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages = lib.concatMapAttrs (host: system: {
        "vm-${host}" =
          (system.override {
            vmHostPkgs = pkgs;
          }).config.virtualisation.vmVariant.system.build.vm;
      }) self.nixosConfigurations;
    };
}
