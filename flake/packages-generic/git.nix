{
  self,
  ...
}:
{
  flake.packages-generic.git' =
    {
      config-values ? { },
      git,
      lib,
      makeBinaryWrapper,
      symlinkJoin,
    }:
    self.lib.wrapBinary
      {
        inherit lib makeBinaryWrapper symlinkJoin;
      }
      git
      (
        let
          inherit (lib) attrNames foldl';
        in
        foldl' (
          accumulator: key:
          accumulator
          ++ [
            "-c"
            "${key}=${config-values.${key}}"
          ]
        ) [ ] (attrNames config-values)
      );
}
