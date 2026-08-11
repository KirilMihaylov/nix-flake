{
  flake.nixosModules'.power-management.services = {
    tlp.enable = false;

    tuned = {
      enable = true;

      ppdSupport = false;
    };

    upower.enable = true;
  };
}
