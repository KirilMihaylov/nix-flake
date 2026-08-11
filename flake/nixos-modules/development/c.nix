{
  flake.nixosModules'.development =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        clang
        cmake
        gcc
        libclang
      ];
    };
}
