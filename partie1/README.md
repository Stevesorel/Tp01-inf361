# Administration système et réseaux

**Auteur** : TAMWO MOTCHEYO STEVE SOREL
**Matricule** : 23U2423
**Niveau** : L3

---

## TP1 : Automatisation de la création d’utilisateurs sous Linux

### Partie 1 : Script Bash de création et configuration automatique des utilisateurs

Ce script Bash permet d’automatiser la création et la configuration complète d’utilisateurs Linux à partir d’un fichier texte. Il applique des règles de sécurité, de quotas et de limitations de ressources, tout en assurant une traçabilité via un fichier de log.

---

## 1. Objectifs du script

Le script a pour objectifs :

* Créer automatiquement un groupe Linux
* Créer plusieurs utilisateurs à partir d’un fichier `users.txt`
* Configurer les informations GECOS (nom, téléphone, email)
* Définir des mots de passe chiffrés
* Forcer le changement de mot de passe à la première connexion
* Appliquer des quotas disque
* Limiter l’utilisation mémoire
* Ajouter les utilisateurs au groupe sudo avec restriction de `su`
* Générer un message de bienvenue personnalisé
* Journaliser toutes les actions effectuées

---

## 2. Prérequis

Avant l’exécution du script, les éléments suivants doivent être en place :

* Système Linux (Debian / Ubuntu recommandé)
* Exécution en tant que **root** ou avec les privilèges **sudo**
* Paquet `quota` installé et système de fichiers `/home` compatible quotas
* Fichier `/etc/security/limits.conf` accessible
* Accès Internet (si installation automatique de shell requise)

---

## 3. Structure du fichier `users.txt`

Le script lit les utilisateurs depuis un fichier nommé `users.txt`, avec le format suivant :

```text
username;password_haché;nom_complet;téléphone;email;shell
```

### Exemple :

```text
jdupont;$6$abcd1234$xyz...;Jean Dupont;690000000;jean.dupont@mail.com;/bin/bash
```

⚠️ Le mot de passe doit être **haché** (ex : SHA-512).

---

## 4. Utilisation du script

### 4.1 Donner les droits d’exécution

```bash
chmod +x create_users.sh
```

### 4.2 Exécution

```bash
sudo ./create_users.sh [nom_du_groupe]
```

* Si aucun groupe n’est fourni, le groupe par défaut est :

  ```text
  students-inf-361
  ```

---

## 5. Fonctionnement détaillé du script

### 5.1 Journalisation

Toutes les actions sont enregistrées dans le fichier :

```text
/var/log/create_users.log
```

---

### 5.2 Création du groupe

Le script vérifie si le groupe existe déjà avant de le créer afin d’éviter les conflits.

---

### 5.3 Création des utilisateurs

Pour chaque ligne du fichier `users.txt` :

* Création du compte utilisateur
* Création automatique du répertoire personnel
* Définition du shell (installation automatique si absent)

---

### 5.4 Configuration des informations GECOS

Les informations suivantes sont ajoutées :

* Nom complet
* Numéro de téléphone
* Adresse email

---

### 5.5 Gestion des mots de passe

* Attribution du mot de passe haché
* Obligation de changer le mot de passe à la première connexion

---

### 5.6 Gestion des groupes et privilèges

* Ajout au groupe principal défini
* Ajout au groupe `sudo`
* Restriction de l’accès à la commande `su` via PAM

---

### 5.7 Message de bienvenue

Un fichier `WELCOME.txt` est créé dans le répertoire personnel de chaque utilisateur.

Un message de bienvenue est automatiquement affiché à chaque connexion via `.bashrc`.

---

### 5.8 Quotas disque

Chaque utilisateur se voit attribuer un quota disque de :

* **15 Go** sur `/home`

---

### 5.9 Limitation mémoire

Une limite stricte d’utilisation mémoire est définie à :

* **20 % de la RAM**

Cette règle est ajoutée dans le fichier :

```text
/etc/security/limits.conf
```

---

## 6. Sécurité et bonnes pratiques

* Toujours tester le script sur une machine de test
* Vérifier la validité du fichier `users.txt`
* Ne jamais stocker de mots de passe en clair
* Sauvegarder les fichiers système avant modification

---

## 7. Conclusion

Ce script permet une gestion centralisée, sécurisée et automatisée des comptes utilisateurs sous Linux, adaptée à un environnement académique ou professionnel.

---

**Fin du TP1 – Partie 1**

