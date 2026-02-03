<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Add is_personal column to project table for Personal Projects feature
 */
final class Version20260203120000 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Add is_personal column to project table';
    }

    public function up(Schema $schema): void
    {
        $this->addSql('ALTER TABLE project ADD is_personal TINYINT(1) DEFAULT 0 NOT NULL');
    }

    public function down(Schema $schema): void
    {
        $this->addSql('ALTER TABLE project DROP is_personal');
    }
}
