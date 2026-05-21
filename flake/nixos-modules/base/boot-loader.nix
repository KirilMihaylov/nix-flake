{
  flake.nixosModules.boot-loader.boot.loader = {
    grub.enable = false;

    efi.canTouchEfiVariables = true;

    systemd-boot = {
      consoleMode = "max";

      editor = false;

      enable = true;

      memtest86.enable = true;
    };
  };
}
