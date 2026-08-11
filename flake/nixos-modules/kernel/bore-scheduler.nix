{
  inputs,
  ...
}:
{
  flake.nixosModules'.kernel-bore-scheduler = {
    boot = {
      kernel.sysctl."kernel.sched_bore" = 1;

      kernelPatches =
        let
          inherit (inputs) bore-scheduler;
        in
        [
          {
            name = "bore-scheduler";

            patch = bore-scheduler + "/patches/testing/0001-linux7.2-rc1-bore-6.8.0.patch";
          }
          {
            name = "sched-ext-coexistence-fix";

            patch = bore-scheduler + /patches/additions/0002-sched-ext-coexistence-fix.patch;
          }
        ];
    };
  };
}
