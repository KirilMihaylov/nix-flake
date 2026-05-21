{
  flake.nixosModules.office-suite =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        libreoffice-qt6
      ];

      # Required for LibreOffice Base.
      programs.java.enable = true;
    };
}
