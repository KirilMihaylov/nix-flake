{
  flake.nixosModules'.base =
    {
      config,
      lib,
      ...
    }:
    let
      inherit (lib)
        any
        attrNames
        concat
        elem
        flip
        getName
        id
        mkOption
        pipe
        toList
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
      config.nixpkgs.config.allowUnfreePredicate =
        let
          inherit (config.host.allowUnfree) byName predicates;
        in
        flip pipe [
          (flip id)
          (pipe
            [
              getName
              (flip elem byName)
            ]
            [
              (flip pipe)
              toList
              (concat predicates)
              (flip any)
            ]
          )
        ];

      options.host =
        let
          inherit (types)
            bool
            enum
            functionTo
            listOf
            nonEmptyStr
            ;
        in
        {
          allowUnfree = {
            byName = mkOption {
              description = "Specifies the names of what unfree packages can be used in conjunction with the ones from the unfree predicates.";

              type = listOf nonEmptyStr;
            };

            predicates = mkOption {
              description = "Specifies predicates which evaluates what unfree packages can be used.";

              type = listOf (functionTo bool);
            };
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
