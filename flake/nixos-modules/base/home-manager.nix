{
  inputs,
  self,
  ...
}:
{
  flake.nixosModules'.base = {
    imports = [
      inputs.home-manager.nixosModules.default
    ];

    home-manager = {
      extraSpecialArgs = {
        inherit inputs self;
      };

      sharedModules = [
        self.homeModules.base
      ];

      useGlobalPkgs = true;

      useUserPackages = true;
    };
  };
}
