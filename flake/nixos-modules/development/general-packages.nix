{
  flake.nixosModules'.development =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages =
        with pkgs;
        with packages;
        [
          ast-grep
          delta
          gh
          gnumake
          grcov
          helix
          jujutsu
          just
          libllvm
          lldb
          owi
          perf
          pijul
        ];
    };
}
