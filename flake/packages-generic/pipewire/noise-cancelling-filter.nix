{
  flake.packages-generic.pipewire-noise-cancelling-filter =
    {
      lib,
      lsp-plugins,
      rnnoise-plugin,
      writeTextDir,
    }:
    (writeTextDir "share/pipewire/pipewire.conf.d/50-noise-cancelling-filter.conf" (
      lib.toJSON {
        "context.modules" = [
          {
            args =
              let
                commonProps = {
                  "audio.channels" = 1;

                  "audio.position" = [
                    "MONO"
                  ];

                  "audio.rate" = 48000;
                };
              in
              {
                "capture.props" = commonProps // {
                  "node.description" = "Noise Cancelling Filter Input";

                  "node.name" = "capture.noise_cancelling_input";

                  "node.passive" = true;

                  "target.object" = "@DEFAULT_AUDIO_SOURCE@";
                };

                "filter.graph" = {
                  inputs = [
                    "noise-filter:Input"
                  ];

                  nodes = [
                    {
                      control = {
                        "Retroactive VAD Grace (ms)" = 20;

                        "VAD Grace Period (ms)" = 50;

                        "VAD Threshold (%)" = 50;
                      };

                      label = "noise_suppressor_mono";

                      name = "noise-filter";

                      plugin = "librnnoise_ladspa";

                      type = "ladspa";
                    }
                    {
                      control = {
                        # "Attack threshold" (G)
                        al = 0.05;

                        # "Attack time" (ms)
                        at = 3.5;

                        # "Dry/Wet balance" (%)
                        cdw = 100.0;

                        # "Compression mode"
                        cm = 0;

                        # "Ratio"
                        cr = 2.2;

                        # "Hold time" (ms)
                        hold = 0.0;

                        # "Knee" (G)
                        kn = 0.6;

                        # "Makeup gain" (G)
                        mk = 1.1;

                        # "Release threshold" (G)
                        rrl = 0.0;

                        # "Release time" (ms)
                        rt = 90.0;
                      };

                      name = "compressor";

                      plugin = "http://lsp-plug.in/plugins/lv2/compressor_mono";

                      type = "lv2";
                    }
                  ];

                  links = [
                    {
                      input = "compressor:in";

                      output = "noise-filter:Output";
                    }
                  ];

                  outputs = [
                    "compressor:out"
                  ];
                };

                "media.name" = "Noise Cancelling Filter";

                "playback.props" = commonProps // {
                  "media.class" = "Audio/Source";

                  "node.description" = "Noise Cancelling Filter Source";

                  "node.name" = "noise_cancelling_source";
                };
              };

            name = "libpipewire-module-filter-chain";
          }
        ];
      }
    )).overrideAttrs
      (
        base:
        assert !(base.passthru ? requiredLadspaPackages);
        assert !(base.passthru ? requiredLv2Packages);
        {
          passthru = {
            requiredLadspaPackages = [
              rnnoise-plugin.ladspa
            ];

            requiredLv2Packages = [
              lsp-plugins
            ];
          };
        }
      );
}
