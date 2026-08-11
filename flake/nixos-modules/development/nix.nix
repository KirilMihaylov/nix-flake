{
  flake.nixosModules'.development =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        deadnix
        nix-melt
        nixd
        nixfmt
        statix
      ];
    };
}
