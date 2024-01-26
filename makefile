
build:
	docker compose up -d
	docker exec laravel-web-1 composer install
	docker exec laravel-web-1 php artisan migrate
	docker exec laravel-web-1 chown -R www-data:www-data storage

up: 
	docker compose up -d 

down:
	docker compose down