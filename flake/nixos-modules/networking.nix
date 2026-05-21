{
  flake.nixosModules.networking = {
    networking = {
      networkmanager = {
        dns = "systemd-resolved";

        enable = true;
      };
    };

    services.resolved.enable = true;
  };
}
