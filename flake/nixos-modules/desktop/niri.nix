{
  flake.nixosModules'.desktop =
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

          inherit (pkgs.packages) niri-config;

          etcPath = "niri/config.kdl";
        in
        {
          environment = {
            etc.${etcPath}.source = niri-config.override {
              inherit (host) terminal;

              inherit (programs.niri) extraConfig;
            };

            sessionVariables = {
              NIRI_CONFIG = "/etc/${etcPath}";

              WINEDEBUG = "-all";

              WLR_RENDERER = "vulkan";
            };
          };

          programs.niri.enable = true;

          services.displayManager.defaultSession = "niri";

          xdg.portal.extraPortals = with pkgs; [
            xdg-desktop-portal-gnome
            xdg-desktop-portal-gtk
          ];
        };

      options.programs.niri.extraConfig =
        let
          inherit (lib) mkOption types;
        in
        mkOption {
          default = "";

          description = "Extra configuration lines to be appended to the base configuration.";

          type = types.str;
        };
    };
}
