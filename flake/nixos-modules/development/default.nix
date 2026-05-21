{
  self,
  ...
}:
{
  flake.nixosModules.development =
    {
      lib,
      pkgs,
      ...
    }:
    {
      imports = with self.nixosModules; [
        c-development
        nix-development
        rust-development
      ];

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
            packages.git'
            packages.helix'
            packages.jujutsu'
            packages.vscodium'
            perf
            zed-editor
          ];
        };

      programs = {
        direnv.enable = true;

        git = {
          config.init.defaultBranch = "main";

          enable = true;

          lfs.enable = true;
        };

        gnupg.agent = {
          enable = true;

          enableSSHSupport = true;
        };

        ssh.enableAskPassword = true;
      };
    };
}
