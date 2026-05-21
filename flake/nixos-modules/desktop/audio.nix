{
  flake.nixosModules.audio =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        pavucontrol
        qpwgraph
      ];

      security.rtkit.enable = true;

      services = {
        pipewire = {
          alsa.enable = true;

          alsa.support32Bit = true;

          configPackages = with pkgs.packages; [
            pipewire-low-latency
            pipewire-noise-cancelling-filter
          ];

          enable = true;

          jack.enable = true;

          pulse.enable = true;

          wireplumber.enable = true;
        };

        pulseaudio.enable = false;
      };
    };
}
