# laravel_docker
## Use docker compose for multi laravel projects

- `cp env.example .env`
- change config in .env file
- create new laravel projects in `APP_CODE_PATH_HOST` default `../`
- run `docker-compose build php-fpm-7.2 php-fpm-8.0` to make image tag
- `docker-compose up -d` and enjoy :)
- run `docker-compose build name_services` when add configs file for name_service

## Bash, Zsh alias
- add scripts to ~/.bashrc, ~/.zshrc

    
    alias dc="docker-compose"

    alias dcd='dc down'
  
    alias dcu='dc up'
  
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
                        echo "Don't exist this project."
                        ;;
        esac
    }

    dcexec ()
    {
        PROJECT=$1
        COMMAND=$2
    
        case $PROJECT in
            publisher)
                docker exec php-fpm-8.0 bash -c "cd /var/www/adnetwork-publisher-ui; php artisan $COMMAND"
                ;;
            *)
                echo "Don't exist this project."
                ;;
        esac
    }

## Docker tips
- Run container command in folder `docker exec php-fpm-7.2 bash -c "cd absolute-path; command"` 
- Example `docker exec php-fpm-7.2 bash -c "cd /var/www/labs-qc-site; bin/minion db:migrate --init"`


## Nginx with multiple projects (domains), can curl others
- Run command to get docker network bridge ip 
  
    `docker network inspect bridge --format '{{range .IPAM.Config}}{{.Gateway}}{{end}}'`

- add `extra_hosts` for services need to call other services (php-fpm, nginx, php-worker ...)
    
    `- "moderation-tool.local:${HOST_BRIDGE_IP}"`

## projects
- `bin/minion` change Shebang of run script files `#!/usr/bin/php` to `#!/usr/local/bin/php`, update file `CRLF` to `LF`
- load more env from .env
- update logs, cache path to each projects

## minio
- create service account for each project
- create bucket for each project and set access policy to public