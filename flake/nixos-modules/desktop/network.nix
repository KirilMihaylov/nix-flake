{
  flake.nixosModules'.desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib)
        escapeShellArg
        mkIf
        pipe
        toList
        ;
    in
    mkIf config.networking.networkmanager.enable {
      environment.systemPackages =
        with pkgs;
        pipe
          {
            inherit (networkmanagerapplet)
              meta
              name
              outputs
              pname
              version
              ;

            paths = [
              networkmanagerapplet
            ];

            postBuild = ''
              ln -s ${escapeShellArg networkmanagerapplet.man} "''${man}"

              rm -f -R "''${out}/etc"
            '';
          }
          [
            symlinkJoin
            toList
          ];

      services.dbus.packages = with pkgs; [
        gcr_3
      ];
    };
}
