{
  flake.nixosModules.hardening =
    {
      config,
      lib,
      ...
    }:
    {
      boot = {
        kernelParams = [
          "debugfs=off"
        ]
        ++ (
          let
            inherit (config.host.hardware) cpu;
          in
          if
            lib.elem cpu.arch [
              "x86"
              "x86_64"
            ]
          then
            [
              "iommu=on"
              "${cpu.manufacturer}_iommu=on"
            ]
          else
            [ ]
        );

        tmp.cleanOnBoot = true;
      };

      security = {
        forcePageTableIsolation = true;

        protectKernelImage = true;

        tpm2.enable = true;
      };
    };
}
