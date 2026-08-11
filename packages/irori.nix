{
  inputs,
  ...
}:
{
  irori =
    {
      buildFHSEnv,
      irori-unwrapped,
      lib,
    }:
    let
      inherit (lib) escapeShellArg;
    in
    buildFHSEnv (final: {
      extraInstallCommands = ''
        ln -sT ${escapeShellArg (irori-unwrapped + "/share")} "$out/share"
      '';

      name = "irori";

      runScript = "irori";

      targetPkgs =
        {
          python3,
          ...
        }:
        [
          irori-unwrapped
          python3
        ];
    });

  irori-unwrapped =
    {
      freetype,
      glib,
      gtk3,
      lib,
      libsoup_3,
      libxkbcommon,
      pkg-config,
      rust-stable,
      stdenvNoCC,
      sqlite,
      udev,
      vulkan-loader,
      wayland,
      zstd,
    }:
    let
      inherit (inputs) irori;

      inherit (lib) makeLibraryPath optionalString;

      inherit (stdenvNoCC.hostPlatform) isLinux;
    in
    rust-stable.platform.buildRustPackage (final: {
      buildInputs = [
        freetype
        glib
        gtk3
        libsoup_3
        libxkbcommon
        sqlite
        udev
        wayland
        zstd
      ];

      cargoBuildFlags = [
        "--bin"
        "irori"
        "--package"
        "irori"
      ];

      cargoLock.lockFile = final.src + "/Cargo.lock";

      doCheck = false;

      env = {
        LIBGIT2_NO_VENDOR = true;

        LIBSQLITE3_SYS_USE_PKG_CONFIG = true;

        OPENSSL_NO_VENDOR = true;

        ZSTD_SYS_USE_PKG_CONFIG = true;
      };

      meta.mainProgram = "irori";

      name = "irori";

      nativeBuildInputs = [
        pkg-config
      ];

      postFixup = optionalString isLinux ''
        patchelf "$out/bin/irori" --add-rpath ${
          makeLibraryPath [
            vulkan-loader
            wayland
          ]
        }
      '';

      postInstall = ''
        install -Dm644 "$src/packaging/irori.desktop" "$out/share/applications/irori.desktop"

        install -Dm644 "$src/packaging/irori.svg" "$out/share/icons/hicolor/scalable/apps/irori.svg"
      '';

      src = irori;
    });
}
