{
  self,
  ...
}:
{
  flake.nixosModules.base =
    {
      host,
      ...
    }:
    {
      imports = with self.nixosModules; [
        boot-loader
        console-utils
        documentation
        firmware
        flakes
        helix
        home-manager
        host-options
        internationalisation
        nix
        nix-path
        nixpkgs-config
        unfree-redistributable
      ];

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

      system.includeBuildDependencies = true;

      systemd.enableStrictShellChecks = true;
    };
}
