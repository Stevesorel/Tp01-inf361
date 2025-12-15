# Administration système et réseaux

**Auteur** : TAMWO MOTCHEYO STEVE SOREL
**Matricule** : 23U2423
**Niveau** : L3

---

## TP1 : Automatisation de la création d’utilisateurs sous Linux

### Partie 3 : Automatisation avec Terraform (Provisionnement distant)

Ce document décrit l’utilisation de **Terraform** pour automatiser le déploiement et l’exécution d’un playbook **Ansible** sur un serveur distant via une connexion SSH.

---

## 1. Objectifs

Cette configuration Terraform a pour objectifs de :

* Se connecter à un serveur distant via SSH
* Installer automatiquement les dépendances nécessaires (Python, Ansible)
* Récupérer un dépôt Git contenant un playbook Ansible
* Exécuter le playbook Ansible pour créer et configurer des utilisateurs Linux
* Centraliser l’automatisation dans une approche **Infrastructure as Code (IaC)**

---

## 2. Technologies utilisées

* **Terraform** : orchestration et automatisation
* **Provider SSH (loafoe/ssh)** : exécution de commandes distantes
* **Ansible** : configuration et gestion des utilisateurs
* **Git** : récupération du code distant
* **Linux (Debian/Ubuntu)** : système cible

---

## 3. Prérequis

Avant d’exécuter Terraform, les éléments suivants sont requis :

* Terraform installé sur la machine locale
* Accès SSH fonctionnel au serveur distant
* Un utilisateur distant disposant des droits sudo
* Accès Internet sur le serveur distant
* Dépôt Git contenant :

  * `create_users.yml`
  * `inventory.ini`
  * `users.txt`

---

## 4. Structure des fichiers Terraform

```text
.
├── main.tf
├── variables.tf
├── terraform.tfvars
```

---

## 5. Variables utilisées

Les variables suivantes doivent être définies :

```hcl
variable "server_ip" {
  description = "Adresse IP du serveur distant"
}

variable "ssh_user" {
  description = "Utilisateur SSH"
}

variable "ssh_password" {
  description = "Mot de passe SSH"
}
```

### Exemple de `terraform.tfvars`

```hcl
server_ip   = "192.168.1.10"
ssh_user    = "admin"
ssh_password = "password123"
```

 En production, l’authentification par **clé SSH** est fortement recommandée.

---

## 6. Fonctionnement de la configuration Terraform

### 6.1 Provider SSH

Le provider SSH permet à Terraform d’exécuter des commandes directement sur le serveur distant.

---

### 6.2 Ressource `ssh_remote_exec`

La ressource exécute les actions suivantes :

1. Mise à jour des paquets système
2. Installation de Python 3 et Ansible
3. Clonage du dépôt Git contenant le playbook
4. Exécution du playbook Ansible de création des utilisateurs

---

## 7. Exécution de Terraform

### 7.1 Initialisation

```bash
terraform init
```

---

### 7.2 Validation

```bash
terraform validate
```

---

### 7.3 Déploiement

```bash
terraform apply
```

Confirmer l’exécution lorsque Terraform le demande.

---

## 8. Sécurité et bonnes pratiques

* Ne pas stocker de mots de passe en clair en production
* Préférer l’authentification SSH par clé
* Restreindre les droits de l’utilisateur SSH
* Utiliser des variables sensibles Terraform (`sensitive = true`)
* Versionner le code Terraform sans inclure `terraform.tfvars`

---

## 9. Intégration dans le TP

Cette partie complète :

* **Partie 0** : Sécurisation SSH
* **Partie 1** : Script Bash
* **Partie 2** : Playbook Ansible

Elle illustre une chaîne complète d’automatisation moderne :

```text
Terraform → SSH → Ansible → Système Linux
```

---

## 10. Conclusion

L’utilisation de Terraform permet d’orchestrer et d’automatiser l’exécution d’Ansible à distance, offrant une solution robuste, reproductible et évolutive pour la gestion des utilisateurs Linux.

---

**Fin du TP1 – Partie 3**

