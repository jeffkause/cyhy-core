NCATS Scanner
=============

The NCATS scanner is the core of the Cyber Hygiene program.  It coordinates the multiple scanners and allows the creation of pretty reports.  

Installation
------------

Required third party libraries can be installed using: `pip install -r requirements.txt`

Required configurations:
The commander will read `/etc/cyhy/commander.conf`
If you do not have this file, please create one (even if empty)


IP Address Geolocation Database:
The geolocation database is not included in the source tree due to size and licensing.  Please cd into the 'var' directory and run the 'get-geo-db.sh' script to get the latest database.

Development Installation
------------------------
If you are developing the source the following installation will allow in place editing with live updates to the libraries, and command line utilities.

sudo pip install numpy
sudo port install geos
sudo pip install -r requirements.txt

Docker Goodies
--------------
The CyHy commands implemented in the docker container can be aliased into the host environment by using the procedure below.

Alias the container commands to the local environment:
```bash
eval "$(docker run ncats/cyhy-core)"
```

To run a CyHy command:
```bash
cyhy-tool status NASA
```

#### Caveats, and Gotchas

Whenever an aliased CyHy command is executed, it will use the current working directory as its home volume.  This limits your ability to use absolute paths as parameters to commands, or relative paths that reference parent directories, e.g.; `../foo`.  That means all path parameters to a CyHy command must be in the current working directory, or a subdirectory.  

| Do this?        | Command                                   | Reason  |
| ------------- |---------------------------------------------| --------|
| Yes           | `cyhy-import NASA.json`                     | parameter file is in the current directory |
| Yes           | `cyhy-import space_agencies/NASA.json`      | parameter file is in a sub-directory |
| NO!           | `cyhy-import ../WH.json`                    | parameter file is in a parent directory |
| NO!           | `cyhy-import /tmp/SPACE_FORCE.json`         | parameter file is an absoulte path |

### Advanced configuration

By default, the container will look for your CyHy configurations in `/etc/cyhy`.  This location can be changed by setting the `CYHY_CONF_DIR` environment variable to point to your CyHy configuration directory.  The commands will also attempt to run using the `ncats/cyhy-core` image.  A different image can be used by setting the `CYHY_CORE_IMAGE` environment variable to the image name.

Example:
```
export CYHY_CONF_DIR=~/.cyhy
export CYHY_CORE_IMAGE=dhub.ncats.dhs.gov:5001/cyhy-core
```

### Building the cyhy-core container


To build the Docker container for cyhy-core:

```bash
docker build -t ncats/cyhy-core .
```

To attach a shell:
```bash
docker exec -ti cyhy-core /bin/bash
```
