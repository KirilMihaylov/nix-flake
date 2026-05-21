{
  flake.nixosModules.internationalisation = {
    i18n = {
      defaultLocale = "en_US.UTF-8";

      extraLocaleSettings = {
        LC_ADDRESS = "C.UTF-8";

        LC_IDENTIFICATION = "C.UTF-8";

        LC_MEASUREMENT = "C.UTF-8";

        LC_MONETARY = "C.UTF-8";

        LC_NAME = "C.UTF-8";

        LC_NUMERIC = "C.UTF-8";

        LC_PAPER = "C.UTF-8";

        LC_TELEPHONE = "C.UTF-8";

        LC_TIME = "C.UTF-8";
      };
    };

    time.timeZone = "Europe/Sofia";
  };
}
