{
  flake.nixosModules.secret-service = {
    programs.seahorse.enable = true;

    security.pam.services = {
      gdm.enableGnomeKeyring = true;

      login.enableGnomeKeyring = true;

      sddm.enableGnomeKeyring = true;
    };

    services.gnome.gnome-keyring.enable = true;
  };
}
