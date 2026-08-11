{
  flake.nixosModules'.base =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) kernel makeBinPath mkForce;
    in
    {
      config = {
        boot = {
          kernelParams = [
            "nohz_full=all"
            "nosoftlockup"
            "preempt=full"
            "skew_tick=1"
            "threadirqs"
            "usbcore.autosuspend=60"
            "workqueue.power_efficient=false"
          ];

          kernelPatches = with kernel; [
            {
              name = "turn-bpf-config-on";

              patch = null;

              structuredExtraConfig = {
                BPF = yes;

                BPF_JIT = yes;

                BPF_JIT_ALWAYS_ON = mkForce yes;

                BPF_JIT_DEFAULT_ON = yes;

                BPF_SYSCALL = yes;

                SCHED_CLASS_EXT = yes;
              };
            }
          ];
        };

        security.audit.enable = false;

        services = {
          bpftune.enable = true;

          scx-loader = {
            config = {
              default_mode = "Auto";

              default_sched = "scx_pandemonium";
            };

            enable = true;
          };
        };

        systemd.services.pci-latency = {
          description = "PCI latency timer setting.";

          enable = false;

          script = ''
            PATH=${
              makeBinPath [
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
