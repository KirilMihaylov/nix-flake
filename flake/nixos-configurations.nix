{
  inputs,
  lib,
  self,
  ...
}:
{
  flake.nixosConfigurations =
    let
      inherit (lib)
        attrValues
        filesystem
        filter
        flip
        hasSuffix
        id
        mapAttrs
        mkMerge
        nixosSystem
        pipe
        readDir
        removeSuffix
        ;

      assert-message = "Hosts defined networking host name doesn't match the its entry from the `hosts` directory!";

      hosts-dir = readDir hosts-dir-path;

      hosts-dir-path = self + "/hosts";
    in
    pipe hosts-dir [
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

          system = nixosSystem {
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
                  id
              )
                (hosts-dir-path + "/${raw-host}");

            specialArgs = {
              inherit host inputs self;
            };
          };
        in
        {
          ${host} = if system.config.networking.hostName == host then system else throw assert-message;
        }
      ))
      attrValues
      mkMerge
    ];
}
