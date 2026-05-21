{
  flake.nixosModules.librewolf =
    {
      pkgs,
      ...
    }:
    {
      programs.firefox = {
        autoConfig = ''
          lockPref("browser.contentblocking.category", "strict");

          lockPref("browser.uiCustomization.state", "{\"currentVersion\":23,\"dirtyAreaCache\":[\"nav-bar\",\"vertical-tabs\",\"toolbar-menubar\",\"TabsToolbar\",\"PersonalToolbar\"],\"newElementCount\":3,\"placements\":{\"PersonalToolbar\":[\"personal-bookmarks\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"vertical-spacer\",\"urlbar-container\",\"downloads-button\",\"fxa-toolbar-menu-button\",\"unified-extensions-button\",\"ublock0_raymondhill_net-browser-action\"],\"toolbar-menubar\":[\"menubar-items\"],\"unified-extensions-area\":[],\"vertical-tabs\":[],\"widget-overflow-fixed-list\":[]},\"seen\":[\"developer-button\",\"screenshot-button\",\"ublock0_raymondhill_net-browser-action\"]}");

          lockPref("datareporting.dau.cachedUsageProfileGroupID", "");

          lockPref("datareporting.dau.cachedUsageProfileID", "");

          defaultPref("middlemouse.paste", false);

          lockPref("network.captive-portal-service.enabled", false);

          lockPref("network.connectivity-service.enabled", false);

          defaultPref("network.dns.disableIPv6", true);

          lockPref("pref.privacy.disable_button.view_passwords", false);

          defaultPref("privacy.resistFingerprinting.letterboxing", false);

          lockPref("privacy.trackingprotection.enabled", true);

          lockPref("privacy.trackingprotection.socialtracking.enabled", true);

          defaultPref("privacy.trackingprotection.allow_list.convenience.enabled", false);

          lockPref("services.sync.engine.addresses.available", false);

          lockPref("toolkit.startup.last_success", 0);

          lockPref("toolkit.telemetry.cachedProfileGroupID", "");

          lockPref("toolkit.telemetry.reportingpolicy.firstRun", false);
        '';

        enable = true;

        languagePacks = [
          "bg"
          "en-US"
        ];

        package = pkgs.librewolf;

        preferencesStatus = "locked";
      };
    };
}
