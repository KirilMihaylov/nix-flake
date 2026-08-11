{
  flake.nixosModules'.base =
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

            inherit (lib)
              elem
              flip
              mkIf
              pipe
              ;
          in
          pipe
            [
              "x86"
              "x86_64"
            ]
            [
              (elem cpu.arch)
              (flip mkIf {
                ${cpu.manufacturer}.updateMicrocode = true;
              })
            ];

        enableAllFirmware = pkgs.config.allowUnfree;

        enableRedistributableFirmware = true;

        firmware = with pkgs; [
          linux-firmware
        ];
      };

      services.fwupd.enable = true;
    };
}
