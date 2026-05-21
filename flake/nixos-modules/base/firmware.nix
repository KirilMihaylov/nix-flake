{
  flake.nixosModules.firmware =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      hardware = {
        cpu =
          let
            inherit (config.host.hardware) cpu;

            inherit (lib) elem mkIf;
          in
          mkIf
            (elem cpu.arch [
              "x86"
              "x86_64"
            ])
            {
              ${cpu.manufacturer}.updateMicrocode = true;
            };

        enableAllFirmware = pkgs.config.allowUnfree;

        enableRedistributableFirmware = true;

        firmware = with pkgs; [
          linux-firmware
        ];
      };

      services.fwupd.enable = true;
    };
}
