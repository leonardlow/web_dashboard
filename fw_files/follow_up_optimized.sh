#!/bin/bash
set -e

### --------------------------------------------
### follow_up.sh - NIISD Deployment Script
### Updated: 2025-05-16
### Author: LL
### --------------------------------------------

niisd_dir="/home/admin/niisd"
logFile="$niisd_dir/runlog"
linebrk="************************"

log() {
  echo "$1" | tee -a "$logFile"
}

log_date() {
  echo "$(date)" >> "$logFile"
  echo "$linebrk" >> "$logFile"
}

copy_and_chmod() {
  cp "$1" "$2"
  chmod 777 "$2"
  log "$2 copied and permissions set"
}

### Start Logging
touch "$logFile"
log_date

### Detect Model
model=$(clish -c 'show asset all' | grep Check | awk '{print $4}')
log "Detected model: $model"

### Find Registry Files
reg=$(find / -name ckp_regedit)
loc=$(find / -name HKLM_registry.data)

### Copy tools to /home/admin
copy_and_chmod fw_health_check.sh /home/admin/fw_health_check.sh
copy_and_chmod hpna_checks /home/admin/hpna_checks
copy_and_chmod gw_chk.sh /home/admin/gw_chk.sh

### Backup and copy system files
cp /etc/security/pam_env.conf /etc/security/pam_env.conf.bak
cp pam_env.conf /etc/security/

cp /etc/profile /etc/profile.bak
cp profile /etc/

cp /etc/sudoers /etc/sudoers.bak
cp sudoers /etc/

cp ~/.bashrc ~/.bashrc.bak
cp bashrc ~/.bashrc

copy_and_chmod cli.sh /home/admin/cli.sh

### Load Gateway Config (if exists)
cfg=$(ls $niisd_dir/gateway*.txt 2>/dev/null | head -n 1)
if [ -f "$cfg" ]; then
  clish -f "$cfg"
  log "Loaded configuration from $cfg"
else
  log "❗ No gateway config file found in $niisd_dir"
fi

log "Deployment completed"
