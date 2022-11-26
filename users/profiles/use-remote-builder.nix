# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  home = {
    stateVersion = "22.11";
  };
  programs = {
    ssh = {
      enable = true;
      hashKnownHosts = false;
      compression = true;
      matchBlocks = {
        "hydra.inner.trontech.link" = {
          user = "freeman.xiong";
        };
      };
      extraConfig = ''
        GSSAPIAuthentication yes
        PasswordAuthentication yes
      '';
    };
  };
}
