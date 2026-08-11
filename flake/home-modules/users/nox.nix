{
  flake.homeModules.user-nox =
    {
      lib,
      pkgs,
      ...
    }:
    {
      home.packages =
        let
          inherit (lib) pipe;

          inherit (pkgs.packages) git' jujutsu' jujutsu-config;
        in
        [
          (pipe
            {
              "user.email" = "80464733+KirilMihaylov@users.noreply.github.com";

              "user.name" = "Kiril Mihaylov";
            }
            [
              (config-values: {
                inherit config-values;
              })
              git'.override
            ]
          )
          (pipe
            {
              email = "80464733+KirilMihaylov@users.noreply.github.com";

              name = "Kiril Mihaylov";
            }
            [
              (user: {
                inherit user;
              })
              (extraConfig: {
                inherit extraConfig;
              })
              jujutsu-config.override
              (config-file: {
                inherit config-file;
              })
              jujutsu'.override
            ]
          )
        ];
    };
}
