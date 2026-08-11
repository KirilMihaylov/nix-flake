{
  flake.nixosModules'.development =
    {
      lib,
      pkgs,
      ...
    }:
    {
      environment =
        let
          inherit (pkgs) perf;
        in
        {
          variables.PERF = lib.getExe perf;

          systemPackages = with pkgs; [
            delta
            gh
            gnumake
            grcov
            just
            lazygit
            lazyjj
            libllvm
            lldb
            packages.helix'
            packages.jujutsu'
            packages.vscodium'
            perf
            zed-editor
          ];
        };
    };
}
