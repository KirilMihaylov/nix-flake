{
  flake.nixosModules.c-development =
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
