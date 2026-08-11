{
  flake.nixosModules'.desktop.services = {
    gvfs.enable = true;

    libinput.enable = true;
  };
}
