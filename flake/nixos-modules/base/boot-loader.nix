{
  flake.nixosModules'.base.boot.loader = {
    grub.enable = false;

    efi.canTouchEfiVariables = true;

    systemd-boot = {
      editor = false;

      enable = true;
    };
  };
}
