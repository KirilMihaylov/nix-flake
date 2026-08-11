{
  self,
  ...
}:
{
  git =
    {
      config-values ? { },
      lib,
      makeBinaryWrapper,
      pkgs,
      symlinkJoin,
    }:
    let
      inherit (lib) attrNames foldl';
    in
    self.lib.wrapBinary
      {
        inherit lib makeBinaryWrapper symlinkJoin;
      }
      pkgs.git
      (
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
