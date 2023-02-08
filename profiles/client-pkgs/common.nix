# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ pkgs, ... }: {
  nix = {
    generateNixPathFromInputs = true;
    generateRegistryFromInputs = true;
    linkInputs = true;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };

  environment = {
    systemPackages = with pkgs; [
      awscli2
      alejandra
      cachix
      deploy-rs
      discord
      delve
      dig
      deadnix
      fd
      foundry-bin
      my-ferretdb
      # jdt-language-server
      tealdeer
      tendermint
      socat
      rustscan
      gitAndTools.gitflow
      git-crypt
      gopls
      graphviz
      grpcurl
      (python3.withPackages (_:
        with python3.pkgs; [
          cmake-language-server
          colour
          epc
          ipython
          matplotlib
          nbformat
          newsapi-python
          nltk
          orjson
          python-lsp-server
          pandas
          python-dotenv
          six
          virtualenv
        ]))
      metals
      marksman
      mongosh
      # mycli
      nixfmt
      nix-du
      nyxt
      neofetch
      node2nix
      nodejs_latest
      nodePackages."bash-language-server"
      nodePackages."prettier"
      nodePackages."typescript-language-server"
      nodePackages."yaml-language-server"
      nodePackages."vscode-langservers-extracted"
      nvfetcher
      nix-index-update
      nil
      openssl
      oath-toolkit
      pgcli
      plantuml
      qrencode
      ripgrep
      terraform
      terranix
      tectonic
      #texlive.combined.scheme-full
      tronbox
      unzip
      universal-ctags
      rust-analyzer
      rustc
      sbcl
      slack
      slither-analyzer
      statix
      shellcheck
      solium
      shfmt
      sops
      scalafmt
      solc-select
      stow
      wakatime
      winklink
      wakatime
      zoom-us
    ];
  };
}
