{
  flake.nixosModules'.development.programs.git = {
    config.init.defaultBranch = "main";

    enable = true;

    lfs.enable = true;
  };
}
