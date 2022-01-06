# laravel_docker
## Use docker compose for multi laravel projects

- `cp env.example .env`
- change config in .env file
- create new laravel projects in `APP_CODE_PATH_HOST` default `../`
- `docker-compose up -d` and enjoy :)
- run `docker-compose build name_services` when add configs file for name_service

## Docker tips
- Run container command in folder `docker exec php-fpm-7.2 bash -c "cd absolute-path; command"` example `docker exec php-fpm-7.2 bash -c "cd /var/www/labs-qc-site; bin/minion db:migrate --init"`


## Nginx with multiple projects (domains), can curl others
- Run command to get docker network bridge ip 
  
    `docker network inspect bridge --format '{{range .IPAM.Config}}{{.Gateway}}{{end}}'`
- add `extra_hosts` for services need to call other services (php-fpm, nginx, php-worker ...)
    
    `- "moderation-tool.local:${HOST_BRIDGE_IP}"`