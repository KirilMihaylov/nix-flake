{
  flake.nixosModules'.desktop =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (kdePackages) ark;

      inherit (lib) getName mkDefault mkMerge;

      inherit (pkgs) kdePackages nautilus;
    in
    {
      environment.systemPackages =
        with pkgs;
        [
          nautilus
          packages.fuzzel'
        ]
        ++ (with kdePackages; [
          ark
          kate
          kcalc
        ]);

      xdg.mime.defaultApplicationsPackages = mkMerge (
        map
          (package: {
            ${getName package} = {
              inherit package;

              order = mkDefault 50;
            };
          })
          [
            ark
            nautilus
          ]
      );
    };
}
