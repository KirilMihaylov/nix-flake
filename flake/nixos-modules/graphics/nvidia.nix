{
  self,
  ...
}:
{
  flake.nixosModules.graphics-nvidia =
    {
      pkgs,
      ...
    }:
    {
      imports = with self.nixosModules; [
        graphics-base
      ];

      hardware = {
        graphics.extraPackages = with pkgs; [
          nvidia-vaapi-driver
        ];

        nvidia = {
          branch = "latest";

          dynamicBoost.enable = true;

          nvidiaPersistenced = true;

          nvidiaSettings = false;

          open = true;

          powerManagement.enable = true;
        };
      };

      services.xserver.videoDrivers = [
        "nvidia"
      ];
    };
}
