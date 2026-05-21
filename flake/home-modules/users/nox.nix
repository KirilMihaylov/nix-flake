{
  flake.homeModules.user-nox =
    {
      pkgs,
      ...
    }:
    {
      home.packages =
        let
          inherit (pkgs.packages) git' jujutsu' jujutsu-config;
        in
        [
          (git'.override {
            config-values = {
              "user.email" = "80464733+KirilMihaylov@users.noreply.github.com";

              "user.name" = "Kiril Mihaylov";
            };
          })
          (jujutsu'.override {
            config-file = jujutsu-config.override {
              extraConfig.user = {
                name = "Kiril Mihaylov";

                email = "80464733+KirilMihaylov@users.noreply.github.com";
              };
            };
          })
        ];
    };
}
