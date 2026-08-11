{
  self,
  ...
}:
{
  ungoogled-chromium =
    {
      lib,
      makeBinaryWrapper,
      pkgs,
      symlinkJoin,
    }:
    self.lib.wrapBinary
      {
        inherit lib makeBinaryWrapper symlinkJoin;
      }
      (pkgs.ungoogled-chromium.override {
        enableWideVine = true;
      })
      [
        "--gtk-version=4"
        "--profile-directory=Default"
      ];
}
