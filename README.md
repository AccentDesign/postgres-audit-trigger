A simple, customisable table audit system for PostgreSQL implemented using
triggers.

See:

http://wiki.postgresql.org/wiki/Audit_trigger_91plus

Run the following to get a list of tables to enable the logging on:

    SELECT 'SELECT audit.audit_table(''' || table_name || ''');'
    FROM information_schema.tables
    WHERE table_schema = 'public'
    ORDER BY table_name;
