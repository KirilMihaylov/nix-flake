{
  flake.nixosModules'.desktop.environment = {
    etc."noctalia/config.toml".source = ../../../files/config/noctalia.toml;

    sessionVariables.NOCTALIA_CONFIG_HOME = "/etc/";
  };
}
