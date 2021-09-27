containerName="postgres"
user="postgres"
network="pg_net"
exposedPort="5432:5432"
postgresVersion="postgres:10.6-alpine"

startPostgres()
{
    docker run -it --detach --name $containerName --network $network -p $exposedPort -v /backups/db-workdir:/var/lib/postgresql/data $postgresVersion
}

# $1 = postgres command first half (and container name)
# $2 = postgres command specifications and parameter
pg()
{
    docker run -it --rm --name $1 --network $network $postgresVersion $1 -h $containerName -U $user $2 $3 $4 $5 $6 $7 $8 $9
}

pgt()
{
    docker run -i --rm --name $1 --network $network $postgresVersion $1 -h $containerName -U $user $2 $3 $4 $5 $6 $7 $8 $9
}

psql()
{
    pg 'psql' $@
}

psqlWithoutT()
{
    pgt 'psql' $@
}

dropdb()
{
    pg 'dropdb' $@
}

createdb()
{
    pg 'createdb' $@
}

pg_dump()
{
    pg 'pg_dump' $@
}

pg_dumpT()
{
    pgt 'pg_dump' $@
}

pg_restore()
{
    pg 'pg_restore' $@
}

# $1 Database to create
# $2 Database to use as template
pg_createdb_from_template()
{
    pgt 'createdb' $1 -T $2
}

# $1 database name
# $2 dump name
insertDump()
{
    cat $2 | psqlWithoutT $1
}

createFromDump()
{
    createdb $1
    insertDump $1 $2
}

