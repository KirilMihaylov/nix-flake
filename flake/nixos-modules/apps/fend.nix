{
  flake.nixosModules'.fend =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        fend
      ];
    };
}
