{
  flake.nixosModules'.power-management.services = {
    tlp.enable = false;

    tuned = {
      enable = true;

      ppdSettings.main.default = "performance";

      ppdSupport = true;
    };

    upower.enable = true;
  };
}
