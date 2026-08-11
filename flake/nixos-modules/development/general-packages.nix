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

          systemPackages = with pkgs; [
            ast-grep
            delta
            gh
            gnumake
            grcov
            just
            libllvm
            lldb
            owi
            packages.helix'
            packages.jujutsu'
            perf
          ];
        };
    };
}
