{
  flake.nixosModules'.development =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        dotnet-sdk
        netcoredbg
        roslyn-ls
      ];
    };
}
