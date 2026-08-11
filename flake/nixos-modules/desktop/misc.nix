{
  flake.nixosModules'.desktop = {
    programs.gnome-disks.enable = true;

    services = {
      displayManager.gdm.enable = true;

      gvfs.enable = true;

      libinput.enable = true;

      xserver.enable = false;
    };
  };
}
