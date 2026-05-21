{
  flake.nixosModules.xbox-hardware =
    {
      lib,
      ...
    }:
    {
      hardware.xone.enable = true;

      host.allowUnfree.predicates = [
        (pkg: lib.getName pkg == "xone-dongle-firmware")
      ];
    };
}
