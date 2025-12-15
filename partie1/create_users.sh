#!/bin/bash
set -e

LOG_FILE="/var/log/create_users.log"
GROUP_NAME="${1:-students-inf-361}"
INPUT_FILE="users.txt"

# Initialisation du log
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "Début du script de création des utilisateurs"

# 1. Création du groupe
if ! getent group "$GROUP_NAME" > /dev/null; then
    groupadd "$GROUP_NAME"
    log "Groupe $GROUP_NAME créé"
else
    log "Groupe $GROUP_NAME existe déjà"
fi

# Lecture du fichier users.txt
while IFS=';' read -r username password full_name phone email shell; do
    log "Traitement de l'utilisateur : $username"

    # 2a. Création de l'utilisateur
    useradd -m -c "$full_name" -s "$shell" "$username" 2>/dev/null || {
        log "Échec de création de $username, vérification du shell"
        # Vérification/installation du shell
        if ! command -v "$shell" > /dev/null; then
            apt-get update && apt-get install -y "$shell" || {
                log "Installation du shell $shell échouée, utilisation de /bin/bash"
                shell="/bin/bash"
            }
        fi
        useradd -m -c "$full_name" -s "$shell" "$username"
    }

    # 2b. Ajout des informations supplémentaires (GECOS)
    usermod -c "$full_name, $phone, $email" "$username"

    # 3. Ajout au groupe principal
    usermod -aG "$GROUP_NAME" "$username"

    # 4. Définition du mot de passe haché
    echo "$username:$password" | chpasswd -e

    # 5. Forcer le changement à la première connexion
    chage -d 0 "$username"

    # 6. Ajout au groupe sudo mais restriction de 'su'
    usermod -aG sudo "$username"
    echo "DenyGroups $GROUP_NAME" >> /etc/pam.d/su 2>/dev/null || log "PAM non modifié pour su"

    # 7. Message de bienvenue
    WELCOME_FILE="/home/$username/WELCOME.txt"
    echo "Bienvenue $full_name !" > "$WELCOME_FILE"
    echo "echo \"\$(cat $WELCOME_FILE)\"" >> "/home/$username/.bashrc"

    # 8. Quota disque (15 Go)
    setquota -u "$username" 15000000 15000000 0 0 /home

    # 9. Limite mémoire (20% RAM)
    echo "$username hard memory 20%" >> /etc/security/limits.conf

    log "Utilisateur $username configuré"
done < "$INPUT_FILE"

log "Script terminé avec succès"
