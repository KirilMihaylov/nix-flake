{
  flake.nixosModules.thunderbolt-hardware =
    {
      lib,
      pkgs,
      ...
    }:
    {
      services = {
        hardware.bolt.enable = true;

        udev.packages = [
          (pkgs.writeTextDir "etc/udev/rules.d" (
            lib.foldl'
              (accumulator: value: ''
                ${accumulator}ACTION=="add", SUBSYSTEM=="thunderbolt", ${value}
              '')
              ""
              [
                ''KERNEL=="domain0", ATTR{security}="usbonly"''
                ''ATTRS{iommu_dma_protection}=="0", ATTR{authorized}="0"''
                ''ATTRS{iommu_dma_protection}=="1", ATTR{authorized}=="0", ATTR{authorized}="1"''
              ]
          ))
        ];
      };
    };
}
