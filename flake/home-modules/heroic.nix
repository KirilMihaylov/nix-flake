{
  flake.homeModules.heroic =
    {
      lib,
      pkgs,
      ...
    }:
    {
      xdg.configFile =
        let
          inherit (lib) foldl' mkMerge pipe;

          inherit (pkgs) dwproton-bin proton-ge-bin wineWow64Packages;

          inherit (wineWow64Packages) full waylandFull;

          mkFile = path: pkg: {
            "heroic/tools/${path} (Nix)".source = pkg;
          };

          packages = [
            [
              "proton/DWProton"
              dwproton-bin.steamcompattool
            ]
            [
              "proton/Proton-GE"
              proton-ge-bin.steamcompattool
            ]
            [
              "wine/Wine"
              full
            ]
            [
              "wine/Wine Wayland"
              waylandFull
            ]
          ];
        in
        pipe packages [
          (map (foldl' (f: f) mkFile))
          mkMerge
        ];
    };
}
