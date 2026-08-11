{
  flake.nixosModules'.gamescope.config.programs.gamescope = {
    args = [
      "--adaptive-sync"
      "--backend"
      "sdl"
      "--filter"
      "nis"
      "--fullscreen"
      "--hdr-enabled"
      "--mangoapp"
      "--nested-height"
      "1280"
      "--nested-refresh"
      "244"
      "--nested-width"
      "2048"
      "--output-height"
      "1600"
      "--output-width"
      "2560"
      "--"
    ];

    capSysNice = true;

    enable = true;

    enableWsi = true;
  };
}
