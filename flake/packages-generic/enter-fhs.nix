{
  flake.packages-generic.enter-fhs =
    {
      buildFHSEnv,
      coreutils,
      getent,
      lib,
      writeShellScriptBin,
    }:
    buildFHSEnv rec {
      name = pname;

      pname = "enter-fhs";

      meta.mainProgram = pname;

      runScript = ''
        $(
          case "''${#}" in
            ('0') echo "''${SHELL}";;
          esac
        )'';
    };
}
