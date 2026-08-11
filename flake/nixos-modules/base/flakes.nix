{
  flake.nixosModules'.base =
    {
      inputs,
      lib,
      pkgs,
      self,
      ...
    }:
    {
      nix =
        let
          inherit (lib)
            concat
            mapAttrs
            mkMerge
            pipe
            toJSON
            toList
            ;
        in
        {
          extraOptions =
            pipe
              {
                from = {
                  id = "nixpkgs-flake";

                  type = "indirect";
                };

                to = {
                  owner = "NixOS";

                  ref = "nixpkgs-unstable";

                  repo = "nixpkgs";

                  type = "github";
                };
              }
              [
                toList
                (flakes: {
                  inherit flakes;

                  version = 2;
                })
                toJSON
                (pkgs.writeText "flake-registry.json")
                (flake-registry: ''
                  flake-registry = ${flake-registry}

                  keep-derivations = true
                '')
              ];

          registry = pipe "self" [
            toList
            (removeAttrs inputs)
            (mapAttrs (
              _: flake: {
                inherit flake;
              }
            ))
            toList
            (concat [
              {
                system = {
                  flake = self;
                };
              }
            ])
            mkMerge
          ];

          settings.experimental-features = [
            "flakes"
            "nix-command"
          ];
        };
    };
}
