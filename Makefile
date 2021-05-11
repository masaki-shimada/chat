up:
	docker-compose up -d
build:
	docker-compose build --no-cache --force-rm
create-project:
	@make build
	@make up
	docker-compose exec api php artisan key:generate
	docker-compose exec api php artisan storage:link
	docker-compose exec api chmod -R 777 storage bootstrap/cache
	@make fresh
install-recommend-packages:
	docker-compose exec api composer require doctrine/dbal "^2"
	docker-compose exec api composer require --dev ucan-lab/laravel-dacapo
	docker-compose exec api composer require --dev barryvdh/laravel-ide-helper
	docker-compose exec api composer require --dev beyondcode/laravel-dump-server
	docker-compose exec api composer require --dev barryvdh/laravel-debugbar
	docker-compose exec api composer require --dev roave/security-advisories:dev-master
	docker-compose exec api php artisan vendor:publish --provider="BeyondCode\DumpServer\DumpServerServiceProvider"
	docker-compose exec api php artisan vendor:publish --provider="Barryvdh\Debugbar\ServiceProvider"
init:
	cp .env.example .env
	docker-compose up -d --build
	docker-compose exec api composer install
	docker-compose exec api cp .env.example .env
	docker-compose exec api php artisan key:generate
	docker-compose exec api php artisan storage:link
	docker-compose exec api chmod -R 777 storage bootstrap/cache
	@make fresh
remake:
	@make destroy
	@make init
stop:
	docker-compose stop
down:
	docker-compose down --remove-orphans
restart:
	@make down
	@make up
destroy:
	docker-compose down --rmi all --volumes --remove-orphans
destroy-volumes:
	docker-compose down --volumes --remove-orphans
ps:
	docker-compose ps
logs:
	docker-compose logs
logs-watch:
	docker-compose logs --follow
log-web:
	docker-compose logs web
log-web-watch:
	docker-compose logs --follow web
log-app:
	docker-compose logs app
log-app-watch:
	docker-compose logs --follow app
log-db:
	docker-compose logs db
log-db-watch:
	docker-compose logs --follow db
migrate:
	docker-compose exec api php artisan migrate
fresh:
	docker-compose exec api php artisan migrate:fresh --seed
seed:
	docker-compose exec api php artisan db:seed
dacapo:
	docker-compose exec api php artisan dacapo
rollback-test:
	docker-compose exec api php artisan migrate:fresh
	docker-compose exec api php artisan migrate:refresh
tinker:
	docker-compose exec api php artisan tinker
test:
	docker-compose exec api php artisan test
optimize:
	docker-compose exec api php artisan optimize
optimize-clear:
	docker-compose exec api php artisan optimize:clear
cache:
	docker-compose exec api composer dump-autoload -o
	@make optimize
	docker-compose exec api php artisan event:cache
	docker-compose exec api php artisan view:cache
cache-clear:
	docker-compose exec api composer clear-cache
	@make optimize-clear
	docker-compose exec api php artisan event:clear
npm:
	@make npm-install
yarn:
	docker-compose exec front yarn
yarn-install:
	@make yarn
yarn-dev:
	docker-compose exec front yarn dev
yarn-watch:
	docker-compose exec front yarn watch
yarn-watch-poll:
	docker-compose exec front yarn watch-poll
yarn-hot:
	docker-compose exec front yarn hot
db:
	docker-compose exec db bash
sql:
	docker-compose exec db bash -c 'mysql -u $$MYSQL_USER -p$$MYSQL_PASSWORD $$MYSQL_DATABASE'
ide-helper:
	docker-compose exec api php artisan clear-compiled
	docker-compose exec api php artisan ide-helper:generate
	docker-compose exec api php artisan ide-helper:meta
	docker-compose exec api php artisan ide-helper:models --nowrite
