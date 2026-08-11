{
  flake.nixosModules'.desktop =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) getName mkDefault mkMerge;
    in
    {
      environment.systemPackages =
        with pkgs;
        with packages;
        with kdePackages;
        [
          ark
          fuzzel
          kate
          kcalc
          nautilus
        ];

      programs.gnome-disks.enable = true;

      xdg.mime = {
        addedAssociationsPackages =
          with pkgs;
          with kdePackages;
          [
            ark
            kate
            nautilus
          ];

        defaultApplicationsPackages = mkMerge (
          map
            (package: {
              ${getName package} = {
                inherit package;

                order = mkDefault 50;
              };
            })
            (
              with pkgs;
              with kdePackages;
              [
                ark
                nautilus
              ]
            )
        );
      };
    };
}
