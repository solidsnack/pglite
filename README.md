A tiny script for managing ephemeral Postgres instances.

The `pglite` command creates and configures a Postgres database in a directory
of its own. The directory is self-contained and includes executable commands
to manage the database -- `pglite` does not need to be on the `PATH` or even
installed to use the created database.


# Usage

To create a new database, use:

```
pglite path/to/database
```

Many options, documented in `setup`, below, can be passed to control database
server settings:

```
pglite path/to/database --udp --conf wal_level=logical
```

Schema files can be passed, as well:

```
pglite path/to/database --schema tables.sql
```

The database provides the following commands, once initialized:

* `start` -- To start the server.
* `stop` -- To stop the server.
* `status` -- To determine whether the server is started or stopped.
* `run` -- To run a command that connects to the database.
* `sql` -- To obtain a SQL prompt, or run a SQL script.

A few others (documented in _Database Directory Layout_, below) are provided
for subtle use cases.

The `pglite` command has a special mode, `--tmp`, that is like a combination
of `pglite path/to/database`, `pglite start` and `pglite run` or `pglite sql`:
the database is created in `/tmp`, then the command or SQL script is run.
Afterwards, the database is shutdown and deleted.


# Database Directory Layout

Each database lives in a directory of its own and is self-contained -- you
don't need `pglite` to use or manage it. The database directory contains the
Postgres data files, a log file, PGLite metadata and all the database
commmands:

```
.../
    db/                                         -- The Postgres database itself
    info/                                          -- Metadata used by `pglite`
    log                                                    -- Postgres log file
    main                            -- Utilities used by control scripts, below
    remove                  -- Stop the database server and delete the database
    run                          -- Run a command that connects to the database
    sql   -- Connect to the database with `psql`, starting the server if needed
    setup                       -- Change settings or reinitialize the database
    start                                          -- Start the database server
    stop                                            -- Stop the database server
    status                     -- Status (running? stopped?) of database server
    url                                                  -- Obtain database URL
```


# Weird Behavior

PGLite does some things that seem odd at first.

* When the database is started, a new directory is created in `/tmp` to hold
  the UNIX sockets for the database and the config file is rewritten to hold
  this value. This is because, the length of the path to the UNIX sockets must
  be under a certain limit; but `pglite` can create a database at an
  arbitrary depth in the filesystem. This behavior can be disabled with
  `--no-auto-socket`. (The length limit is a feature of the operating system,
  not a limit of Postgres or PGLite.)

* When the database is started, a random free TCP port is found each time, and
  the config file is rewritten to contain this value. This ensures that the
  database is indeed able to open a port. This behavior is disabled with
  `--udp`, `--tcp <number>` or `--tcp <range>` (the latter selects a free port
  but only once, at database setup time).


