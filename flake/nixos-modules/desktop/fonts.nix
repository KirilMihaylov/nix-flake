{
  flake.nixosModules.fonts =
    {
      pkgs,
      ...
    }:
    {
      fonts = {
        enableDefaultPackages = true;

        fontconfig = {
          defaultFonts = {
            monospace = [
              "Fira Code"
            ];

            sansSerif = [
              "DejaVu Sans"
            ];

            serif = [
              "DejaVu Serif"
            ];
          };

          useEmbeddedBitmaps = true;
        };

        fontDir.enable = true;

        packages = with pkgs; [
          dejavu_fonts
          fira-code
          fira-code-symbols
          font-awesome
          liberation_ttf
          noto-fonts
          noto-fonts-lgc-plus
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
          noto-fonts-color-emoji
          noto-fonts-monochrome-emoji
          nerd-fonts.jetbrains-mono
        ];
      };
    };
}
