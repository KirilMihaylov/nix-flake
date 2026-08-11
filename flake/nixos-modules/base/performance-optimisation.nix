{
  self,
  ...
}:
{
  flake.nixosModules'.base =
    {
      lib,
      pkgs,
      ...
    }:
    {
      imports = with self.nixosModules; [
        kernel-bore-scheduler
      ];

      config = {
        boot.kernelParams = [
          "audit=0"
          "nohz_full=all"
          "nosoftlockup"
          "preempt=full"
          "skew_tick=1"
          "threadirqs"
          "usbcore.autosuspend=60"
          "workqueue.power_efficient=false"
        ];

        services.bpftune.enable = true;

        systemd.services.pci-latency = {
          description = "PCI latency timer setting.";

          enable = true;

          script = ''
            PATH=${
              lib.makeBinPath [
                pkgs.pciutils
              ]
            }":''${PATH}"
            export PATH

            setpci -v -s '*:*' 'latency_timer=20'

            setpci -v -s '0:0' 'latency_timer=0'

            # Configure audio devices to avoid audio gaps.
            setpci -v -d '*:*:04xx' 'latency_timer=80'
          '';

          wantedBy = [
            "multi-user.target"
          ];
        };
      };
    };
}
