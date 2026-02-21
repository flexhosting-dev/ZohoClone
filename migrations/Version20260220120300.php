<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Add changelog entry for default milestones and ordering feature
 */
final class Version20260220120300 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Add changelog entry for version 1.0.1 - Default Milestones and Ordering';
    }

    public function up(Schema $schema): void
    {
        $this->addSql("
            INSERT INTO changelog (id, version, title, changes, release_date, created_at, updated_at)
            SELECT UUID(), '1.0.1', 'Default Milestones and Ordering',
                   '[\"New default General milestone in every project\", \"Tasks organized by project and milestone order\", \"Drag and drop to reorder projects and milestones\"]',
                   CURDATE(), NOW(), NOW()
            FROM DUAL
            WHERE NOT EXISTS (SELECT 1 FROM changelog WHERE version = '1.0.1')
        ");
    }

    public function down(Schema $schema): void
    {
        $this->addSql("DELETE FROM changelog WHERE version = '1.0.1' AND title = 'Default Milestones and Ordering'");
    }
}
