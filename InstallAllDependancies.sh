#!/bin/bash
# Script d'installation complet pour le TP INF 361

set -e

echo "=== INSTALLATION COMPLÈTE TP INF 361 ==="
echo "========================================"

# Fonction de log
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Mise à jour système
log "Mise à jour du système..."
sudo apt-get update
sudo apt-get upgrade -y

# Outils de base
log "Installation des outils de base..."
sudo apt-get install -y curl wget git vim nano htop tree unzip

# Partie 1: Dépendances Bash
log "Installation des dépendances Partie 1 (Bash)..."
sudo apt-get install -y quota quotatool libpam-modules shadow-utils
sudo apt-get install -y zsh fish tcsh ksh
sudo apt-get install -y libcrack2 cracklib-runtime

# Configuration quotas
log "Configuration des quotas..."
if grep -q "/home" /etc/fstab; then
    sudo sed -i '/\/home.*ext4/s/defaults/defaults,usrquota/' /etc/fstab
    sudo mount -o remount /home
    sudo quotacheck -cum /home
    sudo quotaon -av
fi

# Partie 2: Ansible
log "Installation d'Ansible..."
sudo apt-get install -y software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt-get install -y ansible python3-pip python3-paramiko

# Modules Python pour Ansible
log "Installation des modules Python..."
sudo pip3 install paramiko jmespath netaddr bcrypt passlib jinja2 pyyaml cryptography

# Collections Ansible
log "Installation des collections Ansible..."
ansible-galaxy collection install community.general ansible.posix community.crypto

# SMTP pour emails
log "Installation des outils SMTP..."
sudo apt-get install -y msmtp msmtp-mta mailutils

# Partie 3: Terraform
log "Installation de Terraform..."
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update
sudo apt-get install -y terraform

# Outils de monitoring
log "Installation des outils de monitoring..."
sudo apt-get install -y inotify-tools lsof strace sysstat

# Vérifications finales
log "Vérification des installations..."
which quota && echo "✓ quota installé"
which ansible && echo "✓ ansible installé"
which terraform && echo "✓ terraform installé"
python3 -c "import paramiko; import yaml; print('✓ Modules Python installés')"

echo ""
echo "========================================"
echo "=== INSTALLATION TERMINÉE AVEC SUCCÈS ==="
echo "========================================"
echo ""
echo "Résumé des outils installés:"
echo "1. Quotas système       : ✓"
echo "2. Ansible              : ✓"
echo "3. Terraform            : ✓"
echo "4. Outils de monitoring : ✓"
echo ""
echo "Pour tester:"
echo "  - Quotas: sudo quota -v"
echo "  - Ansible: ansible --version"
echo "  - Terraform: terraform version"
