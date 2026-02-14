{ config, pkgs, ... }:

let
  envFile = "/home/hddq/nixos-config/.env";
  credsFile = "/run/keys/smb-vaults";
in
{
  environment.systemPackages = [ pkgs.cifs-utils ];

  systemd.services.prepare-smb-creds = {
    description = "Prepare SMB credentials from .env";
    before = [ "home-hddq-vaults.mount" "remote-fs.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      mkdir -p /run/keys
      # Extract values from .env
      USERNAME=$(grep '^SMB_USER=' ${envFile} | cut -d'=' -f2-)
      PASSWORD=$(grep '^SMB_PASS=' ${envFile} | cut -d'=' -f2-)
      
      cat > ${credsFile} <<EOF
username=$USERNAME
password=$PASSWORD
EOF
      chmod 600 ${credsFile}
    '';
  };

  fileSystems."/home/hddq/nas" = {
    device = "//192.168.20.12/hddq";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in [ "${automount_opts},credentials=${credsFile},uid=1000,gid=100" ];
  };
}
