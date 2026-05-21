{
  flake.nixosModules.polkit =
    {
      pkgs,
      ...
    }:
    {
      security.polkit.enable = true;

      systemd.user.services.polkit-gnome = {
        after = [
          "graphical-session.target"
        ];

        description = "GNOME PolicyKit Agent";

        partOf = [
          "graphical-session.target"
        ];

        serviceConfig.ExecStart = pkgs.polkit_gnome + /libexec/polkit-gnome-authentication-agent-1;

        wantedBy = [
          "graphical-session.target"
        ];
      };
    };
}
