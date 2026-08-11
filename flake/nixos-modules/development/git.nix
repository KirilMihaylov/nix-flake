{
  flake.nixosModules'.development =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        packages.git'
      ];

      programs.git = {
        config.init.defaultBranch = "main";

        enable = true;

        lfs.enable = true;
      };
    };
}
