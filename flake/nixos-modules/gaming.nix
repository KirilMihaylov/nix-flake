{
  self,
  ...
}:
{
  flake.nixosModules'.gaming =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) mkOption types;

      inherit (types) listOf passwdEntry str;
    in
    {
      imports = with self.nixosModules; [
        gamemode
        heroic
        # irori
        lutris
        steam
      ];

      config.environment = {
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

      options.host.gaming.users = mkOption {
        description = "Represents a list of users who should be given permissions to use Feral's GameMode capabilities.";

        type = listOf (passwdEntry str);
      };
    };
}
