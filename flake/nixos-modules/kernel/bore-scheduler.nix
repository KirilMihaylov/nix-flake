{
  inputs,
  ...
}:
{
  flake.nixosModules.kernel-bore-scheduler =
    {
      config,
      lib,
      ...
    }:
    {
      boot = {
        kernel.sysctl."kernel.sched_bore" = 1;

        kernelPatches =
          let
            inherit (inputs) bore-scheduler;

            inherit (lib)
              attrNames
              hasSuffix
              head
              length
              readDir
              versions
              ;
          in
          [
            {
              name = "bore-scheduler";

              patch =
                let
                  dir =
                    bore-scheduler + "/patches/stable/linux-${versions.majorMinor config.host.kernel.version}-bore";

                  contents = readDir dir;

                  fileNames = attrNames contents;

                  file =
                    assert length fileNames == 1;
                    head fileNames;
                in
                assert hasSuffix ".patch" file;
                assert contents.${file} == "regular";
                dir + "/${file}";
            }
            {
              name = "sched-ext-coexistence-fix";

              patch = bore-scheduler + /patches/additions/0002-sched-ext-coexistence-fix.patch;
            }
          ];
      };
    };
}
