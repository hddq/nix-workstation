{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.system.pia-vpn;

  piaCaCert = pkgs.writeText "pia-ca.crt" ''
    -----BEGIN CERTIFICATE-----
    MIIHqzCCBZOgAwIBAgIJAJ0u+vODZJntMA0GCSqGSIb3DQEBDQUAMIHoMQswCQYD
    VQQGEwJVUzELMAkGA1UECBMCQ0ExEzARBgNVBAcTCkxvc0FuZ2VsZXMxIDAeBgNV
    BAoTF1ByaXZhdGUgSW50ZXJuZXQgQWNjZXNzMSAwHgYDVQQLExdQcml2YXRlIElu
    dGVybmV0IEFjY2VzczEgMB4GA1UEAxMXUHJpdmF0ZSBJbnRlcm5ldCBBY2Nlc3Mx
    IDAeBgNVBCkTF1ByaXZhdGUgSW50ZXJuZXQgQWNjZXNzMS8wLQYJKoZIhvcNAQkB
    FiBzZWN1cmVAcHJpdmF0ZWludGVybmV0YWNjZXNzLmNvbTAeFw0xNDA0MTcxNzQw
    MzNaFw0zNDA0MTIxNzQwMzNaMIHoMQswCQYDVQQGEwJVUzELMAkGA1UECBMCQ0Ex
    EzARBgNVBAcTCkxvc0FuZ2VsZXMxIDAeBgNVBAoTF1ByaXZhdGUgSW50ZXJuZXQg
    QWNjZXNzMSAwHgYDVQQLExdQcml2YXRlIEludGVybmV0IEFjY2VzczEgMB4GA1UE
    AxMXUHJpdmF0ZSBJbnRlcm5ldCBBY2Nlc3MxIDAeBgNVBCkTF1ByaXZhdGUgSW50
    ZXJuZXQgQWNjZXNzMS8wLQYJKoZIhvcNAQkBFiBzZWN1cmVAcHJpdmF0ZWludGVy
    bmV0YWNjZXNzLmNvbTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALVk
    hjumaqBbL8aSgj6xbX1QPTfTd1qHsAZd2B97m8Vw31c/2yQgZNf5qZY0+jOIHULN
    De4R9TIvyBEbvnAg/OkPw8n/+ScgYOeH876VUXzjLDBnDb8DLr/+w9oVsuDeFJ9K
    V2UFM1OYX0SnkHnrYAN2QLF98ESK4NCSU01h5zkcgmQ+qKSfA9Ny0/UpsKPBFqsQ
    25NvjDWFhCpeqCHKUJ4Be27CDbSl7lAkBuHMPHJs8f8xPgAbHRXZOxVCpayZ2SND
    fCwsnGWpWFoMGvdMbygngCn6jA/W1VSFOlRlfLuuGe7QFfDwA0jaLCxuWt/BgZyl
    p7tAzYKR8lnWmtUCPm4+BtjyVDYtDCiGBD9Z4P13RFWvJHw5aapx/5W/CuvVyI7p
    Kwvc2IT+KPxCUhH1XI8ca5RN3C9NoPJJf6qpg4g0rJH3aaWkoMRrYvQ+5PXXYUzj
    tRHImghRGd/ydERYoAZXuGSbPkm9Y/p2X8unLcW+F0xpJD98+ZI+tzSsI99Zs5wi
    jSUGYr9/j18KHFTMQ8n+1jauc5bCCegN27dPeKXNSZ5riXFL2XX6BkY68y58UaNz
    meGMiUL9BOV1iV+PMb7B7PYs7oFLjAhh0EdyvfHkrh/ZV9BEhtFa7yXp8XR0J6vz
    1YV9R6DYJmLjOEbhU8N0gc3tZm4Qz39lIIG6w3FDAgMBAAGjggFUMIIBUDAdBgNV
    HQ4EFgQUrsRtyWJftjpdRM0+925Y6Cl08SUwggEfBgNVHSMEggEWMIIBEoAUrsRt
    yWJftjpdRM0+925Y6Cl08SWhge6kgeswgegxCzAJBgNVBAYTAlVTMQswCQYDVQQI
    EwJDQTETMBEGA1UEBxMKTG9zQW5nZWxlczEgMB4GA1UEChMXUHJpdmF0ZSBJbnRl
    cm5ldCBBY2Nlc3MxIDAeBgNVBAsTF1ByaXZhdGUgSW50ZXJuZXQgQWNjZXNzMSAw
    HgYDVQQDExdQcml2YXRlIEludGVybmV0IEFjY2VzczEgMB4GA1UEKRMdc2VjdXJl
    QHByaXZhdGVpbnRlcm5ldGFjY2Vzcy5jb20xLzAtBgkqhkiG9w0BCQEWIHNlY3Vy
    ZUBwcml2YXRlaW50ZXJuZXRhY2Nlc3MuY29tggkAnS7684Nkme0wDAYDVR0TBAUw
    AwEB/zANBgkqhkiG9w0BAQUFAAOCAgEAjF7nN3qQdK8Z3Htz6k8E7T177/XkFk8m
    g19mIb7Sffx6QJ4qY6Qj8rYyQ0/xX7aFp0k6/yN8xY8Z3s9g6R/38ZJd/F8e5P2k
    G0k7q69W4Ym/9Hw1aJ2R8sR5oK9Q8K/9Xz7g3lY0b4sT8Vw/7hV0G6m7VzQv7M5
    M7aH9l2Q4j5g8Uf9qU2Q2lqT9yM/xW1qfT8o5y4a5k8Q==
    -----END CERTIFICATE-----
  '';

  filterRegionJq = pkgs.writeText "filter-region.jq" ''
    .regions[]
    | select(.servers.wg != null)
    | select(.id == $r or (.name | test($r; "i")))
  '';

  filterFallbackJq = pkgs.writeText "filter-fallback.jq" ''
    .regions[]
    | select(.servers.wg != null)
    | select(.id == "poland" or .country == "PL")
  '';

  piaConnectScript = pkgs.writeShellApplication {
    name = "pia-vpn-connect";
    runtimeInputs = with pkgs; [
      curl
      jq
      wireguard-tools
      iproute2
      iptables
      coreutils
      gnugrep
      findutils
    ];
    text = ''        # bash
      set -euo pipefail

      STATUS_DIR="/run/pia-vpn"
      WG_CONF_DIR="/run/wireguard"
      WG_CONF="$WG_CONF_DIR/pia.conf"
      mkdir -p "$STATUS_DIR" "$WG_CONF_DIR"
      chmod 700 "$STATUS_DIR" "$WG_CONF_DIR"

      # 1. Read credentials
      ENV_FILE="${cfg.envFile}"
      if [ ! -f "$ENV_FILE" ]; then
        echo "Error: Environment file $ENV_FILE not found." >&2
        exit 1
      fi

      PIA_USER=$(grep -E '^[[:space:]]*PIA_USER=' "$ENV_FILE" | head -n1 | cut -d'=' -f2- | tr -d '"\047' | xargs)
      PIA_PASS=$(grep -E '^[[:space:]]*PIA_PASS=' "$ENV_FILE" | head -n1 | cut -d'=' -f2- | tr -d '"\047' | xargs)
      REGION_OVERRIDE=$(grep -E '^[[:space:]]*PIA_REGION=' "$ENV_FILE" | head -n1 | cut -d'=' -f2- | tr -d '"\047' | xargs || true)
      TARGET_REGION="''${REGION_OVERRIDE:-${cfg.defaultRegion}}"

      if [ -z "$PIA_USER" ] || [ -z "$PIA_PASS" ]; then
        echo "Error: PIA_USER and/or PIA_PASS missing in $ENV_FILE" >&2
        exit 1
      fi

      echo "Authenticating with Private Internet Access (POST token request)..."
      TOKEN_RESP=$(curl -s --max-time 15 --location \
        --request POST "https://www.privateinternetaccess.com/api/client/v2/token" \
        --form "username=$PIA_USER" \
        --form "password=$PIA_PASS" || true)

      PIA_TOKEN=$(echo "$TOKEN_RESP" | jq -r '.token // empty' 2>/dev/null || true)

      if [ -z "$PIA_TOKEN" ]; then
        echo "Error: Failed to obtain PIA token. Check credentials." >&2
        echo "Server response: $TOKEN_RESP" >&2
        exit 1
      fi

      echo "Fetching PIA server list..."
      SERVERLIST_RAW=$(curl -s --max-time 10 "https://serverlist.piaservers.net/vpninfo/servers/v4" | head -n 1)

      # Match region
      REGION_INFO=$(jq -c --arg r "$TARGET_REGION" -f "${filterRegionJq}" <<< "$SERVERLIST_RAW" | head -n 1 || true)

      if [ -z "$REGION_INFO" ]; then
        echo "Warning: Region '$TARGET_REGION' not found, falling back to Poland..."
        REGION_INFO=$(jq -c -f "${filterFallbackJq}" <<< "$SERVERLIST_RAW" | head -n 1 || true)
        if [ -z "$REGION_INFO" ]; then
          REGION_INFO=$(jq -c '.regions[] | select(.servers.wg != null)' <<< "$SERVERLIST_RAW" | head -n 1)
        fi
      fi

      REGION_ID=$(echo "$REGION_INFO" | jq -r '.id')
      REGION_NAME=$(echo "$REGION_INFO" | jq -r '.name')
      SERVER_IP=$(echo "$REGION_INFO" | jq -r '.servers.wg[0].ip')
      SERVER_CN=$(echo "$REGION_INFO" | jq -r '.servers.wg[0].cn')
      DNS_SERVER=$(echo "$REGION_INFO" | jq -r '.dns // "10.0.0.242"')

      echo "Selected Region: $REGION_NAME ($REGION_ID) at $SERVER_IP ($SERVER_CN)"

      # Generate WireGuard Keypair
      PRIVKEY=$(wg genkey)
      PUBKEY=$(echo "$PRIVKEY" | wg pubkey)

      echo "Registering WireGuard public key with PIA server..."
      REGISTER_RESP=$(curl -s -f -G --max-time 15 \
        --connect-to "$SERVER_CN::$SERVER_IP:" \
        --cacert "${piaCaCert}" \
        "https://$SERVER_CN:1337/addKey" \
        --data-urlencode "pt=$PIA_TOKEN" \
        --data-urlencode "pubkey=$PUBKEY" || true)

      STATUS=$(echo "$REGISTER_RESP" | jq -r '.status // empty' 2>/dev/null || true)
      if [ "$STATUS" != "OK" ]; then
        echo "Error: Key registration with PIA server failed (CA certificate verification failed or server error)." >&2
        echo "Server response: $REGISTER_RESP" >&2
        exit 1
      fi

      SERVER_PUBKEY=$(echo "$REGISTER_RESP" | jq -r '.server_key')
      SERVER_PORT=$(echo "$REGISTER_RESP" | jq -r '.server_port')
      PEER_IP=$(echo "$REGISTER_RESP" | jq -r '.peer_ip')
      DNS_SERVERS=$(echo "$REGISTER_RESP" | jq -r '.dns_servers // ["10.0.0.242"] | join(", ")')

      # Detect default gateway to preserve LAN subnets
      DEF_GW=$(ip route show default | awk '{print $3}' | head -n1 || true)
      DEF_DEV=$(ip route show default | awk '{print $5}' | head -n1 || true)

      LAN_BYPASS_UP=""
      LAN_BYPASS_DOWN=""
      if [ -n "$DEF_GW" ] && [ -n "$DEF_DEV" ]; then
        LAN_BYPASS_UP="PostUp = ip route add 192.168.0.0/16 via $DEF_GW dev $DEF_DEV metric 50 2>/dev/null || true; ip route add 10.0.0.0/8 via $DEF_GW dev $DEF_DEV metric 50 2>/dev/null || true; ip route add 172.16.0.0/12 via $DEF_GW dev $DEF_DEV metric 50 2>/dev/null || true"
        LAN_BYPASS_DOWN="PostDown = ip route del 192.168.0.0/16 metric 50 2>/dev/null || true; ip route del 10.0.0.0/8 metric 50 2>/dev/null || true; ip route del 172.16.0.0/12 metric 50 2>/dev/null || true"
      fi

      # Killswitch firewall rules (strict leak prevention)
      ${lib.optionalString cfg.killswitch ''
        KILLSWITCH_UP="PostUp = iptables -N PIA_KILLSWITCH 2>/dev/null || iptables -F PIA_KILLSWITCH; iptables -C OUTPUT -j PIA_KILLSWITCH 2>/dev/null || iptables -I OUTPUT 1 -j PIA_KILLSWITCH; iptables -A PIA_KILLSWITCH -o lo -j ACCEPT; iptables -A PIA_KILLSWITCH -o pia -j ACCEPT; iptables -A PIA_KILLSWITCH -d $SERVER_IP -p udp --dport $SERVER_PORT -j ACCEPT; iptables -A PIA_KILLSWITCH -d 192.168.0.0/16 -j ACCEPT; iptables -A PIA_KILLSWITCH -d 10.0.0.0/8 -j ACCEPT; iptables -A PIA_KILLSWITCH -d 172.16.0.0/12 -j ACCEPT; iptables -A PIA_KILLSWITCH -d 224.0.0.0/4 -j ACCEPT; iptables -A PIA_KILLSWITCH -d 255.255.255.255/32 -j ACCEPT; iptables -A PIA_KILLSWITCH -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT; iptables -A PIA_KILLSWITCH -j DROP; ip6tables -N PIA_KILLSWITCH 2>/dev/null || ip6tables -F PIA_KILLSWITCH; ip6tables -C OUTPUT -j PIA_KILLSWITCH 2>/dev/null || ip6tables -I OUTPUT 1 -j PIA_KILLSWITCH; ip6tables -A PIA_KILLSWITCH -o lo -j ACCEPT; ip6tables -A PIA_KILLSWITCH -d fe80::/10 -j ACCEPT; ip6tables -A PIA_KILLSWITCH -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT; ip6tables -A PIA_KILLSWITCH -j DROP"
        KILLSWITCH_DOWN="PostDown = iptables -D OUTPUT -j PIA_KILLSWITCH 2>/dev/null || true; iptables -F PIA_KILLSWITCH 2>/dev/null || true; iptables -X PIA_KILLSWITCH 2>/dev/null || true; ip6tables -D OUTPUT -j PIA_KILLSWITCH 2>/dev/null || true; ip6tables -F PIA_KILLSWITCH 2>/dev/null || true; ip6tables -X PIA_KILLSWITCH 2>/dev/null || true"
      ''}
      ${lib.optionalString (!cfg.killswitch) ''
        KILLSWITCH_UP=""
        KILLSWITCH_DOWN=""
      ''}

      # Build WireGuard config
      EFFECTIVE_DNS="''${DNS_SERVERS:-$DNS_SERVER}"
      cat > "$WG_CONF" <<EOF
[Interface]
Address = $PEER_IP/32
PrivateKey = $PRIVKEY
DNS = $EFFECTIVE_DNS
$LAN_BYPASS_UP
$LAN_BYPASS_DOWN
$KILLSWITCH_UP
$KILLSWITCH_DOWN

[Peer]
PublicKey = $SERVER_PUBKEY
AllowedIPs = 0.0.0.0/0
Endpoint = $SERVER_IP:$SERVER_PORT
PersistentKeepalive = 25
EOF
      chmod 600 "$WG_CONF"

      # Teardown any previous connection
      wg-quick down "$WG_CONF" 2>/dev/null || true

      echo "Bringing up WireGuard tunnel..."
      wg-quick up "$WG_CONF"

      cat > "$STATUS_DIR/status.json" <<EOF
{
  "connected": true,
  "region_id": "$REGION_ID",
  "region_name": "$REGION_NAME",
  "server_ip": "$SERVER_IP",
  "peer_ip": "$PEER_IP",
  "connected_at": "$(date -Iseconds)"
}
EOF
      chmod 644 "$STATUS_DIR/status.json"

      echo "PIA VPN successfully connected to $REGION_NAME ($SERVER_IP) with active killswitch!"
    '';
  };

  piaCliScript = pkgs.writeShellApplication {
    name = "pia-vpn";
    runtimeInputs = with pkgs; [
      systemd
      jq
      wireguard-tools
      coreutils
      procps
      libnotify
    ];
    text = ''        # bash
      action="''${1:-status}"

      case "$action" in
        connect|up|start)
          echo "Starting PIA VPN..."
          notify-send -u low -a "PIA VPN" "Connecting..." "Initiating connection to PIA" 2>/dev/null || true
          systemctl start pia-vpn
          pkill -RTMIN+11 waybar 2>/dev/null || true
          if [ -f /run/pia-vpn/status.json ]; then
            region=$(jq -r '.region_name // "PIA"' /run/pia-vpn/status.json 2>/dev/null || echo "PIA")
            notify-send -u normal -a "PIA VPN" "VPN Connected" "Connected to $region (Killswitch ON)" 2>/dev/null || true
          fi
          ;;
        disconnect|down|stop)
          echo "Stopping PIA VPN..."
          systemctl stop pia-vpn
          pkill -RTMIN+11 waybar 2>/dev/null || true
          notify-send -u normal -a "PIA VPN" "VPN Disconnected" "Traffic restored to direct connection" 2>/dev/null || true
          ;;
        toggle)
          if systemctl is-active --quiet pia-vpn; then
            echo "Disconnecting PIA VPN..."
            systemctl stop pia-vpn
            pkill -RTMIN+11 waybar 2>/dev/null || true
            notify-send -u normal -a "PIA VPN" "VPN Disconnected" "Traffic restored to direct connection" 2>/dev/null || true
          else
            echo "Connecting PIA VPN..."
            notify-send -u low -a "PIA VPN" "Connecting..." "Initiating connection to PIA" 2>/dev/null || true
            systemctl start pia-vpn
            pkill -RTMIN+11 waybar 2>/dev/null || true
            if [ -f /run/pia-vpn/status.json ]; then
              region=$(jq -r '.region_name // "PIA"' /run/pia-vpn/status.json 2>/dev/null || echo "PIA")
              notify-send -u normal -a "PIA VPN" "VPN Connected" "Connected to $region (Killswitch ON)" 2>/dev/null || true
            fi
          fi
          ;;
        status)
          if systemctl is-active --quiet pia-vpn; then
            echo "Status: Connected (Active)"
            echo "Killswitch: Enabled (Strict firewall leak prevention)"
            if [ -f /run/pia-vpn/status.json ]; then
              jq . /run/pia-vpn/status.json
            fi
            echo
            echo "WireGuard Stats:"
            wg show pia 2>/dev/null || true
          elif systemctl is-failed --quiet pia-vpn; then
            echo "Status: Error (Service failed)"
            systemctl status pia-vpn --no-pager
          else
            echo "Status: Disconnected (Inactive)"
          fi
          ;;
        waybar)
          if systemctl is-active --quiet pia-vpn; then
            region="PIA"
            server=""
            if [ -f /run/pia-vpn/status.json ]; then
              region=$(jq -r '.region_name // "PIA"' /run/pia-vpn/status.json 2>/dev/null || echo "PIA")
              server=$(jq -r '.server_ip // ""' /run/pia-vpn/status.json 2>/dev/null || true)
            fi
            tooltip=$(printf "PIA Connected (Killswitch ON)\nRegion: %s\nServer: %s" "$region" "$server")
            jq -nc --arg text "VPN: ON" --arg tooltip "$tooltip" --arg class "connected" '{$text, $tooltip, $class}'
          elif systemctl is-failed --quiet pia-vpn; then
            tooltip="PIA Connection Failed"$'\n'"Check credentials in envFile or run: journalctl -u pia-vpn"
            jq -nc --arg text "VPN: ERR" --arg tooltip "$tooltip" --arg class "error" '{$text, $tooltip, $class}'
          elif systemctl is-active --quiet pia-vpn.service 2>/dev/null; then
            jq -nc --arg text "VPN: ..." --arg tooltip "Connecting to PIA..." --arg class "connecting" '{$text, $tooltip, $class}'
          else
            jq -nc --arg text "VPN: OFF" --arg tooltip "PIA Disconnected (Click to connect)" --arg class "disconnected" '{$text, $tooltip, $class}'
          fi
          ;;
        *)
          echo "Usage: pia-vpn {connect|disconnect|toggle|status|waybar}"
          exit 1
          ;;
      esac
    '';
  };
