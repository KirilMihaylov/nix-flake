{
  perSystem =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) foldl' getExe';

      inherit (pkgs) disko;

      pkg = name: {
        inherit (disko) meta;

        program = getExe' disko name;

        type = "app";
      };
    in
    {
      apps =
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
    };
}
