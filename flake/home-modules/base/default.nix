{
  self,
  ...
}:
{
  flake.homeModules.base = {
    imports = with self.homeModules; [
      niri-screencast
      noctalia-shell
      wallpapers
    ];

    home.fileOverlapResolution = "error";
  };
}
