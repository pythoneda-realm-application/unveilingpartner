{
  description = "Application layer for UnveilingPartner's PythonEDA realm";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    pythoneda-base = {
      url = "github:pythoneda/base/0.0.1a15";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
    };
    pythoneda-realm-unveilingpartner = {
      url = "github:pythoneda-realm/unveilingpartner/0.0.1a1";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-base.follows = "pythoneda-base";
    };
    pythoneda-realm-infrastructure-unveilingpartner = {
      url = "github:pythoneda-realm-infrastructure/unveilingpartner/0.0.1a1";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-base.follows = "pythoneda-base";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixos { inherit system; };
        description =
          "Application layer for UnveilingPartner's PythonEDA realm";
        license = pkgs.lib.licenses.gpl3;
        homepage =
          "https://github.com/pythoneda-realm-application/unveilingpartner";
        maintainers = with pkgs.lib.maintainers; [ ];
        nixpkgsRelease = "nixos-23.05";
        shared = import ./nix/devShells.nix;
        pythoneda-realm-application-unveilingpartner-for = { version
          , pythoneda-base, pythoneda-realm-unveilingpartner
          , pythoneda-realm-infrastructure-unveilingpartner, python }:
          let
            pname = "pythoneda-realm-application-unveilingpartner";
            pythonVersionParts = builtins.splitVersion python.version;
            pythonMajorVersion = builtins.head pythonVersionParts;
            pythonMajorMinorVersion =
              "${pythonMajorVersion}.${builtins.elemAt pythonVersionParts 1}";
            pnameWithUnderscores =
              builtins.replaceStrings [ "-" ] [ "_" ] pname;
            wheelName =
              "${pnameWithUnderscores}-${version}-py${pythonMajorVersion}-none-any.whl";
          in python.pkgs.buildPythonPackage rec {
            inherit pname version;
            projectDir = ./.;
            src = ./.;
            format = "pyproject";

            nativeBuildInputs = with python.pkgs; [ pip pkgs.jq poetry-core ];
            propagatedBuildInputs = with python.pkgs; [
              pythoneda-base
              pythoneda-realm-unveilingpartner
              pythoneda-realm-infrastructure-unveilingpartner
            ];

            checkInputs = with python.pkgs; [ pytest ];

            pythonImportsCheck =
              [ "pythonedarealmapplicationunveilingpartner" ];

            preBuild = ''
              python -m venv .env
              source .env/bin/activate
              pip install ${pythoneda-base}/dist/pythoneda_base-${pythoneda-base.version}-py3-none-any.whl
              pip install ${pythoneda-realm-unveilingpartner}/dist/pythoneda_realm_unveilingpartner-${pythoneda-realm-unveilingpartner.version}-py3-none-any.whl
              pip install ${pythoneda-realm-infrastructure-unveilingpartner}/dist/pythoneda_realm_infrastructure_unveilingpartner-${pythoneda-realm-infrastructure-unveilingpartner.version}-py3-none-any.whl
              rm -rf .env
            '';

            postInstall = ''
              mkdir $out/dist
              cp dist/${wheelName} $out/dist
              jq ".url = \"$out/dist/${wheelName}\"" $out/lib/python${pythonMajorMinorVersion}/site-packages/${pnameWithUnderscores}-${version}.dist-info/direct_url.json > temp.json && mv temp.json $out/lib/python${pythonMajorMinorVersion}/site-packages/${pnameWithUnderscores}-${version}.dist-info/direct_url.json
            '';

            meta = with pkgs.lib; {
              inherit description license homepage maintainers;
            };
          };
        pythoneda-realm-application-unveilingpartner-0_0_1a1-for =
          { pythoneda-base, pythoneda-realm-unveilingpartner
          , pythoneda-realm-infrastructure-unveilingpartner, python }:
          pythoneda-realm-application-unveilingpartner-for {
            version = "0.0.1a1";
            inherit pythoneda-base pythoneda-realm-unveilingpartner
              pythoneda-realm-infrastructure-unveilingpartner python;
          };
      in rec {
        packages = rec {
          pythoneda-realm-application-unveilingpartner-0_0_1a1-python39 =
            pythoneda-realm-application-unveilingpartner-0_0_1a1-for {
              pythoneda-base =
                pythoneda-base.packages.${system}.pythoneda-base-latest-python39;
              pythoneda-realm-unveilingpartner =
                pythoneda-realm-unveilingpartner.packages.${system}.pythoneda-realm-unveilingpartner-latest-python39;
              pythoneda-realm-infrastructure-unveilingpartner =
                pythoneda-realm-infrastructure-unveilingpartner.packages.${system}.pythoneda-realm-infrastructure-unveilingpartner-latest-python39;
              python = pkgs.python39;
            };
          pythoneda-realm-application-unveilingpartner-0_0_1a1-python310 =
            pythoneda-realm-application-unveilingpartner-0_0_1a1-for {
              pythoneda-base =
                pythoneda-base.packages.${system}.pythoneda-base-latest-python310;
              pythoneda-realm-unveilingpartner =
                pythoneda-realm-unveilingpartner.packages.${system}.pythoneda-realm-unveilingpartner-latest-python310;
              pythoneda-realm-infrastructure-unveilingpartner =
                pythoneda-realm-infrastructure-unveilingpartner.packages.${system}.pythoneda-realm-infrastructure-unveilingpartner-latest-python310;
              python = pkgs.python310;
            };
          pythoneda-realm-application-unveilingpartner-latest-python39 =
            pythoneda-realm-application-unveilingpartner-0_0_1a1-python39;
          pythoneda-realm-application-unveilingpartner-latest-python310 =
            pythoneda-realm-application-unveilingpartner-0_0_1a1-python310;
          pythoneda-realm-application-unveilingpartner-latest =
            pythoneda-realm-application-unveilingpartner-latest-python310;
          default = pythoneda-realm-application-unveilingpartner-latest;
        };
        defaultPackage = packages.default;
        devShells = rec {
          pythoneda-realm-application-unveilingpartner-0_0_1a1-python39 =
            shared.devShell-for {
              package =
                packages.pythoneda-realm-application-unveilingpartner-0_0_1a1-python39;
              pythoneda-base =
                pythoneda-base.packages.${system}.pythoneda-base-latest-python39;
              python = pkgs.python39;
              inherit pkgs nixpkgsRelease;
            };
          pythoneda-realm-application-unveilingpartner-0_0_1a1-python310 =
            shared.devShell-for {
              package =
                packages.pythoneda-realm-application-unveilingpartner-0_0_1a1-python310;
              pythoneda-base =
                pythoneda-base.packages.${system}.pythoneda-base-latest-python310;
              python = pkgs.python310;
              inherit pkgs nixpkgsRelease;
            };
          pythoneda-realm-application-unveilingpartner-latest-python39 =
            pythoneda-realm-application-unveilingpartner-0_0_1a1-python39;
          pythoneda-realm-application-unveilingpartner-latest-python310 =
            pythoneda-realm-application-unveilingpartner-0_0_1a1-python310;
          pythoneda-realm-application-unveilingpartner-latest =
            pythoneda-realm-application-unveilingpartner-latest-python310;
          default = pythoneda-realm-application-unveilingpartner-latest;

        };
      });
}
