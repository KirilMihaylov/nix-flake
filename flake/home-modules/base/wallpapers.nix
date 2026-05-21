{
  self,
  ...
}:
{
  flake.homeModules.wallpapers.home.file."Pictures/Wallpapers".source = self + /files/wallpapers;
}
