{
  flake.nixosModules'.development =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        deadnix
        nixd
        nixfmt
        statix
      ];
    };
}
