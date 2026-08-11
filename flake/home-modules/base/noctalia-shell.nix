{
  inputs,
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
      inherit (lib)
        fromJSON
        mkMerge
        pipe
        readFile
        ;
    in
    {
      imports = [
        inputs.noctalia-shell.homeModules.default
      ];

      programs.noctalia-shell = {
        enable = true;

        package = pkgs.packages.noctalia-shell;

        settings = mkMerge [
          (pipe ../../../files/config/noctalia-shell.json [
            readFile
            fromJSON
          ])
          {
            general.avatarImage = "${config.home.homeDirectory}/.face";

            wallpaper.directory = "${config.home.homeDirectory}/Pictures/Wallpapers";
          }
        ];
      };
    };
}
