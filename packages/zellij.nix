{
  zellij =
    {
      fontconfig,
      lib,
      libxkbcommon,
      pkgs,
      vulkan-loader,
      wayland,
    }:
    let
      inherit (lib) makeLibraryPath;
    in
    pkgs.zellij.override (
      {
        zellij-unwrapped,
        ...
      }:
      {
        zellij-unwrapped =
          (zellij-unwrapped.override {
            withWebServer = false;
          }).overrideAttrs
            (
              {
                postFixup ? "",
                ...
              }:
              {
                postFixup = postFixup + ''
                  patchelf "$out/bin/zellij" --add-rpath ${
                    makeLibraryPath [
                      fontconfig
                      libxkbcommon
                      vulkan-loader
                      wayland
                    ]
                  }
                '';
              }
            );
      }
    );
}
