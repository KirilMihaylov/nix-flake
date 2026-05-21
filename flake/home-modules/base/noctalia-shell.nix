{
  inputs,
  self,
  ...
}:
{
  flake.homeModules.noctalia-shell =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) fromJSON mkMerge readFile;
    in
    {
      imports = [
        inputs.noctalia-shell.homeModules.default
      ];

      programs.noctalia-shell = {
        enable = true;

        package = pkgs.packages.noctalia-shell;

        settings = mkMerge [
          (fromJSON (readFile (self + /files/config/noctalia-shell.json)))
          {
            general.avatarImage = "${config.home.homeDirectory}/.face";

            wallpaper.directory = "${config.home.homeDirectory}/Pictures/Wallpapers";
          }
        ];
      };
    };
}
