{
  flake.nixosModules' =
    let
      pkg =
        base: default: lib:
        let
          inherit (lib)
            attrByPath
            findFirst
            flip
            hasAttrByPath
            pipe
            toList
            ;
        in
        config: pkgs:
        pipe config.host.hardware.hardware-acceleration [
          (map (variant: base + variant))
          (map toList)
          (pipe pkgs [
            (flip hasAttrByPath)
            (flip findFirst [
              (base + default)
            ])
          ])
          (flip (flip attrByPath (throw "Default fallback package has to exist!")) pkgs)
        ];
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
            (pkg "llama-cpp-" "vulkan" lib config pkgs)
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

            package = pkg "llama-cpp-" "vulkan" lib config pkgs;
          };
        };

      ollama-client =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        {
          environment.systemPackages = [
            (pkg "ollama-" "vulkan" lib config pkgs)
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

            package = pkg "ollama-" "vulkan" lib config pkgs;
          };
        };
    };
}
