{
  self,
  ...
}:
{
  flake.overlays.packages =
    final: prev:
    let
      inherit (final)
        callPackage
        kitty
        lib
        nautilus
        ;

      inherit (lib) attrNames mapAttrs;

      inherit (self) packages';

      base = prev.packages or { };

      new =
        mapAttrs
          (
            name:
            assert !(base ? ${name});
            callPackage packages'.${name}
          )
          {
            brave-origin' = { };

            enter-fhs = { };

            fuzzel' = {
              config-file = new.fuzzel-config;
            };

            fuzzel-config = { };

            git' = { };

            helix' = {
              config-file = new.helix-config;
            };

            helix-config = { };

            jujutsu' = {
              config-file = new.jujutsu-config;
            };

            jujutsu-config = { };

            niri-config =
              let
                inherit (new) fuzzel' niri-sticky-window;
              in
              {
                inherit niri-sticky-window;

                fileExplorer = nautilus;

                fuzzel = fuzzel';

                terminal = kitty;
              };

            niri-sticky-window = {
              inherit (new) rust-stable;
            };

            pipewire-low-latency = { };

            pipewire-noise-cancelling-filter = { };

            proton-ge-bin' = { };

            rust-analyzer = { };

            rust-analyzer-vscode = { };

            rust-beta = { };

            rust-nightly = { };

            rust-stable = { };

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
          assert (attrNames (removeAttrs new (attrNames packages'))) == [ ];
          assert [ ] == (attrNames (removeAttrs packages' (attrNames new)));
          new
        );
    };
}
