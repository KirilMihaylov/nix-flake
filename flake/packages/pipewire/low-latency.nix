{
  flake.packages'.pipewire-low-latency =
    {
      lib,
      writeTextDir,
    }:
    let
      inherit (lib) pipe toJSON;
    in
    pipe
      {
        "default.clock.max-quantum" = 256;

        "default.clock.min-quantum" = 32;

        "default.clock.quantum" = 128;

        "default.clock.rate" = 48000;
      }
      [
        (properties: {
          "context.properties" = properties;
        })
        toJSON
        (writeTextDir "share/pipewire/pipewire.conf.d/10-low-latency.conf")
      ];
}
