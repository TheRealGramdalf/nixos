{
  description = "TheRealGramdalf's experimental config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    #nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    # ^^ Todo if needed

    #home-manager = {
    #  url = "github:nix-community/home-manager/master";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    #hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { 
    self,
    nixpkgs,
    #home-manager,
    #hyprland,
    #inputs, # The `inputs` attribute set defined above?
    ... # Allow additional arguments to be passed without an error
  }: #@context
  let
    # Create convenience shorthands for use in the modules below
    lib = nixpkgs.lib;
    #pkgs = import nixpkgs {
    #  conig.allowUnfree = true;
    #};
  in
  {
    nixosConfigurations = {
      "ripjaw" = lib.nixosSystem {
        specialArgs = { inherit nixpkgs; };
        modules = [
          ./config/hosts/ripjaw/main.nix
          #home-manager.nixosModules.home-manager
      ];};
      "aerwiar" = lib.nixosSystem {
        specialArgs = { inherit nixpkgs; };
        modules = [
          ./config/hosts/aerwiar/main.nix
          #home-manager.nixosModules.home-manager
      ];};
    };
  };

  # Global nix.settings, these are presented to the user as an optional choice on rebuild
  nixConfig = {
    # See https://nixos.org/manual/nix/stable/command-ref/conf-file.html?highlight=you%20can%20prefix%20the%20name%20of%20the%20setting%20by%20extra-%20to%20append%20to%20the%20previous%20value#file-format
    extra-substituters = [
      "https://nix-community.cachix.org"
      #"https://hyprland.cachix.org"
    ];
    
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      #"hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };
}
