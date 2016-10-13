A tiny (~250 line) shell script that manages ephemeral Postgres databases.

```bash
# Creates a database in ./var if it does not exist and immediately connects.
./pglite

# Creates a database in ./var if it does not exist.
./pglite setup

# Just connects, doesn't create the database.
./pglite connect

# The start/stop/status family of commands are passed directly to pg_ctl.
./pglite start|stop|status

# To remove your database and its configuration.
./pglite rm
```
