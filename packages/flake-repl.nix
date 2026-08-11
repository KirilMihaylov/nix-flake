let
  name = "flake-repl";
in
{
  ${name} =
    {
      writeShellApplication,
    }:
    writeShellApplication {
      inherit name;

      runtimeEnv.script = ''
        with (import <nixpkgs/lib>).fileset;
        let
          root = ./.;

          self = import <flake-compat> {
            inherit src;
          };

          src = toSource {
            inherit root;

            fileset = gitTracked root;
          };
        in
        self.outputs // {
          inherit self;
        }'';

      text = ''exec nix repl --expr "$script" "$@"'';
    };
}
