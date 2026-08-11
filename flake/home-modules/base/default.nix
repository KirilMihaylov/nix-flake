{
  self,
  ...
}:
{
  flake.homeModules.base = {
    imports = with self.homeModules; [
      wallpapers
    ];

    home.fileOverlapResolution = "error";
  };
}
