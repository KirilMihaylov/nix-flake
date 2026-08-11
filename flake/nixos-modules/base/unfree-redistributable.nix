{
  flake.nixosModules'.base =
    {
      lib,
      ...
    }:
    {
      nixpkgs.config.allowlistedLicenses = with lib.licenses; [
        nvidiaCudaRedist
        unfreeRedistributable
      ];
    };
}
