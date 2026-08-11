{
  flake.nixosModules'.development =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        cargo-audit
        cargo-deny
        cargo-nextest
        packages.rust
      ];
    };
}
