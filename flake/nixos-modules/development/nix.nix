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
          nix-melt
          nixd
          nixfmt
          statix
        ];
    };
}
