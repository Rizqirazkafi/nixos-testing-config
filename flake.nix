{
	description = "Home Manager configuration of rizqirazkafi";

	inputs = {
# Specify the source of Home Manager and Nixpkgs.
		nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nix-colors.url = "github:misterio77/nix-colors";
	};

	outputs = { nixpkgs, home-manager, ... }@inputs:
		let
		system = "x86_64-linux";
	lib = nixpkgs.lib;
	pkgs = nixpkgs.legacyPackages.${system};
	in {
		nixosConfigurations = {
			nixos = lib.nixosSystem {
				inherit system;
				modules = [ ./nixos/configuration.nix ];
			};
		};
		homeConfigurations."rizqirazkafi" = home-manager.lib.homeManagerConfiguration {
			inherit pkgs;
			extraSpecialArgs = { inherit inputs; };

# Specify your home configuration modules here, for example,
# the path to your home.nix.
			modules = [ ./home.nix ];

# Optionally use extraSpecialArgs
# to pass through arguments to home.nix
		};
	};
}

