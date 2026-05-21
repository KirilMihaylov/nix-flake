{
  flake.nixosModules.nix-path =
    {
      host,
      inputs,
      lib,
      self,
      ...
    }:
    let
      inherit (lib)
        attrNames
        escapeShellArg
        foldl'
        toFile
        ;

      inputsDir = "inputs";

      nixPathDir = "nix-path";

      specialDir = "special";

      systemFlakeExportName = "system-flake";
    in
    {
      nix.nixPath =
        let
          pathPrefix = "/run/current-system/${nixPathDir}";

          specialPath = "${pathPrefix}/${specialDir}";
        in
        [
          "host=${specialPath}/host"
          "nixos-system=${specialPath}/${systemFlakeExportName}/system.nix"
          "nixpkgs-overlays=${specialPath}/${systemFlakeExportName}/overlays-compat"
          "system-flake=${specialPath}/${systemFlakeExportName}"
          "${pathPrefix}/${inputsDir}"
        ];

      system.systemBuilderCommands =
        foldl'
          (
            accumulator: name:
            accumulator
            + ''

              "ln" "-s" ${escapeShellArg inputs.${name}} "''${path}/"${escapeShellArg name}
            ''
          )
          ''
            (
              path="''${out}/"${escapeShellArg nixPathDir}

              "mkdir" "''${path}"

              (
                path="''${path}/"${escapeShellArg specialDir}

                "mkdir" "''${path}"

                "ln" "-s" ${escapeShellArg (toFile "host" host)} "''${path}/host"

                "ln" "-s" ${escapeShellArg self} "''${path}/"${escapeShellArg systemFlakeExportName}
              )

              (
                path="''${path}/"${escapeShellArg inputsDir}

                "mkdir" "''${path}"
          ''
          (attrNames inputs)
        + ''
            )
          )
        '';
    };
}
