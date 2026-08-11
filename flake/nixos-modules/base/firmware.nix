{
  flake.nixosModules'.base =
    {
      config,
      lib,
      options,
      pkgs,
      ...
    }:
    let
      inherit (config.host.hardware.cpu) manufacturer;

      inherit (lib) mkIf mkMerge;
    in
    mkMerge [
      {
        hardware = {
          cpu = mkIf (options.hardware.cpu ? ${manufacturer}.updateMicrocode) {
            ${manufacturer}.updateMicrocode = true;
          };

          enableAllFirmware = pkgs.config.allowUnfree;

          enableRedistributableFirmware = true;
        };

        services.fwupd.enable = true;
      }
    ];
}
