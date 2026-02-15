<?php

namespace Deployer;

require 'recipe/symfony.php';
require 'recipe/provision.php';

// =============================================================================
// Project Configuration
// =============================================================================

set('application', 'honeyguide-projects');
set('repository', 'git@github.com:flexhosting-dev/honeyguide-projects.git');

// =============================================================================
// Provisioning Configuration
// =============================================================================

// Domain for the website
set('domain', 'projects.honeyguide.org');

// PHP version to install
set('php_version', '8.3');

// Database configuration
set('mysql_database', 'honeyguide_projects');
set('mysql_user', 'honeyguide');
set('mysql_password', 'HoneyguideApp2024Secure');

// Default branch to deploy
set('branch', 'liveApp');

// Keep last 5 releases for rollback
set('keep_releases', 5);

// Disable multiplexing for stability
set('ssh_multiplexing', false);

// PHP binary path
set('bin/php', '/usr/bin/php8.3');

// Composer options for production
set('composer_options', '--no-dev --optimize-autoloader --no-interaction');

// Allow composer to run as root
set('env', [
    'COMPOSER_ALLOW_SUPERUSER' => '1',
]);

// =============================================================================
// Shared Files & Directories
// =============================================================================

// Files shared between releases (symlinked from shared/)
add('shared_files', [
    '.env.local',
    '.env.local.php',
]);

// Directories shared between releases (symlinked from shared/)
add('shared_dirs', [
    'var/log',
    'public/uploads',
]);

// Directories that need to be writable
add('writable_dirs', [
    'var',
    'var/cache',
    'var/log',
    'public/uploads',
]);

set('writable_mode', 'chmod');

// =============================================================================
// Hosts Configuration
// =============================================================================

host('production')
    ->setHostname('193.187.129.7')
    ->setRemoteUser('root')
    ->setDeployPath('/var/www/honeyguide-projects')
    ->set('branch', 'liveApp')
    ->set('http_user', 'www-data')
    ->set('domain', 'projects.honeyguide.org')
    ->set('public_path', 'public')
    ->setSshArguments([
        '-A',
        '-o StrictHostKeyChecking=no',
    ]);

// =============================================================================
// Tasks
// =============================================================================

// Database backup before migration
desc('Backup database before deploy');
task('database:backup', function () {
    $backupDir = '/var/backups/honeyguide-projects';
    $dbName = 'honeyguide_projects';
    $dbUser = 'honeyguide';
    $dbPass = 'HoneyguideApp2024Secure';
    $timestamp = date('Ymd_His');
    $backupFile = "{$backupDir}/db_{$dbName}_{$timestamp}.sql.gz";

    // Create backup directory if it doesn't exist
    run("mkdir -p {$backupDir}");

    // Check if database exists and has tables before backing up
    $tableCount = run("mysql -u{$dbUser} -p{$dbPass} -N -e \"SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='{$dbName}'\" 2>/dev/null || echo '0'");
    if (trim($tableCount) === '0') {
        writeln("<comment>Database is empty or doesn't exist, skipping backup</comment>");
        return;
    }

    run("mysqldump -u{$dbUser} -p{$dbPass} {$dbName} 2>/dev/null | gzip > {$backupFile}");
    writeln("<info>Database backed up to: {$backupFile}</info>");

    // Clean old backups (keep last 10)
    run("cd {$backupDir} && ls -t db_*.sql.gz 2>/dev/null | tail -n +11 | xargs -r rm -- 2>/dev/null || true");
});

// Dump environment for production
desc('Dump environment for production');
task('deploy:dump-env', function () {
    cd('{{release_path}}');
    run('COMPOSER_ALLOW_SUPERUSER=1 {{bin/composer}} dump-env prod');
});

// Install importmap packages
desc('Install importmap packages');
task('deploy:importmap', function () {
    cd('{{release_path}}');
    run('{{bin/console}} importmap:install --no-interaction');
});

