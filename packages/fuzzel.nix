{
  self,
  ...
}:
{
  fuzzel =
    {
      fuzzel-config,
      lib,
      makeBinaryWrapper,
      pkgs,
      symlinkJoin,
    }:
    self.lib.wrapBinary
      {
        inherit lib makeBinaryWrapper symlinkJoin;
      }
      pkgs.fuzzel
      [
        "--config"
        fuzzel-config
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
}
