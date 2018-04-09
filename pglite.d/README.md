# PGLite Without `pglite`

Every PGLite database directory contains all the scripts necesary for
starting, stopping and configuring the database. To include PGLite in another
project, it's enough to archive `pglite.d` (the directory this README is in).
To create a database in a particular place, there are three steps:

* unpack the archive to that directory,
* set settings with `./settings`,
* run the setup process with `./setup`.

## Setting Settings

Settings are managed with `./settings`, which allows one to set
`postgres.conf` settings, enable or disable random port binding, and add
schema files and data files to the initialization process.

## Database Directory Layout

The database directory contains the Postgres data files, a log file, PGLite
metadata and all the database commmands:

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
