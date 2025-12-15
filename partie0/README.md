# Administration système et réseaux

**Auteur** : TAMWO MOTCHEYO STEVE SOREL
**Matricule** : 23U2423
**Niveau** : L3

---

## TP1 : Automatisation de la création d’utilisateurs sous Linux

### Partie 0 : Procédure de modification de la configuration SSH

Ce document décrit les étapes nécessaires pour renforcer la sécurité du service SSH sur un système Linux.

---

### 1. Connexion avec les droits administrateur

Se connecter en **root** ou avec un utilisateur disposant des droits **sudo**.

---

### 2. Sauvegarde de la configuration SSH existante

Avant toute modification, il est indispensable de sauvegarder la configuration actuelle.

```bash
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
```

---

### 3. Modification du fichier de configuration SSH

Ouvrir le fichier de configuration avec un éditeur de texte :

```bash
sudo nano /etc/ssh/sshd_config
```

#### Paramètres de sécurité à modifier

Les paramètres suivants permettent d’améliorer la sécurité du serveur SSH :

* **Port** :

  Modifier le port par défaut **22** vers un port **< 1024** afin de réduire les scans automatiques et les attaques par force brute.

* **PermitRootLogin no** :

  Empêche la connexion directe de l’utilisateur **root**, ce qui réduit fortement les risques de compromission.

* **PasswordAuthentication no** :

  Désactive l’authentification par mot de passe et impose l’utilisation de clés SSH.

* **MaxAuthTries 3** :

  Limite le nombre de tentatives de connexion pour contrer les attaques par force brute.

* **ClientAliveInterval 300** :

  Ferme automatiquement une session SSH inactive après **5 minutes**.

---

### 4. Application des modifications

Après modification du fichier :

* Appuyer sur **Ctrl + S** pour sauvegarder
* Appuyer sur **Ctrl + X** pour quitter l’éditeur

---

### 5. Vérification de la syntaxe de la configuration SSH

Avant de redémarrer le service, vérifier que la configuration ne contient pas d’erreurs :

```bash
sudo sshd -t
```

Aucune sortie signifie que la configuration est valide.

---

### 6. Redémarrage du service SSH

Appliquer les changements en redémarrant le service :

```bash
sudo systemctl restart sshd
```

---

### 7. Test de la connexion

 **Important** :

Toujours tester la connexion SSH depuis **une nouvelle session** avant de fermer la session courante.

Cela permet d’éviter toute perte d’accès au serveur en cas de mauvaise configuration.

---

**Fin du TP1 – Partie 0**

