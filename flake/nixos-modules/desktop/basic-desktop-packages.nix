{
  flake.nixosModules.basic-desktop-packages =
    {
      pkgs,
      ...
    }:
    let
      inherit (pkgs.kdePackages) ark;
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

      xdg.mime.defaultApplicationsPackages = [
        ark
      ];
    };
}
