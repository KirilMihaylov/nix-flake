{
  self,
  ...
}:
{
  flake.nixosModules.graphics-amd =
    {
      pkgs,
      ...
    }:
    let
      inherit (pkgs) lact;
    in
    {
      imports = with self.nixosModules; [
        graphics-base
      ];

      environment.systemPackages = [
        lact
      ];

      hardware.amdgpu = {
        initrd.enable = true;

        overdrive.enable = true;
      };
    };
}
