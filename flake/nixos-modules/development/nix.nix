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
          deadnix
          flake-repl
          nix-eval-jobs
          nix-fast-build
          nix-melt
          nixd
          nixfmt
          statix
        ];
    };
}
