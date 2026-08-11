{
  fileset,
  ...
}:
let
  inherit (fileset) gitTracked toSource;

  root = ./.;
in
toSource {
  inherit root;

  fileset = gitTracked root;
}
