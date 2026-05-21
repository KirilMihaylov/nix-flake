{
  flake.nixosModules.keyboard-layouts.services.xserver.xkb = {
    layout = "us,bg";

    options = "grp:win_space_toggle";

    variant = "altgr-intl,bas_phonetic";
  };
}
