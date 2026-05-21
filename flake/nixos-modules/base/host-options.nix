{
  flake.nixosModules.host-options =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib)
        all
        any
        attrNames
        elem
        foldl'
        mkOption
        types
        ;

      inherit (pkgs) linuxPackages linuxPackagesFor;

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

            inherit (cpu) arch;

            inherit (hardware) cpu;
          in
          [
            {
              assertion = elem cpu.manufacturer arch-families.${arch}.cpu-manufacturers;
            }
            {
              assertion = all (
                hardware-acceleration-component:
                elem hardware-acceleration-component arch-families.${arch}.hardware-acceleration-components
              ) (hardware.hardware-acceleration or [ ]);
            }
          ];

        boot.kernelPackages = linuxPackagesFor config.host.kernel;

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
            package
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

                type = enum (attrNames arch-families);
              };

              manufacturer = mkOption {
                description = "The host's CPU manufacturer.";

                type = enum (
                  foldl' (accumulator: arch: accumulator ++ arch-families.${arch}.cpu-manufacturers) [ ] (
                    attrNames arch-families
                  )
                );
              };
            };

            hardware-acceleration = mkOption {
              description = "Specifies which hardware acceleration components are available.";

              type = listOf (
                enum (
                  foldl' (
                    accumulator: arch: accumulator ++ arch-families.${arch}.hardware-acceleration-components
                  ) [ ] (attrNames arch-families)
                )
              );
            };
          };

          kernel = mkOption {
            default = linuxPackages.kernel;

            description = "Specifies which kernel set should be used.";

            type = package;
          };
        };
    };
}