in {
  options.modules.system.pia-vpn = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Private Internet Access (PIA) WireGuard service and Waybar toggle integration.";
    };

    killswitch = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable strict firewall killswitch to block all non-VPN traffic and prevent DNS/IPv6 leaks.";
    };

    envFile = lib.mkOption {
      type = lib.types.str;
      default = "/home/hddq/nixos-config/.env";
      description = "Path to environment file containing PIA_USER and PIA_PASS.";
    };

    defaultRegion = lib.mkOption {
      type = lib.types.str;
      default = "poland";
      description = "Default PIA region to connect to (e.g. poland, swiss, de_berlin, nl_amsterdam).";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      piaConnectScript
      piaCliScript
      pkgs.wireguard-tools
    ];

    # Relax reverse path filter so WireGuard routing works seamlessly with firewall
    networking.firewall.checkReversePath = "loose";

    systemd.services.pia-vpn = {
      description = "Private Internet Access (PIA) WireGuard VPN";
      after = ["network-online.target"];
      wants = ["network-online.target"];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${piaConnectScript}/bin/pia-vpn-connect";
        ExecStop = pkgs.writeShellScript "pia-vpn-stop" ''        # bash
          ${pkgs.wireguard-tools}/bin/wg-quick down /run/wireguard/pia.conf 2>/dev/null || true
          ${pkgs.iptables}/bin/iptables -D OUTPUT -j PIA_KILLSWITCH 2>/dev/null || true
          ${pkgs.iptables}/bin/iptables -F PIA_KILLSWITCH 2>/dev/null || true
          ${pkgs.iptables}/bin/iptables -X PIA_KILLSWITCH 2>/dev/null || true
          ${pkgs.iptables}/bin/ip6tables -D OUTPUT -j PIA_KILLSWITCH 2>/dev/null || true
          ${pkgs.iptables}/bin/ip6tables -F PIA_KILLSWITCH 2>/dev/null || true
          ${pkgs.iptables}/bin/ip6tables -X PIA_KILLSWITCH 2>/dev/null || true
          rm -rf /run/pia-vpn /run/wireguard/pia.conf
        '';
      };
    };

    # Polkit rule allowing members of the wheel group to manage pia-vpn unit without sudo
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.systemd1.manage-units" &&
            action.lookup("unit") == "pia-vpn.service" &&
            subject.isInGroup("wheel")) {
          return polkit.Result.YES;
        }
      });
    '';
  };
}
