{
  flake.homeModules.heroic =
    {
      lib,
      pkgs,
      self,
      ...
    }:
    {
      xdg.configFile =
        let
          inherit (pkgs)
            dwproton-bin
            proton-ge-bin
            stdenv
            wineWow64Packages
            ;

          inherit (wineWow64Packages) full waylandFull;

          mkFile = path: pkg: {
            "heroic/tools/${path} (Nix)".source = pkg;
          };
        in
        lib.mkMerge [
          (mkFile "proton/DWProton" dwproton-bin.steamcompattool)
          (mkFile "proton/Proton-GE" proton-ge-bin.steamcompattool)
          (mkFile "wine/Wine" full)
          (mkFile "wine/Wine Wayland" waylandFull)
        ];
    };
}
