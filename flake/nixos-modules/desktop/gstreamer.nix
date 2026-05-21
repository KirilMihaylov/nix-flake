{
  flake.nixosModules.gstreamer =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs.gst_all_1; [
        gst-libav
        gst-plugins-bad
        gst-plugins-base
        gst-plugins-good
        gst-plugins-rs
        gst-plugins-ugly
        gst-vaapi
        gstreamer
      ];
    };
}
