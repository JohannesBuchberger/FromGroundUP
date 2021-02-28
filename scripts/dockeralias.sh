#/bin/bash

docker()
{
    sudo docker $*
}

dkexec()
{
    if [ -z $1 ];
    then
        echo 'which container? specify $1'
    else
        sudo docker exec -it $1 /bin/bash
    fi
}

dkrm()
{
    if [ -z $1 ];
    then
        echo 'which container? specify $1'
    else
        sudo docker stop $1
        sudo docker rm $1
    fi
}

dkirm()
{
    if [ -z $1 ];
    then
        echo 'which image? specify $1'
    else
        sudo docker rmi $1
    fi
}

dk()
{
    sudo docker $*
}

dki()
{
    sudo docker images
}

dkps()
{
    sudo docker ps -a
}

startUITestDocker()
{
    sudo docker run --rm -p 4444:4444 -p 5959:5900 --name SeleniumFirefoxDebug --shm-size=2g selenium/standalone-firefox-debug:3.141.59
}

buyWhale()
{
    sudo systemctl start docker
}


##########################
#    Exentra specific    #
##########################
dockerlogin()
{
    dk login docker.exentra.de
}

dockersnaps()
{
    dk login docker-snaps.paf.exentra.de
}

dockerlogout()
{
    dk logout docker.exentra.de
}
