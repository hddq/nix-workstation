{pkgs, ...}: let
  envFile = "/home/hddq/nixos-config/.env";
  credsFile = "/run/keys/smb-vaults";
  automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
in {
  environment.systemPackages = with pkgs; [
    cifs-utils
    nfs-utils
  ];

  systemd.services.prepare-smb-creds = {
    description = "Prepare SMB credentials from .env";
    before = ["home-hddq-vaults.mount" "remote-fs.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''      # bash
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
    options = ["${automount_opts},credentials=${credsFile},uid=1000,gid=100"];
  };

  fileSystems."/home/hddq/media" = {
    device = "192.168.20.12:/mnt/ssd1/media";
    fsType = "nfs";
    options = [automount_opts];
  };
}
