{
  flake.nixosModules'.base =
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
        join
        pipe
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

      system.systemBuilderCommands = ''
        (
          path="''${out}/"${escapeShellArg nixPathDir}

          "mkdir" "''${path}"

          (
            path="''${path}/"${escapeShellArg specialDir}

            "mkdir" "''${path}"

            "ln" "-s" ${
              pipe host [
                (toFile "host")
                escapeShellArg
              ]
            } "''${path}/host"

            "ln" "-s" ${escapeShellArg self} "''${path}/"${escapeShellArg systemFlakeExportName}
          )

          (
            path="''${path}/"${escapeShellArg inputsDir}

            "mkdir" "''${path}"
        ${
          pipe inputs [
            attrNames
            (map (
              name: "\n    \"ln\" \"-s\" ${escapeShellArg inputs.${name}} \"\${path}/\"${escapeShellArg name}\n"
            ))
            (join "")
          ]
        }  )
        )
      '';
    };
}
