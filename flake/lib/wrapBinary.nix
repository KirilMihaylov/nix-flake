{
  flake.lib.wrapBinary =
    {
      lib,
      makeBinaryWrapper,
      symlinkJoin,
    }:
    pkg: flags:
    let
      inherit (pkg) meta outputs;
    in
    symlinkJoin {
      inherit meta outputs;

      inherit (pkg)
        name
        passthru
        pname
        version
        ;

      nativeBuildInputs = [
        makeBinaryWrapper
      ];

      paths = [
        pkg
      ];

      postBuild =
        let
          inherit (lib) escapeShellArg foldl';
        in
        ''
          wrapProgram "''${out}/bin/${meta.mainProgram}"${
            foldl' (accumulator: flag: accumulator + " --add-flag ${escapeShellArg flag}") "" flags
          }
        ''
        + (foldl' (
          accumulator: output:
          accumulator
          + (
            if output == "out" then
              ""
            else
              ''
                ln -s ${escapeShellArg pkg.${output}} "''${${output}}"
              ''
          )
        ) "" outputs);
    };
}
