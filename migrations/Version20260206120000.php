<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

final class Version20260206120000 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Add task_table_preferences column to user table';
    }

    public function up(Schema $schema): void
    {
        $this->addSql('ALTER TABLE `user` ADD task_table_preferences JSON NOT NULL DEFAULT \'[]\' COMMENT \'(DC2Type:json)\'');
        $this->addSql('UPDATE `user` SET task_table_preferences = \'{}\'');
        $this->addSql('ALTER TABLE `user` ALTER task_table_preferences DROP DEFAULT');
    }

    public function down(Schema $schema): void
    {
        $this->addSql('ALTER TABLE `user` DROP task_table_preferences');
    }
}
