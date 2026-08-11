let
  name = "flake-repl";
in
{
  flake.packages'.${name} =
    {
      lib,
      writeShellScriptBin,
    }:
    writeShellScriptBin name ''exec nix repl --expr ${lib.escapeShellArg ''
      (import <flake-compat> {
        src =
          with (import <nixpkgs/lib>).fileset;
          toSource rec {
            fileset = gitTracked root;

            root = ./.;
          };
      }).outputs''} "$@"'';
}
