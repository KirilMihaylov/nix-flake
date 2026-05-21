{
  self,
  ...
}:
{
  flake.packages-generic = {
    ungoogled-chromium =
      {
        ungoogled-chromium,
      }:
      ungoogled-chromium.override {
        enableWideVine = true;
      };

    ungoogled-chromium' =
      {
        lib,
        makeBinaryWrapper,
        symlinkJoin,
        ungoogled-chromium,
      }:
      self.lib.wrapBinary
        {
          inherit lib makeBinaryWrapper symlinkJoin;
        }
        ungoogled-chromium
        [
          "--gtk-version=4"
          "--profile-directory=Default"
        ];
  };
}
