{
  flake.nixosModules' =
    let
      base =
        {
          pkgs,
          ...
        }:
        {
          environment.systemPackages = with pkgs; [
            nvtopPackages.full
          ];

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
    in
    {
      graphics-amd = base;

      graphics-intel = base;

      graphics-nvidia = base;
    };
}
