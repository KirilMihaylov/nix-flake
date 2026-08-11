{
  flake.nixosModules'.development =
    {
      lib,
      pkgs,
      ...
    }:
    {
      environment =
        let
          inherit (pkgs) perf;
        in
        {
          variables.PERF = lib.getExe perf;

          systemPackages =
            with pkgs;
            with packages;
            [
              ast-grep
              delta
              gh
              gnumake
              grcov
              helix'
              jujutsu'
              just
              libllvm
              lldb
              owi
              perf
              pijul
            ];
        };
    };
}
