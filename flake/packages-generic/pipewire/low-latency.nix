{
  flake.packages-generic.pipewire-low-latency =
    {
      lib,
      writeTextDir,
    }:
    writeTextDir "share/pipewire/pipewire.conf.d/10-low-latency.conf" (
      lib.toJSON {
        "context.properties" = {
          "default.clock.max-quantum" = 256;

          "default.clock.min-quantum" = 32;

          "default.clock.quantum" = 128;

          "default.clock.rate" = 48000;
        };
      }
    );
}
