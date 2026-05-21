{
  flake.nixosModules.nix-development =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        deadnix
        nixfmt
        statix
      ];
    };
}
