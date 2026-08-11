final: prev:
let
  inherit (prev.lib)
    const
    extends
    flip
    foldl'
    ;
in
foldl' (flip extends) (const prev) (import <nixos-system>).config.nixpkgs.overlays final
