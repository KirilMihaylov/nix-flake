{
  flake.nixosModules'.graphics-amd =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        lact
      ];

      hardware.amdgpu = {
        initrd.enable = true;

        overdrive.enable = true;
      };
    };
}
