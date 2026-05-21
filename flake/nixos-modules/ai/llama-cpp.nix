{
  flake.nixosModules =
    let
      base-name = "llama-cpp-";

      pkg =
        lib: config: pkgs:
        pkgs.${
          lib.findFirst (name: pkgs ? ${name}) "${base-name}vulkan" (
            map (
              hardware-acceleration: "${base-name}${hardware-acceleration}"
            ) config.host.hardware.hardware-acceleration
          )
        };
    in
    {
      llama-cpp-client =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        {
          environment.systemPackages = [
            (pkg lib config pkgs)
          ];
        };

      llama-cpp-server =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        {
          services.llama-cpp = {
            enable = true;

            package = pkg lib config pkgs;
          };
        };
    };
}
