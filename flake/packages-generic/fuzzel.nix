{
  self,
  ...
}:
{
  flake.packages-generic = {
    fuzzel' =
      {
        config-file,
        fuzzel,
        lib,
        makeBinaryWrapper,
        symlinkJoin,
      }:
      self.lib.wrapBinary
        {
          inherit lib makeBinaryWrapper symlinkJoin;
        }
        fuzzel
        [
          "--config"
          config-file
        ];

    fuzzel-config =
      {
        formats,
      }:
      (formats.ini { }).generate "fuzzel-config.ini" {
        main = {
          dpi-aware = "auto";

          fields = "name,exec,filename,generic";

          show-actions = "yes";

          use-bold = "yes";
        };
      };
  };
}
