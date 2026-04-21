{
  description = "dotnet + fsharp dev env";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pkgs.dotnet-sdk
          pkgs.dotnet-runtime
          pkgs.git
        ];

        shellHook = ''
          export DOTNET_CLI_TELEMETRY_OPTOUT=1
          export DOTNET_ROOT=${pkgs.dotnet-sdk}
        '';
      };
    };
}
