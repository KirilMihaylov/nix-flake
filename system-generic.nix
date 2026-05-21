self@{
  inputs,
  ...
}:
let
  inherit (inputs.nixpkgs.lib)
    filesystem
    filter
    filterAttrs
    hasSuffix
    mapAttrs
    nixosSystem
    readDir
    ;

  hostsDir = self + /hosts;
in
mapAttrs (
  host: type:
  if type == "directory" then
    let
      hostNameAssertion = config: config.networking.hostName == host;

      hostNameAssertionMessage = "Defined host name has to match the one of the host definition directory!";

      system = nixosSystem {
        modules = [
          (
            {
              config,
              ...
            }:
            {
              config.assertions = [
                {
                  assertion = hostNameAssertion config;

                  message = hostNameAssertionMessage;
                }
              ];
            }
          )
        ]
        ++ (filter (hasSuffix ".nix") (filesystem.listFilesRecursive (hostsDir + "/${host}")));

        specialArgs = {
          inherit host inputs self;
        };
      };
    in
    if hostNameAssertion system.config then system else throw hostNameAssertionMessage
  else
    throw "File type of host has to be a directory!"
) (filterAttrs (_: type: type == "directory") (readDir hostsDir))
