{ config, pkgs, lib, ... }:

let
  common-files-path = ../../../common;
  secret-files-path = common-files-path + "/secrets";
  share = import (common-files-path + /share.nix);
in {

  age.secrets.acme_credentials = {
    file = secret-files-path + /acme_credentials.age;
    mode = "770";
    owner = "acme";
    group = "acme";
  };

  security = {
    pam.services.nginx.setEnvironment = false;

    acme = {
      acceptTerms = true;
      defaults = {
        email = "xiongchenyu6@gmail.cam";
        # postRun = ''
        #   ${pkgs.systemd}/bin/systemctl restart openldap
        # '';
      };
      certs = {
        "${config.networking.fqdn}" = {
          dnsProvider = "namedotcom";
          domain = "*.${config.networking.domain}";
          credentialsFile = config.age.secrets.acme_credentials.path;
          # We don't need to wait for propagation since this is a local DNS server
          dnsPropagationCheck = false;
          reloadServices =
            [ "openldap.service" "postfix.service" "dovecot2.service" ];
          group = "openldap";
        };
        "inner.${config.networking.domain}" = {
          domain = "*.inner.${config.networking.domain}";
          dnsProvider = "rfc2136";
          credentialsFile = "/var/lib/secrets/certs.secret";
          # We don't need to wait for propagation since this is a local DNS server
          dnsPropagationCheck = false;
          group = "nginx";
        };
      };
    };
  };
}