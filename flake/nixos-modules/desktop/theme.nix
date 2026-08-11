{
  flake.nixosModules'.desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (generators) toINI toKeyValue;

      inherit (lib)
        attrNames
        generators
        head
        length
        ;

      cursor-theme = "Vanilla-DMZ";

      dark-theme = true;

      font-field =
        type:
        let
          font-families = config.fonts.fontconfig.defaultFonts.${type};
        in
        if length font-families == 0 then
          _: { }
        else
          field: {
            ${field} = "${head font-families} ${toString font-size}";
          };

      font-field-serif = font-field "serif";

      font-size = 10;

      gtk-theme = "Adwaita" + (if dark-theme then "-dark" else "");

      icon-theme = "Papirus" + (if dark-theme then "-Dark" else "");

      kde-color-scheme = "Breeze" + (if dark-theme then "Dark" else "");
    in
    {
      environment = {
        etc =
          let
            gtk2 = {
              gtk-cursor-theme-name = cursor-theme;

              gtk-icon-theme-name = icon-theme;

              gtk-theme-name = gtk-theme;
            }
            // (font-field-serif "gtk-font-name");

            gtk3 = {
              Settings = gtk2 // {
                gtk-application-prefer-dark-theme = if dark-theme then 1 else 0;
              };
            };

            gtk3' = {
              text = toINI { } gtk3;
            };

            gtk4 = gtk3;

            gtk4' = {
              text = toINI { } gtk4;
            };

            kde' = {
              text = toINI { } {
                KDE = {
                  "LookAndFeelPackage[$i]" = "org.kde.breeze${if dark-theme then "dark" else ""}.desktop";

                  "SingleClick[$i]" = "false";

                  "widgetStyle[$i]" = "Breeze";
                };

                General = {
                  "ColorScheme[$i]" = kde-color-scheme;

                  "Name[$i]" = "Breeze" + (if dark-theme then " Dark" else "");
                };

                Icons."Theme[$i]" = icon-theme;

                UiSettings."ColorScheme[$i]" = kde-color-scheme;
              };
            };

            kwinrc' = {
              text = toINI { } {
                "org.kde.kdecoration2"."theme[$i]" = "Breeze";
              };
            };

            plasmarc' = {
              text = toINI { } {
                Theme."name[$i]" = "default";
              };
            };
          in
          {
            "gtk-2.0/gtkrc".text = toKeyValue { } gtk2;

            "gtk-3.0/settings.ini" = gtk3';

            "gtk-4.0/settings.ini" = gtk4';

            "xdg/kdeglobals" = kde';

            "xdg/kwinrc" = kwinrc';

            "xdg/plasmarc" = plasmarc';
          };

        extraInit =
          (
            let
              pkg = pkgs.gsettings-desktop-schemas;
            in
            ''
              if [ -d "${pkg}/share/gsettings-schemas/${pkg.name}" ]
              then
                export XDG_DATA_DIRS=''${XDG_DATA_DIRS-}''${XDG_DATA_DIRS:+:}${pkg}/share/gsettings-schemas/${pkg.name}
              fi
            ''
          )
          + (
            let
              inherit (pkgs.kdePackages) breeze;
            in
            ''
              if [ -d "${breeze}/share" ]
              then
                export XDG_DATA_DIRS=''${XDG_DATA_DIRS-}''${XDG_DATA_DIRS:+:}${breeze}/share
              fi
            ''
          );

        sessionVariables.NIX_GSETTINGS_OVERRIDES_DIR = "${
          let
            inherit (pkgs.nixos-artwork.wallpapers) simple-blue simple-dark-gray;
          in
          pkgs.gnome.nixos-gsettings-overrides.override {
            nixos-background-dark = simple-dark-gray;

            nixos-background-light = simple-blue;
          }
        }/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas";

        systemPackages =
          with pkgs;
          [
            gnome-themes-extra
            papirus-icon-theme
          ]
          ++ (with kdePackages; [
            breeze
            kconfig
            qqc2-desktop-style
          ]);
      };

      programs.dconf = {
        enable = true;

        profiles.user.databases =
          let
            path = "org/gnome/desktop/interface";
          in
          [
            rec {
              locks = map (key: "/${path}/${key}") (attrNames settings.${path});

              settings.${path} = {
                inherit
                  cursor-theme
                  gtk-theme
                  icon-theme
                  ;

                color-scheme = "prefer-" + (if dark-theme then "dark" else "light");
              }
              // (font-field "sansSerif" "font-name")
              // (font-field-serif "document-font-name")
              // (font-field "monospace" "monospace-font-name");
            }
          ];
      };

      qt = {
        enable = true;

        platformTheme = "kde";

        style = "breeze";
      };
    };
}
