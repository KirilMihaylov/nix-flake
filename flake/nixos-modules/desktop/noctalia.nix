{
  self,
  ...
}:
{
  flake.nixosModules'.desktop =
    {
      pkgs,
      ...
    }:
    {
      environment = {
        etc."noctalia/config.toml".source = self + "/files/config/noctalia.toml";

        sessionVariables.NOCTALIA_CONFIG_HOME = "/etc/";

        systemPackages = with pkgs; [
          noctalia
        ];
      };
    };
}
