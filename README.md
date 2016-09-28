A tiny (~250 line) shell script that manages ephemeral Postgres databases.

```bash
# Creates a database in ./var if it does not exist and immediately connects.
./pgmini

# Creates a database in ./var if it does not exist.
./pgmini setup

# Just connects, doesn't create the database.
./pgmini connect

# The start/stop/status family of commands are passed directly to pg_ctl.
./pgmini start|stop|status
```

`pgmini` is committed to being as tiny as the databases it manages.
