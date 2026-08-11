let
  inherit (builtins) fromJSON readFile;

  flake =
    lib.pipe
      {
        inherit src;
      }
      [
        (import flake-compat-src)
        (set: set.defaultNix)
      ];

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

  src = import ./tracked-source.nix lib;
in
flake.nixosConfigurations
