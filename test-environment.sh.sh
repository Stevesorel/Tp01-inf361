#!/bin/bash
echo "=== TEST DE L'ENVIRONNEMENT TP INF 361 ==="

echo "1. Test Partie 1 (Bash)..."
which setquota && echo "  ✓ setquota disponible" || echo "  ✗ setquota manquant"
which useradd && echo "  ✓ useradd disponible" || echo "  ✗ useradd manquant"

echo "2. Test Partie 2 (Ansible)..."
ansible --version 2>/dev/null && echo "  ✓ Ansible installé" || echo "  ✗ Ansible manquant"
python3 -c "import yaml, paramiko" 2>/dev/null && echo "  ✓ Modules Python OK" || echo "  ✗ Modules Python manquants"

echo "3. Test Partie 3 (Terraform)..."
terraform version 2>/dev/null && echo "  ✓ Terraform installé" || echo "  ✗ Terraform manquant"

echo "4. Test SMTP..."
which msmtp && echo "  ✓ msmtp disponible" || which sendmail && echo "  ✓ sendmail disponible" || echo "  ✗ Aucun client SMTP"

echo "=== FIN DU TEST ==="
