{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/OS-Root";

      fsType = "btrfs";
    };

    "/boot" = {
      device = "/dev/disk/by-partlabel/ESP";

      fsType = "vfat";

      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    "/home" = {
      device = "/dev/disk/by-label/OS-Home";

      fsType = "btrfs";
    };
  };
}
