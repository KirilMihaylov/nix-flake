{
  flake.nixosModules'.development =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        bacon
        cargo-audit
        cargo-deny
        cargo-nextest
        packages.rust
      ];
    };
}
