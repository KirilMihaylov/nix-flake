{
  flake.nixosModules'.base =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (kernel) yes;

      inherit (lib) kernel mkForce;
    in
    {
      boot = {
        kernel.sysctl = {
          "kernel.split_lock_mitigate" = 0;

          "vm.compaction_proactiveness" = 0;

          "vm.max_map_count" = 2147483642;

          "vm.min_free_kbytes" = 1048576;

          "vm.page_lock_unfairness" = 1;

          "vm.swappiness" = 10;

          "vm.watermark_boost_factor" = 1;

          "vm.watermark_scale_factor" = 500;

          "vm.zone_reclaim_mode" = 0;
        };

        kernelParams = [
          "split_lock_detect=off"
        ];

        kernelPatches = [
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

      environment.sessionVariables.LD_BIND_NOW = "1";

      security.audit.enable = false;

      services = {
        scx-loader = {
          config = {
            default_mode = "LowLatency";

            default_sched = "scx_pandemonium";
          };

          enable = true;
        };

        tuned.recommend.latency-performance = { };
      };

      systemd.services.set-pci-latency = {
        enable = true;

        enableDefaultPath = false;

        path = with pkgs; [
          pciutils
        ];

        reloadIfChanged = true;

        script = ''
          setpci -v -s '*:*' latency_timer=20

          setpci -v -s '0:0' latency_timer=0

          setpci -v -d "*:*:04xx" latency_timer=80
        '';

        requiredBy = [
          "multi-user.target"
        ];
      };
    };
}
