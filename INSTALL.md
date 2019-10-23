# Installation

Deux méthodes peuvent être utilisées :

## Méthode 1 (Préconisée)

Utiliser **ansible-galaxy** pour installer le rôle :

1. Créer un fichier **requirements.yml** dans le répertoire `roles` du projet ou à la racine de projet :

    ```yaml
    - name: win_pending_reboot
      scm: git
      src: git+http://bitbucket.serv.cdc.fr/scm/xd4/ansible-role-win_pending_reboot.git
      version: 1.0.0
    ```

    > Remplacer la valeur `1.0.0` du paramètre `version` avec le nom de la branche à déployer (par exemple : `develop`, `master`, `realease\v104` ...).

2. Utiliser la commande **ansible-galaxy** pour installer le rôle.

    Par exemple, cette commande installe le rôle dans le répertoire `roles` :

    ```bash
    ansible-galaxy install -r requirements.yml -p roles/ --force
    ```

## Méthode 2

Utiliser **git** pour copier les fichiers dans le répertoire `roles` :

```bash
git clone --branch 1.0.0 http://bitbucket.serv.cdc.fr/scm/xd4/ansible-role-win_pending_reboot.git
```

> Remplacer la valeur `1.0.0` du paramètre `branch` avec le nom de la branche à déployer (par exemple : `develop`, `master`, `realease\v104` ...).