{
  description = "python program";

  inputs = {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    };

  outputs = { self, nixpkgs }:
  let

    system = "x86_64-linux";

    pkgs = import nixpkgs { inherit system; };

  in
  {
    devShells.${system}.default =
      pkgs.mkShell {
        propagatedBuildInputs = [
          # (pkgs.extend (final: prev: {
          #   ags = prev.ags.overrideAttrs (old: {
          #     buildInputs = old.buildInputs ++ [ prev.libdbusmenu-gtk3 ];
          #   });
          # })).ags
          pkgs.nodePackages_latest.nodejs # For NPM
          pkgs.sassc
        ];
      };
  };
}
