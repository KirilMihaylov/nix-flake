{
  flake.nixosModules'.base =
    {
      config,
      lib,
      ...
    }:
    let
      inherit (lib)
        attrValues
        filesystem
        filter
        flatten
        hasSuffix
        head
        isList
        isString
        last
        length
        mkDefault
        mkMerge
        mkOption
        readDir
        readFile
        readFileType
        sortOn
        split
        types
        zipAttrs
        ;

      packageAssociations =
        let
          listDesktopPaths =
            let
              applicationsDir = "applications";

              shareDir = "share";

              directoryType = "directory";
            in
            pkg:
            if readFileType pkg == directoryType && readDir pkg ? ${shareDir} then
              let
                sharePath = pkg + /${shareDir};
              in
              if readFileType sharePath == directoryType && readDir sharePath ? ${applicationsDir} then
                let
                  applicationsPath = pkg + /${shareDir};
                in
                if readFileType applicationsPath == directoryType then
                  filter (hasSuffix ".desktop") (filesystem.listFilesRecursive applicationsPath)
                else
                  [ ]
              else
                [ ]
            else
              [ ];
        in
        pkg:
        map (
          path:
          let
            matched = flatten (filter isList (split "\nMimeType=([^\n]+)" (readFile path)));
          in
          if length matched == 0 then
            [ ]
          else
            map (mimeType: {
              ${mimeType} = last (split "/" path);
            }) (filter (mimeType: mimeType != "") (filter isString (split ";" (head matched))))
        ) (listDesktopPaths pkg);
    in
    {
      config.xdg.mime = mkMerge [
        {
          addedAssociations = zipAttrs (
            flatten (map packageAssociations config.xdg.mime.addedAssociationsPackages)
          );

          defaultApplications = zipAttrs (
            flatten (
              map
                (
                  {
                    package,
                    ...
                  }:
                  packageAssociations package
                )
                (
                  sortOn
                    (
                      {
                        order,
                        ...
                      }:
                      order
                    )
                    (
                      filter (
                        {
                          enable,
                          ...
                        }:
                        enable
                      ) (attrValues config.xdg.mime.defaultApplicationsPackages)
                    )
                )
            )
          );

          removedAssociations = zipAttrs (
            flatten (map packageAssociations config.xdg.mime.removedAssociationsPackages)
          );
        }
        (
          let
            inherit (config.programs.firefox) enable package;
          in
          {
            addedAssociationsPackages = [
              package
            ];

            defaultApplicationsPackages.programs-firefox = {
              inherit package;

              enable = mkDefault enable;

              order = mkDefault 95;
            };
          }
        )
      ];

      options.xdg.mime =
        let
          inherit (types)
            attrsOf
            bool
            int
            listOf
            package
            submodule
            ;
        in
        {
          addedAssociationsPackages = mkOption {
            default = [ ];

            description = "Adds associations for the listed packages.";

            type = listOf package;
          };

          defaultApplicationsPackages = mkOption {
            default = [ ];

            description = "Lists the default applications associations to the listed packages in accending numerical order.";

            type = attrsOf (submodule {
              options = {
                enable = mkOption {
                  default = true;

                  description = "Specifies whether the associations should be added to the aggregate.";

                  type = bool;
                };

                order = mkOption {
                  default = 100;

                  description = ''
                    Specifies the numerical order for the associations to be added in to the aggregate.

                    Lower values go before ones with higher values, thus being used first.
                  '';

                  type = int;
                };

                package = mkOption {
                  description = "Specifies the package whose associations should be added to the aggregate.";

                  type = package;
                };
              };
            });
          };

          removedAssociationsPackages = mkOption {
            default = [ ];

            description = "Removes associations for the listed packages.";

            type = listOf package;
          };
        };
    };
}
