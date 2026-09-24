# cloud-init

This directory contains the version-controlled cloud-init configuration used to provision the Raspberry Pi after the initial Raspberry Pi Imager configuration.

The Raspberry Pi Imager performs the initial configuration (hostname, user, Wi-Fi, SSH, etc.). This procedure then replaces the Imager user-data with the version-controlled provisioning configuration and starts a new cloud-init instance.

## 1. Back up the initial Pi Imager cloud-init configuration

The Raspberry Pi Imager stores its NoCloud configuration under /boot/firmware.

Create a backup:

```bash
sudo mkdir -p /root/cloud-init-backup

sudo cp /boot/firmware/user-data \
    /root/cloud-init-backup/user-data

sudo cp /boot/firmware/meta-data \
    /root/cloud-init-backup/meta-data

sudo cp /boot/firmware/network-config \
    /root/cloud-init-backup/network-config
```

Verify the backup:

```bash
sudo ls -la /root/cloud-init-backup
```

The backup should contain:

```bash
user-data
meta-data
network-config
```

## 2. Validate the version-controlled configuration

From the repository root:

```
sudo cloud-init schema --config-file cloud-init/user-data
```

The command should report that the configuration is valid.

Do not continue if schema validation fails.

## 3. Replace the Raspberry Pi Imager user-data

Copy the version-controlled configuration into the active NoCloud seed:

```bash
sudo cp cloud-init/user-data /boot/firmware/user-data
```

Verify:

```
sudo head -20 /boot/firmware/user-data
```

The file should match the version-controlled [cloud-init/user-data](./user-data).

## 4. Create a new cloud-init instance ID

The original Raspberry Pi Imager instance ID must not be reused.

First inspect the existing metadata:

```bash
sudo cat /boot/firmware/meta-data
```

Then create a new instance ID:

```bash
sudo tee /boot/firmware/meta-data >/dev/null <<'EOF'
instance-id: raspberry-pi-squiggles-001
local-hostname: collective
EOF
```

Use a new, unique instance ID whenever this provisioning configuration represents a new cloud-init instance.

The existing network-config is retained.

## 5. Clean the previous cloud-init state

After the original Imager configuration has completed and the new user-data and meta-data are in place:

```bash
sudo cloud-init clean --logs
```

This removes the previous cloud-init instance state so the next boot can process the new instance configuration.

It does not reinstall the operating system or remove the existing user.

## 6. Reboot

```bash
sudo reboot
```

After reboot, reconnect using SSH:

```bash
ssh collective@192.168.?.?
```

## 7. Verify cloud-init

Check the status:

```bash
cloud-init status --long
```

The final status should be:

```bash
status: done
```

Inspect the execution timeline:

```bash
sudo cloud-init analyze show
```

Check the cloud-init output log if something failed:

```bash
sudo less /var/log/cloud-init-output.log
```

For more detailed debugging:

```bash
sudo less /var/log/cloud-init.log
```

## 8. Verify SSH hardening

The provisioning configuration disables SSH password authentication while retaining public-key authentication.

Check the effective configuration:

```bash
sudo sshd -T | grep -E \
'permitrootlogin|passwordauthentication|kbdinteractiveauthentication|pubkeyauthentication|allowtcpforwarding'
```

Expected:

```bash
permitrootlogin no
pubkeyauthentication yes
passwordauthentication no
kbdinteractiveauthentication no
allowtcpforwarding yes
```

## 9. Verify installed services

Check Docker:

```bash
systemctl is-active docker
docker --version
```

Check Bluetooth:

```bash
systemctl is-active bluetooth
bluetoothctl show
```

Check automatic updates:

```bash
systemctl is-active unattended-upgrades
```

Check XScreenSaver:

```bash
dpkg -l | grep xscreensaver
```

For the Wayland desktop, verify the XScreenSaver daemon:

```bash
pgrep -a xscreensaver
```

The idle command configured in the desktop's Power Management settings should be:

```bash
xscreensaver-command -activate
```
