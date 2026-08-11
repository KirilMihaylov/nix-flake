{
  flake.nixosModules'.base.boot.initrd.kernelModules = [
    "hid-generic"
    "usbhid"
  ];
}
