{
  flake.nixosModules'.development =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        jq
        vscode-json-languageserver
      ];
    };
}
