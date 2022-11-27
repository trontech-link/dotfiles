# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{pkgs, ...}: {
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
      asciinema
      awscli2
      alejandra
      azure-cli
      cachix
      deploy-rs
      discord
      delve
      dig
      deadnix
      neofetch
      fd
      jdt-language-server
      tealdeer
      tendermint
      socat
      rustscan
      gitAndTools.gitflow
      git-crypt
      gcc
      gopls
      gdb
      graphviz
      (python3.withPackages (_:
        with python3.pkgs; [
          epc
          six
          orjson
          python-lsp-server
          cmake-language-server
          colour
        ]))
      wakatime
      metals
      nixfmt
      node2nix
      nodejs
      nodePackages."bash-language-server"
      nodePackages."prettier"
      nodePackages."typescript-language-server"
      nodePackages."yaml-language-server"
      nodePackages."vscode-langservers-extracted"
      nvfetcher
      nix-index-update
      nixopsUnstable
      nil
      openssl
      plantuml
      ripgrep
      terraform
      terranix
      tronbox
      unzip
      rust-analyzer
      rustc
      sbcl
      slack
      statix
      shellcheck
      shfmt
      sops
      scalafmt
      solc-select
      stow
      winklink
      wakatime
      zoom-us
    ];
  };
}
