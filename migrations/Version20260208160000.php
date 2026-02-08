<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

final class Version20260208160000 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Remove 1.1.0 changelog entry';
    }

    public function up(Schema $schema): void
    {
        $this->addSql("DELETE FROM changelog WHERE version = '1.1.0'");
    }

    public function down(Schema $schema): void
    {
        // Cannot restore - data is gone
    }
}
