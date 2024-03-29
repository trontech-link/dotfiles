{ modulesPath, suites, profiles, config, ... }: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    profiles.server-apps.acme
    profiles.server-apps.admin.kerberos
    profiles.server-apps.admin.openldap
    profiles.server-apps.admin.sasl
    profiles.server-apps.admin.sssd
    profiles.server-apps.bgp.bird-border
    profiles.server-apps.dns.bind
    profiles.server-apps.log.loki
    profiles.server-apps.mail.postfix
    profiles.server-apps.mail.dovecot2
    profiles.server-apps.mail.alps
    profiles.server-apps.monitor.endlessh-go
    profiles.server-apps.monitor.grafana
    profiles.server-apps.monitor.prometheus
    profiles.server-apps.proxy.nginx
    profiles.server-apps.atuin
    profiles.server-apps.webapps.keycloak
    profiles.server-apps.oci-arm-host-capacity
    profiles.server-pkgs.nixos
    profiles.users.root.nixos
    profiles.users."freeman.xiong"
  ] ++ suites.server-base;

  boot.loader.grub.device = "/dev/vda";
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" ];
  boot.initrd.kernelModules = [ "nvme" ];

  fileSystems."/" = {
    device = "/dev/vda2";
    fsType = "ext4";
  };

  zramSwap.enable = true;

  boot = {
    #isContainer = true;
    cleanTmpDir = true;
    kernel = {
      sysctl = {
        "net.ipv4.ip_forward" = 1;
        # "net.ipv4.conf.default.rp_filter" = 0;
        # "net.ipv4.conf.all.rp_filter" = 0;
        # "net.ipv4.conf.default.forwarding" = 1;
        # "net.ipv4.conf.all.forwarding" = 1;

        # "net.ipv6.conf.all.accept_redirects" = 0;
        # "net.ipv6.conf.default.forwarding" = 1;
        # "net.ipv6.conf.all.forwarding" = 1;
      };
    };
  };

  sops.secrets."wireguard/mail" = { };
  # sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  # sops.age.generateKey = true;

  networking = {
    # interfaces = {
    #   lo = {
    #     ipv4 = {
    #       addresses = [{
    #         address = "172.22.240.97";
    #         prefixLength = 32;
    #       }];
    #     };
    #     ipv6 = {
    #       addresses = [{
    #         address = "fd48:4b4:f3::1";
    #         prefixLength = 128;
    #       }];
    #     };
    #   };
    # };

    nat = {
      enable = true;
      enableIPv6 = true;
      externalInterface = "ens5";
      internalInterfaces = [ "wg_game" "wg_office" ];
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [
        25 # SMTP
        53
        80 # ui
        88 # kerberos
        89
        179
        389
        443
        464 # kerberos change password
        465 # smpts
        636 # ldaps
        993 # imaps
        6695
        8000
        8888
      ];
      allowedUDPPorts = [
        53 # dns
        80
        89
        88 # kerberos
        179 # bird2
        389 # ldap
        636
        6696
        22616
        22617
        22618
        23396
        21816
        33434
      ];
    };
    sits = {
      he-ipv6 = {
        local = "10.0.8.10";
        remote = "216.218.221.42";
        ttl = 255;
        dev = "ens5";
      };
    };
    interfaces = {
      he-ipv6 = {
        ipv6 = {
          routes = [{
            address = "::";
            prefixLength = 0;
          }];
          addresses = [{
            address = "2001:470:35:606::2";
            prefixLength = 64;
          }];
        };
      };
    };
    wg-quick = {
      interfaces = let
        privateKeyFile = config.sops.secrets."wireguard/mail".path;
        address = [ "fe80::100/64" "fd48:4b4:f3::1/48" "172.22.240.97/27" ];
        # address = [ "fd48:4b4:f3::2" ];
        table = "off";
        allowedIPs = [
          "10.0.0.0/8"
          "172.20.0.0/14"
          "172.31.0.0/16"
          "fd00::/8"
          "fe80::/64"
          "fd48:4b4:f3::/48"
          "ff02::1:6/128"
        ];
      in {
        wg_digital = {
          inherit privateKeyFile address table;
          listenPort = 22618;
          peers = [{
            endpoint = "178.128.82.145:22616";
            publicKey = profiles.share.hosts-dict.digital.wg.public-key;
            inherit allowedIPs;
          }];
        };

        wg_office = {
          inherit address privateKeyFile table;
          listenPort = 22616;

          peers = [{
            publicKey = profiles.share.hosts-dict.office.wg.public-key;
            inherit allowedIPs;
          }];
        };
        wg_game = {
          inherit address privateKeyFile table;
          listenPort = 22617;
          # postUp = ''
          #   ${pkgs.iproute2}/bin/ip addr add dev wg_game 172.22.240.97 peer 172.22.240.99
          #   ${pkgs.iproute2}/bin/ip addr add dev wg_game fe80::100 peer fd48:4b4:f3::3
          # '';

          peers = [{
            publicKey = profiles.share.hosts-dict.game.wg.public-key;
            inherit allowedIPs;
          }];
        };
        wg_theresa = {
          inherit privateKeyFile address table;
          listenPort = 23396;
          peers = [{
            endpoint = "cn2.dn42.theresa.cafe:22616";
            publicKey = "MqKkzCwYfOg8Fc/pRRctLW3jS72ACBDQr8ZF10sZ614=";
            inherit allowedIPs;
          }];
        };
        wg_potat0 = {
          inherit privateKeyFile address table;
          listenPort = 21816;
          peers = [{
            endpoint = "us1.dn42.potat0.cc:22616";
            publicKey = "LUwqKS6QrCPv510Pwt1eAIiHACYDsbMjrkrbGTJfviU=";
            inherit allowedIPs;
          }];
        };
        wg_tech9 = {
          inherit privateKeyFile address table;
          listenPort = 21588;
          peers = [{
            endpoint = "sg-sin01.dn42.tech9.io:52507";
            publicKey = "4qLIJ9zpc/Xgvy+uo90rGso75cSrT2F5tBEv+6aqDkY=";
            inherit allowedIPs;
          }];
        };
      };
    };
  };
  services = {
    babeld.enable = true;
    babeld.extraConfig = ''
      redistribute ip 172.20.0.0/14
      redistribute if ens5 deny
    '';

    babeld.interfaces = {
      wg_game = {
        hello-interval = 5;
        split-horizon = "auto";
        type = "wired";

      };
      wg_office = {
        hello-interval = 5;
        split-horizon = "auto";
        type = "wired";
      };
      wg_digital = {
        hello-interval = 5;
        split-horizon = "auto";
        type = "wired";
      };
    };

    prometheus.exporters = {
      postgres = {
        enable = true;
        port = 9009;
      };

      wireguard = {
        enable = true;
        port = 9010;
      };
    };
  };

}
