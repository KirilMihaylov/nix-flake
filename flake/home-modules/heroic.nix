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
          inherit (lib) mapAttrs mkMerge;

          inherit (packages) dxvk vkd3d-proton;

          inherit (pkgs) packages proton-ge-bin wineWow64Packages;

          inherit (wineWow64Packages) full waylandFull;

          prefix = "heroic/tools/";
        in
        mkMerge [
          (mapAttrs
            (_: source: {
              inherit source;
            })
            {
              "${prefix}dxvk/dxvk-${dxvk.version}" = dxvk.bin;

              "${prefix}proton/GE-Proton (Nix)" = proton-ge-bin.steamcompattool;

              "${prefix}vkd3d/vkd3d-proton-${vkd3d-proton.version}" = vkd3d-proton.bin;

              "${prefix}wine/Wine (Nix)" = full;

              "${prefix}wine/Wine Wayland (Nix)" = waylandFull;
            }
          )
          (mapAttrs
            (_: text: {
              inherit text;
            })
            {
              "${prefix}dxvk/latest_dxvk" = "dxvk-${dxvk.version}";

              "${prefix}vkd3d/latest_vkd3d" = "vkd3d-proton-${vkd3d-proton.version}";
            }
          )
        ];
    };
}
