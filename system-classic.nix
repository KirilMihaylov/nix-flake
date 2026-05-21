import ./system-generic.nix (
  let
    flake =
      let
        inherit (builtins) fetchTree fromJSON readFile;

        lock = fromJSON (readFile ./flake.lock);
      in
      flake: fetchTree lock.nodes.${lock.nodes.root.inputs.${flake}}.locked;
  in
  (import (flake "flake-compat") {
    src = (import ((flake "nixpkgs") + /lib)).sources.cleanSource ./.;
  }).defaultNix
)
