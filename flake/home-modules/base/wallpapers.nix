{
  self,
  ...
}:
{
  flake.homeModules.base.home.file."Pictures/Wallpapers".source = self + "/files/wallpapers";
}
