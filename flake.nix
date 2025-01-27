{
  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };
    systems = {
      type = "github";
      owner = "nix-systems";
      repo = "default";
    };
    flake-compat = {
      type = "github";
      owner = "edolstra";
      repo = "flake-compat";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      eachSystem = lib.genAttrs (import systems);
    in
    {
      legacyPackages = eachSystem (
        system:
        import ./pkgs {
          inherit self;
          pkgs = nixpkgs.legacyPackages.${system};
        }
      );

      formatter = eachSystem (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      devShells = eachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShellNoCC { packages = [ pkgs.npins ]; };
          fetcher = pkgs.mkShell {
            packages = builtins.attrValues { inherit (pkgs) rust-analyzer clippy rustfmt; };
            inputsFrom = [ self.legacyPackages.${system}.fetcher ];
          };
        }
      );
    }
    // builtins.listToAttrs (
      map
        (x: {
          name = "${x}Modules";
          value = {
            default = self."${x}Modules".spicetify;
            spicetify.imports = [
              (lib.modules.importApply ./modules/common.nix self)
              ./modules/${x}.nix
            ];
          };
        })
        [
          "nixos"
          "homeManager"
          "darwin"
        ]
    );

}
