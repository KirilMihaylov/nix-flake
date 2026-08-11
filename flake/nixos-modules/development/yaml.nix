{
  flake.nixosModules'.development =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        yaml-language-server
        yamlfmt
      ];
    };
}
