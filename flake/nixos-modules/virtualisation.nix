{
  flake.nixosModules.virtualisation =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib)
        elem
        mkMerge
        mkOption
        types
        ;

      inherit (types) listOf passwdEntry str;
    in
    {
      config = {
        boot =
          let
            inherit (config.host.hardware) cpu;
          in
          if
            elem cpu.arch [
              "x86"
              "x86_64"
            ]
          then
            let
              module = "kvm-${cpu.manufacturer}";
            in
            {
              extraModprobeConfig = ''
                options ${module} nested=1
              '';

              kernelModules = [
                module
              ];
            }
          else
            { };

        environment.systemPackages = with pkgs; [
          libguestfs
        ];

        programs.virt-manager.enable = true;

        virtualisation.libvirtd = {
          enable = true;

          nss.enableGuest = true;

          qemu.swtpm.enable = true;
        };

        users.users = mkMerge (
          map (user: {
            ${user}.extraGroups = [
              "libvirtd"
            ];
          }) (config.host.virtualisation.users or [ ])
        );
      };

      options.host.virtualisation.users = mkOption {
        description = "Represents a list of users who should be given permissions to use virtualisation capabilities.";

        type = listOf (passwdEntry str);
      };
    };
}
