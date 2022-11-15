# laravel_docker
## Use docker compose for multi laravel projects

- `cp env.example .env`
- change config in .env file
- create new laravel projects in `APP_CODE_PATH_HOST` default `../`
- run `docker-compose build php-fpm-*` to make image tag
- `docker-compose up -d` and enjoy :)
- run `docker-compose build name_services` when add configs file for name_service

## Bash, Zsh alias
- add scripts to ~/.bashrc, ~/.zshrc
```
alias dc="docker-compose"

alias dcd='dc down'
alias dcu='dc up'
alias php81="dc exec php-fpm-8.1 bash"
alias php8="dc exec php-fpm-8.0 bash"
alias php74="dc exec php-fpm-7.4 bash"
alias php72="dc exec php-fpm-7.2 bash"

#Dock compose up
dcup ()
{
    PROJECT=$1
    case $PROJECT in
        qc)
            dcu -d nginx mysql redis clickhouse kafka zookeeper mongodb
            ;;
        publisher|operation)
            dcu -d nginx mysql redis-cluster clickhouse mailhog php-worker-8.0
            ;;
        ad-tag)
            dcu -d nginx
            ;;
        moderation-tool)
            dcu -d nginx mysql redis-sentinel mongodb rabbitmq
            ;;
        *)
            dcu -d nginx mysql redis redis-cluster redis-sentinel mongodb rabbitmq clickhouse kafka zookeeper mailhog minio
            ;;
    esac
}

#Build & push docker image
build ()
{
    DOCKERFILE_PATH=$1
    git fetch --all --tags
    version=$(git describe --tags)
    image=$(cat .image)
    docker build -f $DOCKERFILE_PATH --build-arg ARG_BUILD_VERSION=${version} -t ${image}:${version} .
    docker push `cat .image`:`git describe --tags`
    
    echo `cat .image`:`git describe --tags`
    git log -1 --pretty=%B | cat
    docker rmi `cat .image`:`git describe --tags`
}
``` 

## Docker tips
- Run container command in folder `docker exec php-fpm-7.4 bash -c "cd absolute-path; command"` 
- Example `docker exec php-fpm-7.4 bash -c "cd /var/www/labs-qc-site; bin/minion db:migrate --init"`


## Nginx with multiple projects (domains), can curl others
- Run command to get docker network bridge ip 
  
    `docker network inspect bridge --format '{{range .IPAM.Config}}{{.Gateway}}{{end}}'`

- add `extra_hosts` for services need to call other services (php-fpm, nginx, php-worker ...)
    
    `- "moderation-tool.local:${HOST_BRIDGE_IP}"`

## Run frontend project
- add ports for project
```
ports:
  - '5173:5173'
```
- vite expose host: change the package script `vite --host`
- update vite.config.js file
```
server: {
        hmr: {
            host: 'hostname',
        },
    },
```
- run command in docker `npm run dev`

## projects
- `bin/minion` change Shebang of run script files `#!/usr/bin/php` to `#!/usr/local/bin/php`, update file `CRLF` to `LF`
- load more env from .env
- update logs, cache path to each projects

## minio
- create service account for each project
- create bucket for each project and set access policy to public