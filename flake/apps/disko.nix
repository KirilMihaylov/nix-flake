{
  lib,
  ...
}:
let
  inherit (lib) foldl' getExe';
in
{
  flake.apps' =
    let
      pkg =
        name:
        {
          disko,
          ...
        }:
        {
          inherit (disko) meta;

          program = getExe' disko name;

          type = "app";
        };
    in
    foldl'
      (
        accumulator: name:
        assert !(accumulator ? ${name});
        accumulator
        // {
          ${name} = pkg name;
        }
      )
      { }
      [
        "disko"
        "disko-install"
      ];
}
