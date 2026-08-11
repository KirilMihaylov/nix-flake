{
  flake.nixosModules'.graphics-nvidia =
    {
      lib,
      ...
    }:
    {
      boot.initrd.kernelModules = [
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];

      environment.sessionVariables.__GLX_VENDOR_LIBRARY_NAME = "nvidia";

      hardware.nvidia =
        let
          inherit (lib) mkDefault;
        in
        {
          branch = mkDefault "latest";

          dynamicBoost.enable = mkDefault false;

          modesetting.enable = mkDefault true;

          nvidiaPersistenced = mkDefault true;

          nvidiaSettings = mkDefault true;

          open = mkDefault true;

          powerManagement.enable = mkDefault true;
        };

      services.xserver.videoDrivers = [
        "nvidia"
      ];
    };
}
