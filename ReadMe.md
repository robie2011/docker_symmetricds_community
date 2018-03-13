# Symmetric DS Community Docker Services
This project contains docker images for testing SymmetricDS Community functionality. Containers uses linux base image.

Project contains:
- 2x MySQL containers
- 2x SymmetricDS Community containers

container description can be found in compose file `docker-compose.yml`.

## SymmetricDS Configuration
- content of `sym_image/data` will be copied to `/data` during image build process
- are stored in sym_image/data folder and will be copied to image during build process
- Enviromental variable `SYM_ENGINE_FILE` is used for choosing engine on first container start (default: `client-machine01.properties`).
- used db for sync: `sym`. Desired table configurations can be made in `import.preinstall.sql`.
- services
    - sym0: is the master node. Uses `server.properties` engine file.
    - symmetricds configuration can be found in `import_master.sql`
    - sym1: is the client node. Uses `client-machine01.properties` engine file.
- For each SymmetricDS container an sql script can be imported once. Enviromental variable `DB_SCRIPT` is used to specify it.

## Admin Tasks
- build containers: `docker-compose build` (If changes was made to Dockerfile)
- create and start all containers: `docker-compose up`
- stop and destroy all containers: `docker-compose down`
- stop containers: `docker-compose stop`
- start containers: `docker-compose start`
- note: `/data/symmetricds_start.sh` will be executed on each container start
- database services:
    - db0: `172.20.10.100`
    - db1: `172.20.10.101`
    - root password: `root`

## Note
- It is not possible to access containers from host machine over TCP/IP on mac. Workaround: https://github.com/wojas/docker-mac-network
- Env variable `$DB_IP` is redundant. Can be read from properties-file. Need fix.
