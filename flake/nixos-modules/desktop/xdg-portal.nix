{
  flake.nixosModules.xdg-portal.xdg.portal = {
    enable = true;

    wlr.enable = true;

    xdgOpenUsePortal = true;
  };
}
