#!/bin/bash

# Resilience Helper: Tries a command, waits 60s on failure, then skips if it fails again.
run_step() {
    local STEP_NAME="$1"
    local CMD="$2"
    
    echo "----------------------------------------------------"
    echo "STEP: $STEP_NAME"
    if eval "$CMD"; then
        echo "SUCCESS: $STEP_NAME"
    else
        echo "[!] FAIL: $STEP_NAME. Retrying in 60s..."
        sleep 60
        if eval "$CMD"; then
            echo "SUCCESS: $STEP_NAME (on second attempt)"
        else
            echo "[!!!] SKIP: $STEP_NAME failed twice. Moving to next line."
        fi
    fi
}

#########################################
# DOCKER INSTALL
#########################################
run_step "Update and Docker Install" "sudo yum update -y && sudo yum install -y docker"

sudo systemctl start docker
sudo systemctl enable docker

########################################
# Docker Compose Install
########################################
run_step "Docker Compose Setup" "sudo mkdir -p /usr/libexec/docker/cli-plugins && \
sudo curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/libexec/docker/cli-plugins/docker-compose"

sudo chmod +x /usr/libexec/docker/cli-plugins/docker-compose
sudo docker compose version

#########################################
#s3
#########################################
#run_step "S3 Copy Outputs" "aws s3 cp s3://my-terraform-tftate/outputs.tf /home/ec2-user/outputs.tf && chown ec2-user:ec2-user /home/ec2-user/outputs.tf"
run_step "S3 Copy Outputs" "aws s3 cp s3://my-terraform-tftate/outputs.tf /home/ec2-user/outputs.tf --path-style && chown ec2-user:ec2-user /home/ec2-user/outputs.tf"

#########################################
# SNMP HARDENING
#########################################
echo "Installing SNMP packages..."

run_step "SNMP Install" "sudo dnf install -y net-snmp net-snmp-utils net-snmp-perl"

sudo systemctl stop snmpd || true

# Create SNMP v3 user
sudo net-snmp-create-v3-user -ro -a SHA -A snmpuser135 -x AES -X snmpuser135 snmpuser || true

# Backup existing config and comment default systemview
sudo cp /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf.bkp || true
sudo sed -i '/^view systemview/s/^/#/' /etc/snmp/snmpd.conf

# Secure Daemon Configuration
run_step "SNMP Daemon Config" 'sudo tee /etc/snmp/snmpd.conf <<EOF
agentAddress udp:0.0.0.0:161,udp6:[::]:161
createUser snmpuser SHA "snmpuser135" AES "snmpuser135"
rouser snmpuser authpriv .1
view systemview included .1.3.6.1.2.1.25
view systemview included .1.3.6.1.4.1.2021
EOF'

# SNMP client configuration (Added here)
run_step "SNMP Client Config" 'sudo tee /etc/snmp/snmp.conf <<EOF
mibs +ALL
mibdirs /usr/share/snmp/mibs:/var/lib/mibs/iana:/var/lib/mibs/ietf
EOF'

sudo systemctl enable snmpd
sudo systemctl restart snmpd

#########################################
# CLOUDWATCH AGENT
#########################################
run_step "CloudWatch Install" "sudo dnf install -y amazon-cloudwatch-agent"

run_step "CloudWatch Config" 'sudo tee /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<EOF
{
  "metrics": {
    "metrics_collected": {
      "mem": {
        "measurement": ["used_percent"],
        "metrics_collection_interval": 60
      }
    },
    "append_dimensions": {
      "InstanceId": "\${aws:InstanceId}"
    }
  }
}
EOF'

sudo systemctl enable amazon-cloudwatch-agent
sudo systemctl start amazon-cloudwatch-agent
#########################################
# DNS
#########################################

#run_step "DNS Hardening" 'sudo tee /etc/resolv.conf <<EOF
#nameserver 10.99.0.162
#nameserver 172.19.0.127
#EOF'

echo "----------------------------------------------------"
echo "Setup script completed successfully"
