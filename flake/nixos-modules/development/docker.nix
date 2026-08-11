{
  flake.nixosModules'.development =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        docker-compose-language-service
        docker-language-server
      ];
    };
}
