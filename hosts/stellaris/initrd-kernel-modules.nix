{
  boot.initrd = {
    availableKernelModules = [
      "nvme"
      "thunderbolt"
      "usbhid"
      "xhci_pci"
    ];

    kernelModules = [
      "dm-snapshot"
    ];
  };
}
