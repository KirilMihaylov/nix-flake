{
  flake.nixosModules'.base.boot.kernel.sysctl = {
    "kernel.panic" = 60;

    "kernel.softlockup_panic" = 1;

    "kernel.unprivileged_bpf_disabled" = 1;

    "kernel.watchdog" = 1;
  };
}
