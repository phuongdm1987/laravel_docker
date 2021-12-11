# laravel_docker
## Use docker compose for multi laravel projects

- `cp env.example .env`
- change config in .env file
- create new laravel projects in `APP_CODE_PATH_HOST` default `../`
- `docker-compose up -d` and enjoy :)
- run `docker-compose build name_services` when add configs file for name_service
