# Edit this configuration file to define what should be installed on

# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports = [ ./common.nix ];

  environment = { pathsToLink = [ "/share/zsh" ]; };

  services = {
    dbus = { enable = true; };

    gnome = { gnome-keyring = { enable = true; }; };

    openldap = { enable = true; };
  };

  programs = {
    atop = {
      enable = true;
      netatop = { enable = true; };
      atopgpu = { enable = true; };
    };
    nm-applet = { enable = true; };
    nix-ld.enable = true;
  };

}
