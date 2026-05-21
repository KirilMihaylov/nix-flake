{
  flake.nixosModules.documentation =
    {
      pkgs,
      ...
    }:
    {
      documentation = {
        dev.enable = true;

        doc.enable = true;

        enable = true;

        info.enable = true;

        man.enable = true;

        nixos = {
          checkRedirects = true;

          enable = true;

          includeAllModules = true;

          options.warningsAreErrors = true;
        };
      };

      environment.systemPackages = with pkgs; [
        man-pages
        man-pages-posix
      ];
    };
}
