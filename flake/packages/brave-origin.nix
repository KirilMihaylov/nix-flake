{
  flake.packages'.brave-origin' =
    {
      brave-origin,
    }:
    brave-origin.override {
      commandLineArgs = [
        "--gtk-version=4"
        "--profile-directory=Default"
      ];
    };
}
