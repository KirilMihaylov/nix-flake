{
  inputs,
  self,
  ...
}:
{
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  flake.nixosModules.home-manager = {
    imports = [
      (inputs.home-manager + /nixos)
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