// Compile assets for production
desc('Compile assets for production');
task('deploy:assets:compile', function () {
    cd('{{release_path}}');
    run('{{bin/console}} asset-map:compile --no-interaction');

    // Create symlinks from unhashed to hashed filenames
    // This is needed because compiled JS files use relative imports that
    // browsers may not resolve through the importmap correctly
    run('cd {{release_path}}/public/assets && find . -name "*-*.js" -type f | while read f; do
        base=$(echo "$f" | sed "s/-[a-f0-9]*\\.js/.js/")
        [ ! -e "$base" ] && ln -sf "$(basename $f)" "$base"
    done');
    run('cd {{release_path}}/public/assets && find . -name "*-*.css" -type f | while read f; do
        base=$(echo "$f" | sed "s/-[a-f0-9]*\\.css/.css/")
        [ ! -e "$base" ] && ln -sf "$(basename $f)" "$base"
    done');
});

// Restart PHP-FPM
desc('Restart PHP-FPM');
task('php-fpm:restart', function () {
    $phpVersion = get('php_version', '8.3');
    run("systemctl restart php{$phpVersion}-fpm");
});

// Fix ownership after deploy
desc('Fix file ownership');
task('deploy:ownership', function () {
    run('chown -R www-data:www-data {{release_path}}');
    run('chown -R www-data:www-data {{deploy_path}}/shared');
});

// Run database migrations
desc('Run database migrations');
task('database:migrate', function () {
    run('{{bin/console}} doctrine:migrations:migrate --no-interaction --allow-no-migration');
});

// =============================================================================
// Deployment Flow
// =============================================================================

// Backup database before deploy starts
before('deploy:prepare', 'database:backup');

// Dump env after vendors are installed (so composer plugins are available)
after('deploy:vendors', 'deploy:dump-env');

// Install importmap packages after env dump
after('deploy:dump-env', 'deploy:importmap');

// Compile assets after importmap
after('deploy:importmap', 'deploy:assets:compile');

// Run database migrations after assets are compiled
after('deploy:assets:compile', 'database:migrate');

// Fix ownership after cache clear (cache is created by root, needs www-data ownership)
after('deploy:cache:clear', 'deploy:ownership');

// Restart PHP-FPM after symlink switch
after('deploy:symlink', 'php-fpm:restart');

// Unlock on failure
after('deploy:failed', 'deploy:unlock');

// =============================================================================
// Rollback
// =============================================================================

// Restart PHP-FPM after rollback too
after('rollback', 'php-fpm:restart');

// =============================================================================
// Apache Provisioning (custom tasks to replace Caddy-based provision)
// =============================================================================

desc('Provision server with Apache');
task('provision:apache', [
    'provision:apache:update',
    'provision:apache:packages',
    'provision:apache:php',
    'provision:apache:mysql',
    'provision:apache:composer',
    'provision:apache:webserver',
    'provision:apache:ssl',
    'provision:apache:firewall',
    'provision:apache:directories',
]);

desc('Update package lists');
task('provision:apache:update', function () {
    run('apt-get update');
});

desc('Install base packages');
task('provision:apache:packages', function () {
    run('DEBIAN_FRONTEND=noninteractive apt-get install -y curl wget git unzip acl ufw fail2ban htop vim software-properties-common apt-transport-https ca-certificates gnupg zip');
});

desc('Install PHP');
task('provision:apache:php', function () {
    $phpVersion = get('php_version', '8.3');

    // Add PHP repository
    run('add-apt-repository -y ppa:ondrej/php');
    run('apt-get update');

    // Install PHP and extensions (including FPM for production deployments)
    run("DEBIAN_FRONTEND=noninteractive apt-get install -y php{$phpVersion} php{$phpVersion}-cli php{$phpVersion}-fpm php{$phpVersion}-mysql php{$phpVersion}-xml php{$phpVersion}-mbstring php{$phpVersion}-curl php{$phpVersion}-zip php{$phpVersion}-intl php{$phpVersion}-gd php{$phpVersion}-opcache php{$phpVersion}-redis libapache2-mod-php{$phpVersion}");

    // Configure PHP-FPM
    run("sed -i 's/memory_limit = .*/memory_limit = 256M/' /etc/php/{$phpVersion}/fpm/php.ini");
    run("sed -i 's/upload_max_filesize = .*/upload_max_filesize = 64M/' /etc/php/{$phpVersion}/fpm/php.ini");
    run("sed -i 's/post_max_size = .*/post_max_size = 64M/' /etc/php/{$phpVersion}/fpm/php.ini");
    run("sed -i 's/max_execution_time = .*/max_execution_time = 60/' /etc/php/{$phpVersion}/fpm/php.ini");

    // Enable PHP-FPM with Apache
    run("a2enmod proxy_fcgi setenvif");
    run("a2enconf php{$phpVersion}-fpm");
    run("systemctl restart php{$phpVersion}-fpm");

    writeln('<info>PHP ' . $phpVersion . ' with FPM installed</info>');
});

desc('Install and configure MySQL');
task('provision:apache:mysql', function () {
    $dbName = get('mysql_database');
    $dbUser = get('mysql_user');
    $dbPass = get('mysql_password');

    // Install MySQL
    run('DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server mysql-client');
    run('systemctl enable mysql');
    run('systemctl start mysql');

    // Create database and user
    run("mysql -e \"CREATE DATABASE IF NOT EXISTS {$dbName}\"");
    run("mysql -e \"CREATE USER IF NOT EXISTS '{$dbUser}'@'localhost' IDENTIFIED BY '{$dbPass}'\"");
    run("mysql -e \"GRANT ALL PRIVILEGES ON {$dbName}.* TO '{$dbUser}'@'localhost'\"");
    run("mysql -e \"FLUSH PRIVILEGES\"");

    writeln('<info>MySQL configured with database: ' . $dbName . '</info>');
});

desc('Install Composer');
task('provision:apache:composer', function () {
    run('curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer');
    writeln('<info>Composer installed</info>');
});

desc('Install and configure Apache');
task('provision:apache:webserver', function () {
    $domain = get('domain');
    $deployPath = get('deploy_path');
    $phpVersion = get('php_version', '8.3');

    // Install Apache
    run('DEBIAN_FRONTEND=noninteractive apt-get install -y apache2');

    // Enable required modules
    run('a2enmod rewrite');
    run('a2enmod ssl');
    run('a2enmod headers');

    // Create virtual host configuration
    $vhostConfig = <<<APACHE
<VirtualHost *:80>
    ServerName {$domain}
    DocumentRoot {$deployPath}/current/public

    <Directory {$deployPath}/current/public>
        AllowOverride All
        Require all granted
        FallbackResource /index.php
    </Directory>

    # For Symfony
    <Directory {$deployPath}/current/public/bundles>
        FallbackResource disabled
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/{$domain}-error.log
    CustomLog \${APACHE_LOG_DIR}/{$domain}-access.log combined
</VirtualHost>
APACHE;

    run("echo " . escapeshellarg($vhostConfig) . " > /etc/apache2/sites-available/{$domain}.conf");

    // Disable default site and enable our site
    run('a2dissite 000-default.conf || true');
    run("a2ensite {$domain}.conf");

    // Start Apache
    run('systemctl enable apache2');
    run('systemctl restart apache2');

    writeln('<info>Apache configured for ' . $domain . '</info>');
});

desc('Setup SSL with Let\'s Encrypt');
task('provision:apache:ssl', function () {
    $domain = get('domain');

    // Install certbot
    run('DEBIAN_FRONTEND=noninteractive apt-get install -y certbot python3-certbot-apache');

    // Obtain SSL certificate
    run("certbot --apache -d {$domain} --non-interactive --agree-tos --email admin@{$domain} --redirect || true");

    // Setup auto-renewal
    run('systemctl enable certbot.timer || true');

    writeln('<info>SSL configured for ' . $domain . '</info>');
});

desc('Configure firewall');
task('provision:apache:firewall', function () {
    run('ufw allow 22/tcp');
    run('ufw allow 80/tcp');
    run('ufw allow 443/tcp');
    run('ufw --force enable');
    writeln('<info>Firewall configured</info>');
});

desc('Create deployment directories');
task('provision:apache:directories', function () {
    $deployPath = get('deploy_path');

    // Create Deployer directory structure
    run("mkdir -p {$deployPath}");
    run("mkdir -p {$deployPath}/shared");
    run("mkdir -p {$deployPath}/shared/var/log");
    run("mkdir -p {$deployPath}/shared/public/uploads");
    run("mkdir -p /var/backups/honeyguide-projects");

    // Set ownership
    run("chown -R www-data:www-data {$deployPath}");
    run("chown -R www-data:www-data /var/backups/honeyguide-projects");

    writeln('<info>Directories created at ' . $deployPath . '</info>');
});

desc('Restart Apache');
task('apache:restart', function () {
    run('systemctl restart apache2');
});

// Use Apache restart instead of PHP-FPM for Apache setup
// Override for Apache-based deployments
task('webserver:restart', function () {
    run('systemctl restart apache2');
});
