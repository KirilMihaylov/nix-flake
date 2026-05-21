{
  flake.nixosModules.graphics-base =
    {
      pkgs,
      ...
    }:
    {
      hardware.graphics = {
        enable = true;

        enable32Bit = true;

        extraPackages = with pkgs; [
          libGL
          libGLU
          libva-vdpau-driver
          libvdpau
          libvdpau-va-gl
          vdpauinfo
        ];
      };

      services.lact.enable = true;
    };
}
