{
  flake.packages'.enter-fhs =
    {
      buildFHSEnv,
    }:
    buildFHSEnv rec {
      name = pname;

      pname = "enter-fhs";

      meta.mainProgram = pname;

      runScript = ''
        $(
          case "''${#}" in
            ('0') echo "''${SHELL:?"No shell is set via the \"SHELL\" environment variable!"}";;
          esac
        )'';
    };
}
