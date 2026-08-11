{
  self,
  ...
}:
{
  jujutsu =
    {
      jujutsu-config,
      lib,
      makeBinaryWrapper,
      pkgs,
      symlinkJoin,
    }:
    self.lib.wrapBinary
      {
        inherit lib makeBinaryWrapper symlinkJoin;
      }
      pkgs.jujutsu
      [
        "--config-file"
        jujutsu-config
      ];

  jujutsu-config =
    {
      extraConfig ? { },
      formats,
      lib,
    }:
    (formats.toml { }).generate "jujutsu-config.toml"
      (
        let
          inherit (lib) evalModules mkOption types;
        in
        evalModules {
          modules = [
            {
              config.config = {
                revsets.log = "::";

                ui.default-command = "log";
              };

              options.config = mkOption {
                type = types.attrs;
              };
            }
            {
              config.config = extraConfig;
            }
          ];
        }
      ).config.config;
}
