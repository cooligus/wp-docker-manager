# Wordpress Docker manager

This repo is supposed to optimize wordpress development.

## Commands and scripts

### Running

```bash
docker compose up -d
```

When you want to start containers with preloaded backup run:

```bash
LOAD_BACKUP=true docker compose up -d
```

### Managing backups

In order to create a new backup just run (don't forget about permissions):

```
./make-backup.sh
```

Best way is to have separate path with all backups and just copy your backups to `restore` path. 

```
cp backups/random_date/* restore/
```

