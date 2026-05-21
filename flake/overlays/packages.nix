{
  self,
  ...
}:
{
  flake.overlays.packages =
    final: prev:
    let
      inherit (final) callPackage kitty lib;

      inherit (lib) attrNames mapAttrs removeAttrs;

      inherit (self) packages-generic;

      base = prev.packages or { };

      new =
        mapAttrs
          (
            name:
            assert !(base ? ${name});
            callPackage packages-generic.${name}
          )
          {
            enter-fhs = { };

            fuzzel' = {
              config-file = new.fuzzel-config;
            };

            fuzzel-config = { };

            git' = { };

            helix = { };

            helix' = {
              inherit (new) helix;

              config-file = new.helix-config;
            };

            helix-config = { };

            jujutsu' = {
              config-file = new.jujutsu-config;
            };

            jujutsu-config = { };

            niri = { };

            niri-config =
              let
                inherit (new) fuzzel' noctalia-shell;
              in
              {
                inherit noctalia-shell;

                fuzzel = fuzzel';

                terminal = kitty;
              };

            nix-index = { };

            noctalia-shell = { };

            pipewire-low-latency = { };

            pipewire-noise-cancelling-filter = { };

            rust-analyzer = { };

            rust-analyzer-vscode = { };

            rust-beta = { };

            rust-nightly = { };

            rust-stable = { };

            turso = {
              rust = new.rust-stable;
            };

            ungoogled-chromium = { };

            ungoogled-chromium' = {
              inherit (new) ungoogled-chromium;
            };

            vscodium' = {
              inherit (new) rust-analyzer-vscode;
            };
          };
    in
    {
      packages =
        base
        // (
          assert (attrNames (removeAttrs new (attrNames packages-generic))) == [ ];
          assert [ ] == (attrNames (removeAttrs packages-generic (attrNames new)));
          new
        );
    };
}
