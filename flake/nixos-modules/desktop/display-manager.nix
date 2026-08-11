{
  flake.nixosModules'.desktop.services = {
    displayManager.gdm.enable = true;

    xserver.enable = false;
  };
}
