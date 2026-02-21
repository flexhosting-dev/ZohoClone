<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Add changelog entry for version 1.0.2 - Mobile App and Collaboration Features
 */
final class Version20260221065000 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Add changelog entry for version 1.0.2 - Mobile App and Collaboration Features';
    }

    public function up(Schema $schema): void
    {
        $this->addSql("
            INSERT INTO changelog (id, version, title, changes, release_date, created_at, updated_at)
            SELECT UUID(), '1.0.2', 'Mobile App and Collaboration Features',
                   '[\"Install app on your phone like a native app\", \"Invite people to projects via email\", \"Add multiple members to a project at once\", \"Create tasks that repeat automatically (daily, weekly, monthly)\", \"New users get a personal project automatically\", \"Tasks stay organized in parent-child order\"]',
                   CURDATE(), NOW(), NOW()
            FROM DUAL
            WHERE NOT EXISTS (SELECT 1 FROM changelog WHERE version = '1.0.2')
        ");
    }

    public function down(Schema $schema): void
    {
        $this->addSql("DELETE FROM changelog WHERE version = '1.0.2' AND title = 'Mobile App and Collaboration Features'");
    }
}
