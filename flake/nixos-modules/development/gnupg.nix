{
  flake.nixosModules'.development.programs.gnupg.agent = {
    enable = true;

    enableSSHSupport = true;
  };
}
