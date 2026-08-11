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
        flip
        hasSuffix
        head
        isList
        isString
        last
        length
        mkDefault
        mkOption
        pipe
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
        flip pipe [
          listDesktopPaths
          (map (
            path:
            let
              matched = pipe path [
                readFile
                (split "\nMimeType=([^\n]+)")
                (filter isList)
                flatten
              ];
            in
            if length matched == 0 then
              [ ]
            else
              pipe matched [
                head
                (split ";")
                (filter isString)
                (filter (mimeType: mimeType != ""))
                (map (mimeType: {
                  ${mimeType} = pipe path [
                    (split "/")
                    last
                  ];
                }))
              ]
          ))
        ];
    in
    {
      config.xdg.mime =
        let
          inherit (config.programs.firefox) enable package;
        in
        {
          addedAssociations = pipe config.xdg.mime.addedAssociationsPackages [
            (map packageAssociations)
            flatten
            zipAttrs
          ];

          addedAssociationsPackages = [
            package
          ];

          defaultApplications = pipe config.xdg.mime.defaultApplicationsPackages [
            attrValues
            (filter (set: set.enable))
            (sortOn (set: set.order))
            (map (set: set.package))
            (map packageAssociations)
            flatten
            zipAttrs
          ];

          defaultApplicationsPackages.programs-firefox = {
            inherit package;

            enable = mkDefault enable;

            order = mkDefault 95;
          };

          removedAssociations = pipe config.xdg.mime.removedAssociationsPackages [
            (map packageAssociations)
            flatten
            zipAttrs
          ];
        };

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

            type =
              pipe
                {
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
                }
                [
                  (options: {
                    inherit options;
                  })
                  submodule
                  attrsOf
                ];
          };

          removedAssociationsPackages = mkOption {
            default = [ ];

            description = "Removes associations for the listed packages.";

            type = listOf package;
          };
        };
    };
}
