# Administration système et réseaux

**Auteur** : TAMWO MOTCHEYO STEVE SOREL
**Matricule** : 23U2423
**Niveau** : L3

---

## TP1 : Automatisation de la création d’utilisateurs sous Linux

### Partie 2 : Automatisation avec Ansible (Playbook)

Ce document décrit un **playbook Ansible** permettant d’automatiser la création d’utilisateurs Linux et la configuration système associée (groupes, sécurité, quotas, limites de ressources et notifications par email).

---

## 1. Objectifs du playbook

Le playbook a pour objectifs de :

* Créer un groupe système dédié
* Créer automatiquement des utilisateurs à partir d’un fichier texte
* Configurer les informations GECOS (nom, téléphone, email)
* Définir et chiffrer les mots de passe
* Forcer le changement de mot de passe à la première connexion
* Ajouter les utilisateurs au groupe `sudo`
* Restreindre l’accès à la commande `su`
* Mettre en place des quotas disque
* Limiter l’utilisation mémoire
* Créer un message de bienvenue personnalisé
* Envoyer un email de notification à chaque utilisateur

---

## 2. Prérequis

Avant l’exécution du playbook, les éléments suivants sont requis :

* Ansible installé sur le nœud de contrôle
* Accès SSH aux hôtes cibles
* Exécution avec privilèges administrateur (`become: yes`)
* Système Linux (Debian / Ubuntu recommandé)
* Paquet `quota` installé et quotas activés sur `/home`
* Collection Ansible `community.general` installée

```bash
ansible-galaxy collection install community.general
```

---

## 3. Structure du fichier `users.txt`

Le playbook lit les utilisateurs depuis un fichier `users.txt` avec le format suivant :

```text
username;password;nom_complet;téléphone;email;shell
```

### Exemple :

```text
jdupont;password123;Jean Dupont;690000000;jean.dupont@mail.com;/bin/bash
```

⚠️ Le mot de passe est automatiquement **haché en SHA-512** par Ansible.

---

## 4. Variables utilisées

Les variables principales du playbook sont :

```yaml
group_name: "students-inf-361"
users_file: "users.txt"
```

* `group_name` : nom du groupe à créer
* `users_file` : fichier source des utilisateurs

---

## 5. Exécution du playbook

### 5.1 Commande d’exécution

```bash
ansible-playbook create_users.yml -i inventory
```

* `create_users.yml` : playbook Ansible
* `inventory` : fichier d’inventaire des hôtes cibles

---

## 6. Fonctionnement détaillé du playbook

### 6.1 Création du groupe

Le module `group` crée le groupe s’il n’existe pas déjà.

---

### 6.2 Lecture du fichier utilisateurs

Le fichier `users.txt` est lu et transformé en liste exploitable par Ansible.

---

### 6.3 Création et configuration des utilisateurs

Pour chaque utilisateur :

* Création du compte
* Ajout au groupe principal et au groupe `sudo`
* Configuration du shell
* Ajout des informations GECOS
* Chiffrement automatique du mot de passe

---

### 6.4 Sécurité des comptes

* Changement de mot de passe forcé à la première connexion
* Blocage de la commande `su` pour le groupe via PAM

---

### 6.5 Message de bienvenue

Un fichier `WELCOME.txt` est créé dans le répertoire personnel de chaque utilisateur.

---

### 6.6 Quotas disque

Chaque utilisateur reçoit un quota disque de :

* **15 Go** sur `/home`

---

### 6.7 Limitation mémoire

Une limite stricte d’utilisation mémoire est appliquée à :

* **20 % de la RAM**

Cette configuration est ajoutée dans :

```text
/etc/security/limits.conf
```

---

### 6.8 Envoi d’email de bienvenue

Un email automatique est envoyé à chaque utilisateur contenant :

* Les informations de connexion SSH
* L’adresse IP du serveur
* La commande SSH à utiliser
* Les instructions pour ajouter une clé SSH

---

## 7. Sécurité et bonnes pratiques

* Utiliser un environnement de test avant la production
* Protéger le fichier `users.txt`
* Ne jamais transmettre les mots de passe en clair en production
* Utiliser des clés SSH à la place des mots de passe

---

## 8. Conclusion

Ce playbook Ansible offre une solution **centralisée, reproductible et sécurisée** pour la gestion automatisée des utilisateurs Linux dans un environnement académique ou professionnel.

---

**Fin du TP1 – Partie 2**

