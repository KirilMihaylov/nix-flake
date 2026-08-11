let
  name = "enter-fhs";
in
{
  ${name} =
    {
      buildFHSEnv,
    }:
    buildFHSEnv {
      inherit name;

      meta.mainProgram = name;

      pname = name;

      runScript = ''
        $(
          case "''${#}" in
            ('0') echo "''${SHELL:?"No shell is set via the \"SHELL\" environment variable!"}";;
          esac
        )'';
    };
}
