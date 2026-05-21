{
  self,
  ...
}:
{
  flake.nixosModules.gaming =
    {
      pkgs,
      ...
    }:
    {
      imports = with self.nixosModules; [
        heroic
        gamemode
        # kernel-bore-scheduler
        steam
      ];

      config = {
        environment = {
          sessionVariables = {
            SDL_AUDIO_DRIVER = "pulse";

            SDL_VIDEO_DRIVER = "wayland,x11";
          };

          systemPackages = with pkgs; [
            mangohud
            mono
            protonplus
            protontricks
            winetricks
            wineWow64Packages.full
          ];
        };
      };
    };
}
