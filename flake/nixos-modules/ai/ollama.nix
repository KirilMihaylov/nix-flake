{
  flake.nixosModules =
    let
      base-name = "ollama-";

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
      ollama-client =
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

      ollama-server =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        {
          services.ollama = {
            enable = true;

            package = pkg lib config pkgs;
          };
        };
    };
}
