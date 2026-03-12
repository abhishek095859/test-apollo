#!/bin/bash
set -e
set -x

#########################################
# DOCKER INSTALL
#########################################

sudo yum update -y
sudo yum install -y docker

sudo systemctl start docker
sudo systemctl enable docker

#########################################
# SNMP HARDENING
#########################################

echo "Installing SNMP packages..."

sudo dnf install -y net-snmp net-snmp-utils net-snmp-perl

sudo systemctl stop snmpd || true

# Create SNMP v3 user
sudo net-snmp-create-v3-user -ro -a SHA -A snmpuser135 -x AES -X snmpuser135 snmpuser || true

# Backup existing config
sudo cp /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf.bkp || true

# Comment default systemview
sudo sed -i '/^view systemview/s/^/#/' /etc/snmp/snmpd.conf

# Add secure configuration
sudo tee -a /etc/snmp/snmpd.conf <<EOF
agentAddress udp:0.0.0.0:161,udp6:[::]:161
createUser snmpuser SHA "snmpuser135" AES "snmpuser135"
rouser snmpuser authpriv .1
view systemview included .1.3.6.1.2.1.25
view systemview included .1.3.6.1.4.1.2021
EOF

# SNMP client configuration
sudo tee /etc/snmp/snmp.conf <<EOF
mibs +ALL
mibdirs /usr/share/snmp/mibs:/var/lib/mibs/iana:/var/lib/mibs/ietf
EOF

sudo systemctl enable snmpd
sudo systemctl restart snmpd

#########################################
# DNS HARDENING
#########################################

sudo tee /etc/resolv.conf <<EOF
nameserver 10.99.0.162
nameserver 172.19.0.127
EOF

#########################################
# CLOUDWATCH AGENT
#########################################

echo "Installing CloudWatch Agent..."

sudo yum install -y -q amazon-cloudwatch-agent || true

echo "CloudWatch package install completed"

sudo mkdir -p /opt/aws/amazon-cloudwatch-agent/etc

sudo tee /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<EOF
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
EOF

echo "CloudWatch config created"
 
echo "completed all..."
 
