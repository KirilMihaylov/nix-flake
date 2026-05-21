{
  flake.homeModules.niri-screencast.xdg.configFile."xdg-desktop-portal/niri-portals.conf".text = ''
    [preferred]
    default=gnome;gtk
    org.freedesktop.impl.portal.ScreenCast=wlr
  '';
}
