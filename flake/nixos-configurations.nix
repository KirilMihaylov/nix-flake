{
  inputs,
  lib,
  self,
  ...
}:
let
  inherit (lib)
    assertMsg
    attrValues
    concat
    const
    filesystem
    filter
    flip
    genAttrs
    hasSuffix
    makeOverridable
    mapAttrs
    mkForce
    mkMerge
    nixosSystem
    optional
    pipe
    readDir
    removeSuffix
    toList
    ;

  assert-message = "Host's defined networking host name doesn't match the its entry from the `hosts` directory!";

  hosts-dir = readDir hosts-dir-path;

  hosts-dir-path = self + "/hosts";
in
{
  flake.nixosConfigurations = pipe hosts-dir [
    (mapAttrs (
      raw-host: file-type:
      let
        host =
          if file-type == "directory" then
            raw-host
          else
            let
              trimmed = removeSuffix ".nix" raw-host;
            in
            if trimmed == raw-host then
              throw "Unexpected file in `hosts` directory! Got: ${raw-host}"
            else
              trimmed;

        system =
          makeOverridable
            (
              {
                vmHostPkgs,
              }:
              nixosSystem {
                modules = [
                  (
                    {
                      config,
                      ...
                    }:
                    {
                      config = {
                        assertions = [
                          {
                            assertion = config.networking.hostName == host;

                            message = assert-message;
                          }
                        ];

                        networking.hostName = host;

                        nixpkgs.overlays = [
                          (
                            _: prev:
                            let
                              field = "systemFlake";
                            in
                            assert !(prev ? ${field});
                            {
                              ${field} = self;
                            }
                          )
                        ]
                        ++ attrValues self.overlays;

                        virtualisation =
                          pipe
                            {
                              system.includeBuildDependencies = mkForce false;
                            }
                            [
                              toList
                              (pipe
                                {
                                  virtualisation.host.pkgs = vmHostPkgs;
                                }
                                [
                                  (optional (!(isNull vmHostPkgs)))
                                  concat
                                ]
                              )
                              mkMerge
                              const
                              (genAttrs [
                                "vmVariant"
                                "vmVariantWithBootLoader"
                              ])
                            ];
                      };
                    }
                  )
                ]
                ++
                  (
                    if file-type == "directory" then
                      flip pipe [
                        filesystem.listFilesRecursive
                        (filter (hasSuffix ".nix"))
                      ]
                    else
                      toList
                  )
                    (hosts-dir-path + "/${raw-host}");

                specialArgs = {
                  inherit host inputs self;
                };
              }
            )
            {
              vmHostPkgs = null;
            };
      in
      {
        ${host} =
          assert assertMsg (system.config.networking.hostName == host) assert-message;
          system;
      }
    ))
    attrValues
    mkMerge
  ];
}
