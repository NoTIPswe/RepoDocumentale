{
  description = "NoTIP Docs-as-Code Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {

          buildInputs = with pkgs; [

            nil

            typst
            typstyle
            tinymist

            python3

            graphviz
            plantuml

            hunspell
            hunspellDicts.en_US
            hunspellDicts.it_IT

            noto-fonts
          ];

          LANG = "C.UTF-8";
          LC_ALL = "C.UTF-8";
          PYTHONUTF8 = "1";

          shellHook = ''
            export VIRTUAL_ENV="$PWD/.nixpyvenv"
            export PATH="$VIRTUAL_ENV/bin:$PATH"

            if [ ! -d ".nixpyvenv" ]; then
              echo "Initializing Python venv..."
              ${pkgs.python3}/bin/python -m venv .nixpyvenv
            fi

            if [ -d "notipdo" ]; then
              echo "Verifying local notipdo installation..."
              pip install --upgrade pip
              pip install -r notipdo/requirements.txt
              pip install -e notipdo/
            fi

            echo "Environment ready."
          '';
        };
      }
    );
}
