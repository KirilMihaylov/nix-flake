{
  flake.nixosModules'.gpu-compute-intel =
    {
      pkgs,
      ...
    }:
    {
      hardware.graphics.extraPackages = with pkgs; [
        intel-ocl
      ];

      host.allowUnfree.byName = [
        "intel-ocl"
      ];
    };
}
