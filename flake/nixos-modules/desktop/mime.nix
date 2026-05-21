{
  flake.nixosModules.mime =
    {
      config,
      lib,
      ...
    }:
    let
      inherit (lib)
        filesystem
        filter
        flatten
        hasSuffix
        head
        isList
        isString
        last
        length
        map
        mkOption
        readDir
        readFile
        readFileType
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
      config.xdg.mime.defaultApplications = zipAttrs (
        flatten (map packageAssociations config.xdg.mime.defaultApplicationsPackages)
      );

      options.xdg.mime.defaultApplicationsPackages = mkOption {
        default = [ ];

        description = "Sets the default applications associations for the listed packages.";

        type =
          let
            inherit (types) listOf package;
          in
          listOf package;
      };
    };
}
