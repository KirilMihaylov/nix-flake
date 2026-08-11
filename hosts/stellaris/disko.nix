{
  disko.devices.disk.nvme = {
    content = {
      partitions = rec {
        ESP = {
          content = {
            format = "vfat";

            mountOptions = [
              "discard"
              "umask=0077"
            ];

            mountpoint = "/boot";

            type = "filesystem";
          };

          name = "ESP";

          priority = 1;

          size = "1G";

          type = "EF00";
        };

        OS = {
          content = {
            mountOptions = [
              "discard"
            ];

            mountpoint = "/fs";

            subvolumes = {
              "@".mountpoint = "/";

              "@home".mountpoint = "/home";

              "@nix" = {
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];

                mountpoint = "/nix";
              };

              "@root".mountpoint = "/root";

              "@var" = {
                mountOptions = [
                  "compress=zstd"
                ];

                mountpoint = "/var";
              };

              "@vaults" = {
                mountOptions = [
                  "nodev"
                  "nosuid"
                  "nosymfollow"
                ];

                mountpoint = "/vaults";
              };
            };

            type = "btrfs";
          };

          priority = SWAP.priority + 1;

          size = "100%";
        };

        SWAP = {
          content = {
            randomEncryption = true;

            type = "swap";
          };

          priority = ESP.priority + 1;

          size = "64G";
        };
      };

      type = "gpt";
    };

    device = "/dev/nvme0n1";

    type = "disk";
  };
}
