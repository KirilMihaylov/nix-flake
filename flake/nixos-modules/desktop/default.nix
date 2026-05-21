{
  self,
  ...
}:
{
  flake.nixosModules.desktop =
    {
      config,
      ...
    }:
    {
      imports = with self.nixosModules; [
        audio
        basic-desktop-packages
        desktop-console-utils
        electron-wayland
        fonts
        gstreamer
        keyboard-layouts
        mime
        niri
        polkit
        secret-service
        terminal
        theme
        xdg-portal
      ];

      programs.nm-applet.enable = config.networking.networkmanager.enable;

      services = {
        displayManager.gdm.enable = true;

        gvfs.enable = true;

        libinput.enable = true;

        xserver.enable = false;
      };
    };
}
