{
  self,
  ...
}:
{
  flake.nixosModules.graphics-intel =
    {
      pkgs,
      ...
    }:
    {
      imports = with self.nixosModules; [
        graphics-base
      ];

      hardware.graphics.extraPackages = with pkgs; [
        intel-media-driver
        vpl-gpu-rt
      ];
    };
}
