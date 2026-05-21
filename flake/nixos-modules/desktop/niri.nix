{
  flake.nixosModules.niri =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config =
        let
          inherit (config) host programs;

          inherit (pkgs.packages) niri niri-config;

          etcPath = "niri/config.kdl";
        in
        {
          environment = {
            etc.${etcPath}.source = niri-config.override {
              inherit (host) terminal;

              inherit (programs.niri) extraConfig;
            };

            sessionVariables.NIRI_CONFIG = "/etc/${etcPath}";
          };

          programs.niri = {
            enable = true;

            package = niri;
          };

          services.displayManager.defaultSession = "niri";

          xdg.portal.extraPortals = with pkgs; [
            xdg-desktop-portal-gnome
            xdg-desktop-portal-gtk
          ];
        };

      options.programs.niri.extraConfig =
        let
          inherit (lib) mkOption types;

          inherit (types) str;
        in
        mkOption {
          default = "";

          description = "Extra configuration lines to be appended to the base configuration.";

          type = str;
        };
    };
}
