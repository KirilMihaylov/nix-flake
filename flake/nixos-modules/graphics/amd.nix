{
  flake.nixosModules'.graphics-amd =
    {
      pkgs,
      ...
    }:
    let
      inherit (pkgs) lact;
    in
    {
      environment.systemPackages = [
        lact
      ];

      hardware.amdgpu = {
        initrd.enable = true;

        overdrive.enable = true;
      };
    };
}
