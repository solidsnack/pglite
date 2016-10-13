A tiny (~250 line) shell script that manages ephemeral Postgres databases.

```bash
# Creates a database in ./var if it does not exist and immediately connects.
./pglite
# Upon closing the SQL console, shuts down the database.

# Creates a database in ./var if it does not exist.
./pglite setup

# Opens a SQL console, ensuring the database is started (see `start` below).
./pglite connect
# Upon closing the SQL console, shuts down the database.

# The start/stop/status family of commands are passed directly to pg_ctl.
./pglite start|stop|status

# To remove your database and its configuration.
./pglite rm

# To display your current database connection string.
./pglite url

# Example of connecting with `psql`:
psql "$(./pglite url)"
```
