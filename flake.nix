{
	description = "Advent of Code 2024 shell";

	inputs = {
		nixpkgs.url = "github:NixOs/nixpkgs/nixos-unstable";
	};

	outputs = inputs: let
		system = "x86_64-linux";
		pkgs = import inputs.nixpkgs {
			inherit system;
			config.allowUnfree = true;
		};
	in {
		devShells.${system}.default =
			pkgs.mkShell {
				packages = with pkgs; [
					lua
					lua52Packages.luafilesystem
					lua52Packages.luabitop
				];
			};
	};
}
