# Symmetric DS Community Docker Services
This project contains docker images for testing SymmetricDS Community functionality. Containers uses linux base image.

Project contains:
- 2x MySQL containers
- 2x SymmetricDS Community containers

container description can be found in compose file `docker-compose.yml`.

## SymmetricDS Configuration
- content of `sym_image/data` will be copied to `/data` during image build process
- are stored in sym_image/data folder and will be copied to image during build process
- Enviromental variable `SYM_ENGINE_FILE` is used for choosing engine on first container start (default: `client-machine01.properties`).
- For each SymmetricDS container an sql script can be imported once. Enviromental variable `DB_SCRIPT` is used to specify it.

## Admin Tasks
- build containers: `docker-compose build` (If changes was made to Dockerfile)
- create and start all containers: `docker-compose up`
- stop and destroy all containers: `docker-compose down`
- stop containers: `docker-compose stop`
- start containers: `docker-compose start`
- note: `/data/symmetricds_start.sh` will be executed on each container start
- URLS: 
    - Sym Node 0: http://172.20.10.10:31415/app
    - Sym Node 1: http://172.20.10.11:31415/app
- jdbc connections:
    - db0: `jdbc:mysql://172.20.10.100/sym?tinyInt1isBit=false&zeroDateTimeBehavior=convertToNull`
    - db1: `jdbc:mysql://172.20.10.101/sym?tinyInt1isBit=false&zeroDateTimeBehavior=convertToNull`
- db root password: root

Known Issues:
- It is not possible to access containers from host machine over TCP/IP on mac. Workaround: https://github.com/wojas/docker-mac-network
- Env variable `$DB_IP` is redundante. Can be read from properties-file.