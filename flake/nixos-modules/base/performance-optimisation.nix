{
  flake.nixosModules'.base =
    {
      lib,
      ...
    }:
    let
      inherit (lib) kernel mkForce;
    in
    {
      boot = {
        kernel.sysctl."vm.max_map_count" = 2147483647;

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
            default_mode = "LowLatency";

            default_sched = "scx_lavd";
          };

          enable = true;
        };
      };
    };
}
