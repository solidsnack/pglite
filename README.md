# Ephemeral Databases With `pglite`

The `pglite` command creates and configures a Postgres database in a directory
of its own. The directory is self-contained and includes executable commands
to manage the database -- `pglite` does not need to be on the `PATH` or even
installed to use the created database.

## Usage

To create and connect to a fresh database, use:

```bash
pglite /path/to/new/database
```

This will configure and start the database server before connecting, and shut
down the database after disconnecting.

You can also connect to an existing database, without worrying about whether
it's been started or not:

```bash
pglite /path/to/old/database
```

If other clients are connected, the database will keep running; if not, it will
shut down.

A PGLite database directory exposes several commands for managing and using a
Postgres database instance. Here are the top four, listed in roughly the
order they are likely to be used:

* `settings` -- Manage configuration, schemas and seed data
* `setup` -- Initialize the database
* `sql` -- Connect to a SQL prompt
* `run` -- Start the database and expose a connection string to a command

## PGLite Without `pglite`

The base directory with all necessary commands is can be found in `pglite.d`.
Please read `pglite.d/README.md` to learn more.

It's easy to integrate PGLite with build tooling in any language.

## The Principle of Least My Surprise

PGLite does some things that seem odd at first, but actually are important for
ensuring it runs reliably.

* When the database is started, a new directory is created in `/tmp` to hold
  the UNIX sockets for the database and the config file is rewritten to hold
  this value. This is because the length of the path to the UNIX sockets must
  be under a certain limit; but `pglite` can create a database at an
  arbitrary depth in the filesystem. (The length limit is a limitation of the
  operating system, not a limitation of PostgreSQL.)

* When the database is started, a random free TCP port is found each time, and
  the config file is rewritten to contain this value. This ensures that the
  database is indeed able to open a port. This behavior is disabled with
  `--unix`.
