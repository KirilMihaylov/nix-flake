{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  inherit (lib) mkForce pipe toList;

  inherit (pkgs.packages) jujutsu jujutsu-config;
in
{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader.systemd-boot.enable = true;

    tmp.cleanOnBoot = true;
  };

  documentation = {
    enable = true;

    man.enable = true;
  };

  environment.systemPackages =
    with pkgs;
    with packages;
    [
      jq
      man-pages
      man-pages-posix
      python3
      rust-toolchain
      stdenv.cc.cc
      uv
    ]
    ++ (pipe
      {
        email = "80464733+KirilMihaylov@users.noreply.github.com";

        name = "Kiril Mihaylov";
      }
      [
        (user: {
          inherit user;

          ui.default-command = "log";
        })
        (extraConfig: {
          inherit extraConfig;
        })
        jujutsu-config.override
        (jujutsu-config: {
          inherit jujutsu-config;
        })
        jujutsu.override
        toList
      ]
    );

  fileSystems."/" = {
    device = "/dev/null";

    fsType = "ext3";
  };

  networking = {
    nameservers = [
      "1.1.1.1#one.one.one.one"
      "1.2.3.4#one.one.one.one"
      "9.9.9.9#one.one.one.one"
      "8.8.8.8"
    ];

    networkmanager = {
      dns = "systemd-resolved";

      enable = true;
    };
  };

  nix = {
    channel.enable = false;

    checkAllErrors = true;

    checkConfig = true;

    enable = true;

    extraOptions = ''
      keep-derivations = true

      keep-outputs = true
    '';

    settings = {
      experimental-features = [
        "flakes"
        "nix-command"
      ];

      require-sigs = true;

      show-trace = true;
    };
  };

  nixpkgs = {
    flake = {
      setFlakeRegistry = true;

      setNixPath = true;
    };

    hostPlatform.system = "x86_64-linux";
  };

  programs = {
    appimage = {
      binfmt = true;

      enable = true;
    };

    fish = {
      shellInit = ''
        ulimit -n 65536
      '';

      enable = true;

      generateCompletions = true;
    };

    git = {
      config.user = {
        email = "80464733+KirilMihaylov@users.noreply.github.com";

        name = "Kiril Mihaylov";
      };

      enable = true;
    };

    nix-ld = {
      enable = true;

      libraries =
        with pkgs;
        options.programs.nix-ld.libraries.default
        ++ [
          coreutils
          glib
          gmp
          libcap
          libdrm
          libelf
          libxkbcommon
          networkmanager
          nss
          pipewire
        ];
    };

    neovim = {
      defaultEditor = true;

      enable = true;

      viAlias = true;

      vimAlias = true;
    };
  };

  security.polkit = {
    enable = true;

    extraConfig = ''
      polkit.addRule(function (action, subject) {
        if (
          action.id.startsWith("org.freedesktop.login1.power-off") &&
          subject.isInGroup("power")
        ) {
          return polkit.Result.YES;
        }
      });
    '';
  };

  services = {
    getty.autologinUser = "user";

    resolved = {
      enable = true;

      settings.Resolve = {
        DNSOverTLS = true;

        DNSSEC = true;
      };
    };
  };

  system = {
    disableInstallerTools = true;

    includeBuildDependencies = false;

    stateVersion = "26.11";
  };

  users = {
    allowNoPasswordLogin = true;

    defaultUserShell = config.programs.fish.package;

    groups = {
      power = { };

      user.gid = 1000;
    };

    mutableUsers = false;

    users.user = {
      extraGroups = [
        "power"
        "users"
        "wheel"
      ];

      group = "user";

      isNormalUser = true;

      password = "pass";

      uid = 1000;
    };
  };

  virtualisation.vmVariant = {
    boot = {
      kernelParams = [
        "console=ttyS0"
      ];

      loader.timeout = 0;
    };

    virtualisation = {
      cores = 6;

      diskImage = "$HOME/${config.system.name}.qcow2";

      diskSize = 32768;

      graphics = false;

      memorySize = 8192;

      sharedDirectories.shared = {
        source = mkForce ''"$HOME/Work/VM Shared"'';

        target = mkForce "/shared";

        writable = true;
      };

      useDefaultFilesystems = true;

      writableStore = true;
    };
  };
}
