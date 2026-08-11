{
  flake.nixosModules'.base =
    {
      config,
      lib,
      ...
    }:
    let
      inherit (lib)
        all
        any
        attrNames
        elem
        flip
        mkOption
        pipe
        types
        ;

      arch-families = rec {
        i686 = {
          cpu-manufacturers = [
            "amd"
            "intel"
          ];

          hardware-acceleration-components = [
            "cuda"
            "rocm"
          ];
        };

        x86_64 = i686;
      };
    in
    {
      config = {
        assertions =
          let
            inherit (config.host) hardware;

            inherit (cpu) arch manufacturer;

            inherit (hardware) cpu hardware-acceleration;
          in
          [
            {
              assertion = elem manufacturer arch-families.${arch}.cpu-manufacturers;
            }
            {
              assertion = all (flip elem
                arch-families.${arch}.hardware-acceleration-components
              ) hardware-acceleration;
            }
          ];

        nixpkgs.config.allowUnfreePredicate =
          pkg: any (predicate: predicate pkg) config.host.allowUnfree.predicates;
      };

      options.host =
        let
          inherit (types)
            bool
            enum
            functionTo
            listOf
            ;
        in
        {
          allowUnfree.predicates = mkOption {
            description = "Specifies predicates which evaluates what unfree packages can be used.";

            type = listOf (functionTo bool);
          };

          hardware = {
            cpu = {
              arch = mkOption {
                description = "The host's CPU architecture.";

                type = pipe arch-families [
                  attrNames
                  enum
                ];
              };

              manufacturer = mkOption {
                description = "The host's CPU manufacturer.";

                type = enum arch-families.${config.host.hardware.cpu.arch}.cpu-manufacturers;
              };
            };

            hardware-acceleration = mkOption {
              default = [ ];

              description = "Specifies which hardware acceleration components are available.";

              type = pipe arch-families.${config.host.hardware.cpu.arch}.hardware-acceleration-components [
                enum
                listOf
              ];
            };
          };
        };
    };
}
