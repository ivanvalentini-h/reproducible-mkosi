{
  description = "Build bit-by-bit reproducible OS images with mkosi";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };

      tools = import ./tools/default.nix { inherit pkgs; };
    in
    {
      packages = {

        # extract extracts partions from a disk image based on the partition table.
        extract = tools.extract;

        # diffimage builds two mkosi images, extracts and compares them.
        diffimage = tools.diffimage;
      };

      # Activate a devShell using `nix develop .#<shell-name>`.
      devShells = {
        # Build environments for reproducible mkosi builds.
        # Contain mkosi and tools used by mkosi to build images.
        mkosi-debian = import ./shells/debian.nix { inherit pkgs tools; };

      };

      # Run `nix fmt` to format the Nix code.
      formatter = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
    });
}
