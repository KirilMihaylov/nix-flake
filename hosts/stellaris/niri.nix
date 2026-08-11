{
  programs.niri.extraConfig = ''
    output "eDP-1" {
      focus-at-startup

      mode "2560x1600"

      transform "normal"

      variable-refresh-rate
    }
  '';
}
