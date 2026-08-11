{
  flake.nixosModules'.base =
    {
      host,
      ...
    }:
    {
      boot.kernelParams = [
        "systemd.default_device_timeout_sec=infinity"
      ];

      console = {
        earlySetup = true;

        useXkbConfig = true;
      };

      networking = {
        firewall.enable = true;

        hostName = host;
      };

      services.udisks2.enable = true;

      system.includeBuildDependencies = true;

      systemd.enableStrictShellChecks = true;
    };
}
