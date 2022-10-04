{ config, pkgs, lib, symlinkJoin, domain, ... }:
let
  common-files-path = ../../common;
  secret-files-paht = common-files-path + "/secrets";
  script = import ../../dn42/update-roa.nix { inherit pkgs; };
  share = import (common-files-path + /share.nix);
in
{
  age.secrets.tc_wg_pk.file = secret-files-paht + /tc_wg_pk.age;

  age.secrets.tc_https_pk = {
    file = secret-files-paht + /tc_https_pk.age;
    mode = "770";
    owner = "nginx";
    group = "nginx";
  };

  age.secrets.acme_credentials = {
    file = secret-files-paht + /acme_credentials.age;
    mode = "770";
    owner = "acme";
    group = "acme";
  };


  imports = [
    ./hardware-configuration.nix
    ../../nixos/server.nix
  ];

  #boot.cleanTmpDir = true;
  zramSwap.enable = true;
  boot = {
    #isContainer = true;
    kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
      "net.ipv6.conf.default.forwarding" = 1;

      "net.ipv4.conf.default.rp_filter" = 0;
      "net.ipv4.conf.all.rp_filter" = 0;
    };
  };

  users.users.root = {
    openssh.authorizedKeys.keys = [
      share.office.user.public-key
    ];
  };

  networking = {
    hostName = "mail";
    nat = {
      enable = true;
      enableIPv6 = true;
      externalInterface = "ens5";
      internalInterfaces = [ "wg_office" ];
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [
        53
        80 # ui
        88 # kerberos
        179
        389
        443
        636
        8000
      ];
      allowedUDPPorts = [
        53 # dns
        80
        88 # kerberos
        179 # bird2
        389 # ldap
        636 # ldaps
        22616
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
      interfaces = {
        wg_office = {
          privateKeyFile = config.age.secrets.tc_wg_pk.path;
          address = [ "172.22.240.97/27" "fe80::100/64" "fd48:4b4:f3::1/48" ];
          listenPort = 22616;
          table = "off";
          peers = [{
            publicKey = share.office.wg.public-key;
            allowedIPs =
              [ "172.22.240.98/32" "fe80::101/128" "fd48:4b4:f3::2/128" ];
          }];
        };
        wg_theresa = {
          privateKeyFile = config.age.secrets.tc_wg_pk.path;
          address = [ "172.22.240.97/27" "fe80::100/64" ];
          listenPort = 23396;
          table = "off";
          peers = [{
            endpoint = "cn2.dn42.theresa.cafe:22616";
            publicKey = "MqKkzCwYfOg8Fc/pRRctLW3jS72ACBDQr8ZF10sZ614=";
            allowedIPs = [
              "10.0.0.0/8"
              "172.20.0.0/14"
              "172.31.0.0/16"
              "fd00::/8"
              "fe80::/64"
            ];
          }];
        };
        wg_potat0 = {
          privateKeyFile = config.age.secrets.tc_wg_pk.path;
          address = [ "172.22.240.97/27" "fe80::100/64" ];
          listenPort = 21816;
          table = "off";
          peers = [{
            endpoint = "us1.dn42.potat0.cc:22616";
            publicKey = "LUwqKS6QrCPv510Pwt1eAIiHACYDsbMjrkrbGTJfviU=";
            allowedIPs = [
              "10.0.0.0/8"
              "172.20.0.0/14"
              "172.31.0.0/16"
              "fd00::/8"
              "fe80::/64"
            ];
          }];
        };
        wg_tech9 = {
          privateKeyFile = config.age.secrets.tc_wg_pk.path;
          address = [ "172.22.240.97/27" "fe80::100/64" ];
          listenPort = 21588;
          table = "off";
          peers = [{
            endpoint = "sg-sin01.dn42.tech9.io:52507";
            publicKey = "4qLIJ9zpc/Xgvy+uo90rGso75cSrT2F5tBEv+6aqDkY=";
            allowedIPs = [
              "10.0.0.0/8"
              "172.20.0.0/14"
              "172.31.0.0/16"
              "fd00::/8"
              "fe80::/64"
            ];
          }];
        };
      };
    };
  };

  systemd = {
    timers = {
      dn42-roa = {
        description = "Trigger a ROA table update";

        timerConfig = {
          OnBootSec = "5m";
          OnUnitInactiveSec = "1h";
          Unit = "dn42-roa.service";
        };

        wantedBy = [ "timers.target" ];
        before = [ "bird2.service" ];
      };
    };
    services = {
      dn42-roa = {
        after = [ "network.target" ];
        description = "DN42 ROA Updated";
        unitConfig = { Type = "one-shot"; };
        serviceConfig = { ExecStart = "${script}/bin/update-roa"; };
      };

      dns-rfc2136-conf = {
        requiredBy = [ "acme-inner.${domain}.service" "bind.service" ];
        before = [ "acme-inner.${domain}.service" "bind.service" ];
        unitConfig = {
          ConditionPathExists = "!/var/lib/secrets/dnskeys.conf";
        };
        serviceConfig = {
          Type = "oneshot";
          UMask = 0077;
        };
        path = [ pkgs.bind pkgs.gnused ];
        script = ''
          mkdir -p /var/lib/secrets
          chown named:root /var/lib/secrets
          tsig-keygen rfc2136key.inner.${domain} > /var/lib/secrets/dnskeys.conf
          chown named:root /var/lib/secrets/dnskeys.conf

          secret=`sed -n -e 's/secret "\(.*\)";/\1/p' /var/lib/secrets/dnskeys.conf`

          chmod 700 /var/lib/secrets/dnskeys.conf

          # Copy the secret value from the dnskeys.conf, and put it in
          # RFC2136_TSIG_SECRET below

          cat > /var/lib/secrets/certs.secret << EOF
          RFC2136_NAMESERVER='127.0.0.1:53'
          RFC2136_TSIG_ALGORITHM='hmac-sha256.'
          RFC2136_TSIG_KEY='rfc2136key.inner.${domain}'
          RFC2136_TSIG_SECRET="''${secret:1}"
          EOF
          chmod 400 /var/lib/secrets/certs.secret
        '';
      };
    };
  };

  services = {
    tat-agent = {
      enable = false;
    };
    kerberos_server = {
      enable = true;
      realms = {
        "FREEMAN.ENGINEER" = {
          acl =
            [
              {
                access = "all";
                principal = "*/admin";
              }
              {
                access = "all";
                principal = "admin";
              }
            ];
        };
      };
    };

    bind = {
      enable = true;
      extraConfig = ''
        include "/var/lib/secrets/dnskeys.conf";

        zone "dn42" {
          type forward;
          forwarders { 172.20.0.53; fd42:d42:d42:54::1; };
        };
        zone "20.172.in-addr.arpa" {
          type forward;
          forwarders { 172.20.0.53; fd42:d42:d42:54::1; };
        };
        zone "21.172.in-addr.arpa" {
          type forward;
          forwarders { 172.20.0.53; fd42:d42:d42:54::1; };
        };
        zone "22.172.in-addr.arpa" {
          type forward;
          forwarders { 172.20.0.53; fd42:d42:d42:54::1; };
        };
        zone "23.172.in-addr.arpa" {
          type forward;
          forwarders { 172.20.0.53; fd42:d42:d42:54::1; };
        };
        zone "10.in-addr.arpa" {
          type forward;
          forwarders { 172.20.0.53; fd42:d42:d42:54::1; };
        };
        zone "d.f.ip6.arpa" {
          type forward;
          forwarders { 172.20.0.53; fd42:d42:d42:54::1; };
        };
      '';

      cacheNetworks = [
        "0.0.0.0/0"
        "203.117.163.130/32"
        "127.0.0.0/24"
        "10.0.0.0/8"
        "172.20.0.0/14"
        "172.31.0.0/16"
        "fd00::/8"
        "fe80::/64"
      ];
      zones = [
        rec{
          name = "inner.${domain}";
          master = true;
          file = "/var/db/bind/${name}";
          extraConfig = "allow-update { key rfc2136key.inner.${domain}.; };";
        }
        # rec {
        #   name = "66.156.43.in-addr.arpa";
        #   master = true;
        #   file = pkgs.writeText "66.156.43.in-addr.arpa" ''
        #     $TTL 86400
        #     $ORIGIN 66.156.43.in-addr.arpa.
        #     @     IN     SOA    dns1.example.com.     hostmaster.example.com. (
        #                         2001062501 ; serial
        #                         21600      ; refresh after 6 hours
        #                         3600       ; retry after 1 hour
        #                         604800     ; expire after 1 week
        #                         86400 )    ; minimum TTL of 1 day

        #           IN     NS     dns1.example.com.
        #     157   IN     ITR    mail.freeman.engineer.
        #   '';
        # }
      ];
      extraOptions = ''
        empty-zones-enable no;
      '';
    };

    bird2 = {
      enable = true;
      checkConfig = false;
      config = ''
        ################################################
        #               Variable header                #
        ################################################

        define OWNAS =  4242422616;
        define OWNIP =  172.22.240.97;
        define OWNIPv6 = fd48:4b4:f3::1;
        define OWNNET = 172.22.240.96/27;
        define OWNNETv6 = fd48:4b4:f3::/48;
        define OWNNETSET = [172.22.240.96/27+];
        define OWNNETSETv6 = [fd48:4b4:f3::/48+];

        ################################################
        #                 Header end                   #
        ################################################

        router id OWNIP;

        protocol device {
            scan time 10;
        }

        /*
         *  Utility functions
         */

        function is_self_net() {
          return net ~ OWNNETSET;
        }

        function is_self_net_v6() {
          return net ~ OWNNETSETv6;
        }

        function is_valid_network() {
          return net ~ [
            172.20.0.0/14{21,29}, # dn42
            172.20.0.0/24{28,32}, # dn42 Anycast
            172.21.0.0/24{28,32}, # dn42 Anycast
            172.22.0.0/24{28,32}, # dn42 Anycast
            172.23.0.0/24{28,32}, # dn42 Anycast
            172.31.0.0/16+,       # ChaosVPN
            10.100.0.0/14+,       # ChaosVPN
            10.127.0.0/16{16,32}, # neonetwork
            10.0.0.0/8{15,24}     # Freifunk.net
          ];
        }

        roa4 table dn42_roa;
        roa6 table dn42_roa_v6;

        function is_valid_network_v6() {
          return net ~ [
            fd00::/8{44,64} # ULA address space as per RFC 4193
          ];
        }

        protocol kernel {
            scan time 20;

            ipv6 {
                import none;
                export filter {
                    if source = RTS_STATIC then reject;
                    krt_prefsrc = OWNIPv6;
                    accept;
                };
            };
        };

        protocol kernel {
            scan time 20;

            ipv4 {
                import none;
                export filter {
                    if source = RTS_STATIC then reject;
                    krt_prefsrc = OWNIP;
                    accept;
                };
            };
        }

        protocol static {
            route OWNNET reject;

            ipv4 {
                import all;
                export none;
            };
        }

        protocol static {
            route OWNNETv6 reject;

            ipv6 {
                import all;
                export none;
            };
        }

        template bgp dnpeers {
            local as OWNAS;
            path metric 1;

            ipv4 {
                import filter {
                  if is_valid_network() && !is_self_net() then {
                    if (roa_check(dn42_roa, net, bgp_path.last) != ROA_VALID) then {
                      print "[dn42] ROA check failed for ", net, " ASN ", bgp_path.last;
                      reject;
                    } else accept;
                  } else reject;
                };

                export filter { if is_valid_network() && source ~ [RTS_STATIC, RTS_BGP] then accept; else reject; };
                import limit 1000 action block;
            };

            ipv6 {   
                import filter {
                  if is_valid_network_v6() && !is_self_net_v6() then {
                    if (roa_check(dn42_roa_v6, net, bgp_path.last) != ROA_VALID) then {
                      print "[dn42] ROA check failed for ", net, " ASN ", bgp_path.last;
                      reject;
                    } else accept;
                  } else reject;
                };
                export filter { if is_valid_network_v6() && source ~ [RTS_STATIC, RTS_BGP] then accept; else reject; };
                import limit 1000 action block; 
            };
        }
        protocol static {
            roa4 { table dn42_roa; };
            include "/etc/bird/roa_dn42.conf";
        };

        protocol static {
            roa6 { table dn42_roa_v6; };
            include "/etc/bird/roa_dn42_v6.conf";
        };


        protocol bgp dn42_theresa_v6 from dnpeers {
          neighbor fe80::3396%wg_theresa as 4242423396;

          ipv4 {
            extended next hop on;
          };

          direct;
        }

        protocol bgp potat0_v6 from dnpeers {
          neighbor fe80::1816%wg_potat0 as 4242421816;
          ipv4 {
            extended next hop on;
          };

          direct;
        }

        protocol bgp tech9_v6 from dnpeers {
          neighbor fe80::1588%wg_tech9 as 4242421588;
          ipv4 {
            extended next hop on;
          };

          direct;
        }

        protocol bgp ibgp_freeman  {

          local as OWNAS;
          neighbor fd48:4b4:f3::2 as OWNAS;
          direct;

          ipv4 {
              next hop self;
              # Optional cost, e.g. based off latency
              cost 50;

              import all;
              export all;
          };

          ipv6 {
              next hop self;
              cost 50;

              import all;
              export all;
          };
        }

      '';
    };
    bird-lg = {
      package = pkgs.symlinkJoin {
        name = "bird-lg";
        paths = with pkgs; [ bird-lg-go bird-lgproxy-go ];
      };
      proxy = {
        enable = true;
        birdSocket = "/var/run/bird/bird.ctl";
        listenAddress = "0.0.0.0:8000";
        allowedIPs = [ "127.0.0.1" "43.156.66.157" "14.100.28.225" ];
      };
      frontend = {
        domain = "inner." + domain;
        enable = true;
        netSpecificMode = "dn42";
        servers = [ "sg1" ];
        nameFilter = "^ospf";
        protocolFilter = [ "bgp" "ospf" "static" ];
        whois = "whois.burble.dn42";
        # titleBrand = "Freeman dn42 bird-lg";
        dnsInterface = "asn.lantian.dn42";
        navbar = {
          # brand = "Freeman dn42 bird-lg";
        };
      };
    };
    gitweb = {
      projectroot = "/tmp/test";
      gitwebTheme = true;
    };

    nginx = {
      enable = true;
      gitweb = { enable = true; };
      additionalModules = [ pkgs.nginxModules.pam ];

      virtualHosts = {
        bird-lg = {
          serverName = "bird-lg.inner.${domain}";
          addSSL = true;
          acmeRoot = null;
          useACMEHost = "inner.${domain}";
          kTLS = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:5000";
            proxyWebsockets = true;
          };
          extraConfig = ''
            auth_pam  "Password Required";
            auth_pam_service_name "nginx";
          '';
        };
        grafana = {
          serverName = "grafana.inner.${domain}";
          addSSL = true;
          acmeRoot = null;
          useACMEHost = "inner.${domain}";
          kTLS = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:8000";
            proxyWebsockets = true;
          };
        };
      };
    };
  };
  security.pam.services.nginx.setEnvironment = false;
  systemd.services.nginx.serviceConfig = {
    SupplementaryGroups = [ "shadow" ];
    NoNewPrivileges = lib.mkForce false;
    PrivateDevices = lib.mkForce false;
    ProtectHostname = lib.mkForce false;
    ProtectKernelTunables = lib.mkForce false;
    ProtectKernelModules = lib.mkForce false;
    RestrictAddressFamilies = lib.mkForce [ ];
    LockPersonality = lib.mkForce false;
    MemoryDenyWriteExecute = lib.mkForce false;
    RestrictRealtime = lib.mkForce false;
    RestrictSUIDSGID = lib.mkForce false;
    SystemCallArchitectures = lib.mkForce "";
    ProtectClock = lib.mkForce false;
    ProtectKernelLogs = lib.mkForce false;
    RestrictNamespaces = lib.mkForce false;
    SystemCallFilter = lib.mkForce "";
  };
  security = {
    acme = {
      acceptTerms = true;
      defaults = {
        email = "xiongchenyu6@gmail.cam";
        # postRun = ''
        #   ${pkgs.systemd}/bin/systemctl restart openldap
        # '';
      };
      certs = {
        "${domain}" = {
          domain = "${domain}";
          dnsProvider = "namedotcom";
          credentialsFile = config.age.secrets.acme_credentials.path;
          # We don't need to wait for propagation since this is a local DNS server
          dnsPropagationCheck = false;
          reloadServices = [ "openldap" ];
          group = "openldap";
        };
        "inner.${domain}" = {
          domain = "*.inner.${domain}";
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
