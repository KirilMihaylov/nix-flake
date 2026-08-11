{
  flake.nixosModules'.desktop =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib)
        getName
        mkDefault
        mkMerge
        pipe
        ;
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

      xdg.mime.defaultApplicationsPackages =
        with pkgs;
        pipe
          [
            kdePackages.ark
            nautilus
          ]
          [
            (map (package: {
              inherit package;

              order = mkDefault 50;
            }))
            (map (set: {
              ${getName set.package} = set;
            }))
            mkMerge
          ];
    };
}
