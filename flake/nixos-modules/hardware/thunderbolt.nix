{
  flake.nixosModules'.thunderbolt-hardware =
    {
      lib,
      pkgs,
      ...
    }:
    {
      services = {
        hardware.bolt.enable = true;

        udev.packages =
          let
            inherit (lib) foldl' pipe toList;

            fold-functor = accumulator: value: ''
              ${accumulator}ACTION=="add", SUBSYSTEM=="thunderbolt", ${value}
            '';
          in
          pipe
            [
              ''KERNEL=="domain0", ATTR{security}="usbonly"''
              ''ATTRS{iommu_dma_protection}=="0", ATTR{authorized}="0"''
              ''ATTRS{iommu_dma_protection}=="1", ATTR{authorized}=="0", ATTR{authorized}="1"''
            ]
            [
              (foldl' fold-functor "")
              (pkgs.writeTextDir "etc/udev/rules.d")
              toList
            ];
      };
    };
}
