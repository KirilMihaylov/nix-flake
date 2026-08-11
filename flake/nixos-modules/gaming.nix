{
  self,
  ...
}:
{
  flake.nixosModules'.gaming =
    {
      pkgs,
      ...
    }:
    {
      imports = with self.nixosModules; [
        gamemode
        heroic
        steam
      ];

      config = {
        environment = {
          sessionVariables = {
            PROTON_ENABLE_HDR = "1";

            PROTON_ENABLE_WAYLAND = "1";

            PROTON_PREFER_SDL = "1";

            SDL_AUDIO_DRIVER = "pulse";

            SDL_VIDEO_DRIVER = "wayland,x11";
          };

          systemPackages = with pkgs; [
            mangohud
            mono
            protonplus
            protontricks
            winetricks
            wineWow64Packages.waylandFull
          ];
        };
      };
    };
}
