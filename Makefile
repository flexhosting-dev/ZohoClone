.PHONY: help build up down restart logs shell-php shell-node db-migrate db-seed jwt-keys

# Default target
help:
	@echo "Available commands:"
	@echo "  make build       - Build all Docker containers"
	@echo "  make up          - Start all containers"
	@echo "  make down        - Stop all containers"
	@echo "  make restart     - Restart all containers"
	@echo "  make logs        - View logs from all containers"
	@echo "  make shell-php   - Open shell in PHP container"
	@echo "  make shell-node  - Open shell in Node container"
	@echo "  make db-migrate  - Run database migrations"
	@echo "  make db-seed     - Load database fixtures"
	@echo "  make jwt-keys    - Generate JWT keys"
	@echo "  make install     - Install all dependencies"
	@echo "  make test        - Run tests"

# Build containers
build:
	docker-compose build

# Start containers
up:
	docker-compose up -d

# Stop containers
down:
	docker-compose down

# Restart containers
restart:
	docker-compose restart

# View logs
logs:
	docker-compose logs -f

# PHP shell
shell-php:
	docker-compose exec php sh

# Node shell
shell-node:
	docker-compose exec node sh

# Database migrations
db-migrate:
	docker-compose exec php bin/console doctrine:migrations:migrate --no-interaction

# Load fixtures
db-seed:
	docker-compose exec php bin/console doctrine:fixtures:load --no-interaction

# Generate JWT keys
jwt-keys:
	docker-compose exec php bin/console lexik:jwt:generate-keypair --overwrite

# Install dependencies
install:
	docker-compose exec php composer install
	docker-compose exec node npm install

# Run tests
test:
	docker-compose exec php bin/phpunit

# Create database
db-create:
	docker-compose exec php bin/console doctrine:database:create --if-not-exists

# Drop database
db-drop:
	docker-compose exec php bin/console doctrine:database:drop --force --if-exists

# Reset database
db-reset: db-drop db-create db-migrate db-seed

# Production build
prod-build:
	docker-compose -f docker-compose.prod.yml build

# Production up
prod-up:
	docker-compose -f docker-compose.prod.yml up -d

# Frontend build
frontend-build:
	docker-compose exec node npm run build
