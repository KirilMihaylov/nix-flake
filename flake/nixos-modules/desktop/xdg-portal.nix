{
  flake.nixosModules'.desktop.xdg.portal = {
    enable = true;

    xdgOpenUsePortal = true;
  };
}
