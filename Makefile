.PHONY: help install serve db-migrate db-seed db-reset cache-clear test

# Default target
help:
	@echo "Available commands:"
	@echo "  make install      - Install dependencies"
	@echo "  make serve        - Start development server"
	@echo "  make db-migrate   - Run database migrations"
	@echo "  make db-seed      - Load database fixtures"
	@echo "  make db-reset     - Reset database (drop, create, migrate, seed)"
	@echo "  make cache-clear  - Clear Symfony cache"
	@echo "  make test         - Run tests"

# Install dependencies
install:
	composer install

# Start development server
serve:
	symfony server:start

# Database migrations
db-migrate:
	php bin/console doctrine:migrations:migrate --no-interaction

# Load fixtures
db-seed:
	php bin/console doctrine:fixtures:load --no-interaction

# Create database
db-create:
	php bin/console doctrine:database:create --if-not-exists

# Drop database
db-drop:
	php bin/console doctrine:database:drop --force --if-exists

# Reset database
db-reset: db-drop db-create db-migrate db-seed

# Clear cache
cache-clear:
	php bin/console cache:clear

# Run tests
test:
	php bin/phpunit
