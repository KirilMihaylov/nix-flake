let
  inherit (builtins) fromJSON readFile;

  inherit (lib.fileset) gitTracked toSource;

  fileset = gitTracked root;

  flake-compat-src = flake-src "flake-compat";

  flake-src =
    flake:
    let
      inherit (lock.nodes.${node}) locked;

      node = lock.nodes.root.inputs.${flake};
    in
    fetchTree locked;

  lib = import lib-src;

  lib-src = nixpkgs-src + "/lib";

  lock = fromJSON lock-content;

  lock-content = readFile ./flake.lock;

  nixpkgs-src = flake-src "nixpkgs";

  root = ./.;

  src = toSource {
    inherit fileset root;
  };
in
(import flake-compat-src {
  inherit src;
}).defaultNix
