# DockerContrib
A collection of Docker Foswiki installations.

*THIS IS A PROOF OF CONCEPT.USE WITH CAUTION*

DockerContrib is a quick way to start a Docker container for a Foswiki installation.

This proof of concept provides a script: `docker-install.pl` that selects a `docker-foswiki` image and starts a container based on that image. 

To use it you must have installed `docker` and started the daemon. Then:
* `git clone git@github.com:BramVan-Oosterhout/DockerContrib`
* `cd DockerContrib/tools`
* `perl docker-install.pl timlegge -build`
* in your browser open: `localhost:8080`
* and use Foswiki

To use this particular image, you need to add a password for the admin user:
* `docker exec -it <container name> sh -c "cd /var/www/foswiki; tools/configure -save -set {Password}='MyPassword'"`


`docker-install.pl` will start containers . All management must be done with `docker`. Read the manual at https://docs.docker.com/. Commands you will need:
* `docker ps`
* `docker container rm -f <container name>`
* `docker exec -it <container name> /bin/bash`

There are two images available through this Contrib:
* Author: Tim Legge - https://github.com/timlegge/docker-foswiki
* Author: Dieken - https://github.com/Dieken/foswiki-docker

Other containers that can be started from this Contrib:
* `perl docker-install.pl timlegge -type simple`
* `perl docker-install,pl timlegge -type simple-https`
* `perl docker-install.pl dieken -build`

