#Works as extension to the bash profile

function scripts() {
    echo "script functions available: "
    echo "mkd() <folder>"
    echo "restore_db_from_backup <database>"
    echo "create_dump_from_db <databse>"
    echo "exchangeOrigin <newOrigin> (used for git p)"
    echo "rmd <1.DirectoryNameToBeDeleted> <2.DirectoryNameToBeDeleted>"
    echo "mkd <directoryNameToBeCreated>"
    echo "cpd <directoryToCopy> <destinationDirectory>"
    echo ".. (same as cd ..)"
    echo "cl <directoryName>"
    echo "httpserver <port>"
    echo "dkexec <containerID> (used to exec bash)"
    echo "dkrm <containerID> (stops and deletes a container)"
    echo "removeRemoteBranch <BranchToDelte>"
}

# UTILITY alias functions
..() {
cd ../
}

cpd() {
    if [ -z $1 ];
    then
        echo "Parameters are: cpd <directoryToCopy> <destinationDirectory>"
    else
        if [ -z $2 ];
        then
            echo "No destination directory given"
        else
            cp -r $1 $2
        fi
    fi
}

mkd() {
    mkdir -p $1 && cd $1
}

rmd() {
    rm -rf $1
    if [ -z $2 ];
    then
        rm -rf $2
    fi
}

cl() {
    cd $1 && ls -latrghc
}

httpserver()
{
    python -m SimpleHTTPServer $1
}

recreateDB()
{
    dropdb $1
    createdb $1
    cat $2 | psqlWithoutT $1
}

# POSTGRESQL alias functions
restore_pid_db_from_backup()
{
    if [ -z $3 ];
    then
        echo "you can specify from which directory you want to restore the backup from \n using an third argument restore_pid_db_from_backup <database name> <optional: dump_name> <optional: dump location>"
        basePath=$POSTGRES_BACKUP_DIR/pid/
    else
        basePath=$3
    fi

    if [ -z $1 ];
    then
        echo "restore_db_from_backup <database name> <optional: dump_name>"
    else

        if [ -z $2 ];
        then
            echo "restoring database from lastest '$1' dump because no name is given"
            dropdb $1
            createdb $1
            cat $basePath$1_backup_latest | psqlWithoutT $1
            echo "successful restored from latest dump"
        else
            specificDump=$basePath$2

            if [ -e $specificDump ];
            then
                dropdb $1
                createdb $1
                cat $specificDump | pgt $1
                echo "successful restored "
            else
                echo "The given dump does not exist"
            fi
        fi
    fi
}

create_dump_from_pid_db()
{
    if [ -z $2 ];
    then
        echo "you can specify in which directory you want to save the dump \n using an third argument create_dump_from_pid_db <database name> <optional: dump location>"
        basePath=$POSTGRES_BACKUP_DIR/pid/
    else
        basePath=$2
    fi

    if [ -z $1 ];
    then
        echo "please spezi-fy a databse. For example: astech;"
    else

        if psql -lqt | cut -d \| -f 1 | grep -qw $1;
        then
            latestFile=$basePath$1_backup_latest

            if [ -e $latestFile ];
            then
                `rm $latestFile`
            fi
            backupTimestamp=$(date +%s)
            pg_dump $1 > $basePath$1_backup_$backupTimestamp
            ln -s $basePath$1_backup_$backupTimestamp $latestFile
            echo "successfull dumped"
        else
            echo "The database does not exist"
        fi
    fi
}

# GIT alias functions
exchangeOrigin()
{
    if [ -z $1 ]
    then
        echo "enter the new Origin "
    else
        git remote rm origin
        git remote add origin $1
        git pull
        git branch --set-upstream-to=origin/master master
    fi
}

removeRemoteBranch()
{
    if [ -z $1 ]
    then
        echo "enter the branch to delete remote"
    else
        git push origin --delete $1
    fi
}

getAllBranches()
{
    git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$re    mote"; done
}
