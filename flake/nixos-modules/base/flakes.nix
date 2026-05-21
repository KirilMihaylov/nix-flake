{
  flake.nixosModules.flakes =
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
            mapAttrs
            mkMerge
            removeAttrs
            toJSON
            ;
        in
        {
          extraOptions = ''
            flake-registry = ${
              pkgs.writeText "flake-registry.json" (toJSON {
                flakes = [
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
                ];

                version = 2;
              })
            }

            keep-derivations = true
          '';

          registry = mkMerge [
            {
              system = {
                flake = self;
              };
            }
            (mapAttrs
              (_: flake: {
                inherit flake;
              })
              (
                removeAttrs inputs [
                  "self"
                ]
              )
            )
          ];

          settings.experimental-features = [
            "flakes"
            "nix-command"
          ];
        };
    };
}
