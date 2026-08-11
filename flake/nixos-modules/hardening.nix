{
  flake.nixosModules'.hardening =
    {
      config,
      lib,
      ...
    }:
    let
      inherit (config.host.hardware) cpu;

      inherit (cpu) arch manufacturer;

      inherit (lib) elem optionals;
    in
    {
      boot = {
        kernel.sysctl."net.mptcp.enable" = false;

        kernelParams = [
          "debugfs=off"
        ]
        ++
          optionals
            (elem arch [
              "x86"
              "x86_64"
            ])
            [
              "iommu=on"
              "${manufacturer}_iommu=on"
            ];

        tmp.cleanOnBoot = true;
      };

      nix.settings.allowed-users = [
        "@users"
      ];

      security = {
        forcePageTableIsolation = true;

        protectKernelImage = true;

        tpm2.enable = true;
      };
    };
}
