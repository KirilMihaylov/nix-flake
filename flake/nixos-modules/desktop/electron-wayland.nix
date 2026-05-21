{
  flake.nixosModules.electron-wayland.environment.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "auto";

    NIXOS_OZONE_WL = "1";
  };
}
