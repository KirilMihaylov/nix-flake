final: prev:
let
  inherit (prev.lib) extends flip foldl';
in
foldl' (flip extends) (_: prev) (import <nixos-system>).config.nixpkgs.overlays final
