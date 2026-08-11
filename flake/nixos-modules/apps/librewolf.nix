{
  flake.nixosModules'.librewolf =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.programs.firefox) enable finalPackage;

      inherit (lib) getName mkDefault mkIf;

      packages = [
        finalPackage
      ];
    in
    {
      programs.firefox = {
        enable = true;

        languagePacks = [
          "bg"
          "en-US"
        ];

        package = pkgs.librewolf;

        preferences = {
          "network.captive-portal-service.enabled" = false;

          "network.connectivity-service.enabled" = false;

          "browser.contentblocking.category" = "strict";

          "browser.download.deletePrivate" = true;

          "browser.download.deletePrivate.chosen" = true;

          "browser.region.network.url" = "";

          "browser.region.update.enabled" = false;

          "browser.translations.neverTranslateLanguages" = "bg";

          "browser.urlbar.placeholderName" = "DuckDuckGo No-AI";

          "browser.urlbar.placeholderName.private" = "DuckDuckGo No-AI";

          "extensions.formautofill.addresses.enabled" = false;

          "extensions.formautofill.creditCards.enabled" = false;

          "extensions.formautofill.creditCards.cvv.enabled" = false;

          "extensions.formautofill.creditCards.cvv.supported" = "off";

          "extensions.formautofill.passports.enabled" = false;

          "extensions.formautofill.passports.supported" = "off";

          "extensions.pictureinpicture.enable_picture_in_picture_overrides" = true;

          "identity.fxaccounts.enabled" = false;

          "librewolf.jit.enabled-by-default" = false;

          "media.autoplay.default" = 0;

          "media.eme.enabled" = true;

          "media.gmp-gmpopenh264.enabled" = true;

          "media.gmp-widevinecdm.enabled" = true;

          "media.videocontrols.picture-in-picture.video-toggle.first-seen-secs" = 0;

          "media.videocontrols.picture-in-picture.video-toggle.has-used" = true;

          "middlemouse.paste" = false;

          "network.dns.disableIPv6" = true;

          "network.IDN_show_punycode" = true;

          "network.trr.mode" = 2;

          "permissions.default.camera" = 2;

          "permissions.default.geo" = 2;

          "permissions.default.local-network" = 2;

          "permissions.default.loopback-network" = 2;

          "permissions.default.xr" = 2;

          "permissions.manager.defaultsUrl" = "";

          "pref.privacy.disable_button.view_passwords" = false;

          "privacy.resistFingerprinting.letterboxing" = false;

          "privacy.trackingprotection.allow_list.convenience.enabled" = false;

          "privacy.trackingprotection.enabled" = true;

          "privacy.trackingprotection.socialtracking.enabled" = true;

          "signon.autofillForms" = false;

          "signon.formlessCapture.enabled" = false;

          "signon.rememberSignons" = false;
        };

        preferencesStatus = "locked";
      };

      xdg.mime = mkIf enable {
        addedAssociationsPackages = packages;

        defaultApplicationsPackages.${getName finalPackage} = {
          order = mkDefault 85;

          package = finalPackage;
        };
      };
    };
}
