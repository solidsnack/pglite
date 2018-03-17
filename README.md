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
pglite path/to/database --unix --conf wal_level=logical
```

Schema files can be passed, as well:

```
pglite path/to/database --schema tables.sql
```

Under `path/to/database`, you'll find several commands, including:

* `start` -- To start the server.
* `stop` -- To stop the server.
* `status` -- To determine whether the server is started or stopped.
* `settings` -- To change `postgres.conf` settings.
* `run` -- To run a command that connects to the database.
* `sql` -- To obtain a SQL prompt, or run a SQL script.

A few others (documented in _Database Directory Layout_, below) are provided
for subtle use cases.

The `pglite` command has a special mode, `--tmp`, that is like a combination
of `pglite path/to/database`, `pglite start` and `pglite run` or `pglite sql`:
the database is created in `/tmp`, then the command or SQL script is run.
Afterwards, the database is shutdown and deleted.


# Details For Using PGLite Without `pglite`

Every PGLite database directory is self contained, in the sense that once it is
setup, you no longer need the `pglite` executable, but can connect to,
reconfigure and introspect the database entirely with commands stored under the
database directory itself.

This makes it easy to integrate PGLite with build tooling in any language.
Copy the files from `pglite.d/` into a new directory, provide configuration
data and then run `./setup` -- that's all there is to it.

## Setup

To include PGLite in another project, it's enough to archive `pglite.d`. To use
the resulting archive, to create a database in a particular place, let's say
it's `/tmp/path/to/database`, there are three steps:

* unpack the archive to that directory,
* set settings with `./settings`,
* run the setup process with `./setup`.

## Setting Settings

Settings are managed with `./settings`, which allows one to set
`postgres.conf` settings, enable or disable random port binding, and add
schema files and data files to the initialization process.


## Database Directory Layout

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
    reset              -- Stop the database server and clear the data directory
    run                          -- Run a command that connects to the database
    sql   -- Connect to the database with `psql`, starting the server if needed
    setup                       -- Change settings or reinitialize the database
    settings           -- Set Postgres settings and add schema and seed scripts
    start                                          -- Start the database server
    stop                                            -- Stop the database server
    status                     -- Status (running? stopped?) of database server
    url                                                  -- Obtain database URL
```


## The `info` Directory

There are two types of data stored in the `info` directory: settings and
ephemeral state.

```
.../info/                                          -- Metadata used by `pglite`
         etc/                                             -- Permanent settings
         var/                                -- Temporary, stateful information
```


# The Principle of Least My Surprise

PGLite does some things that seem odd at first, but actually are important for
ensuring it runs reliably, in each and every case, even if one is running many
other instances of PGLite.

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
  `--unix`.
