<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20260215205245 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE task CHANGE status_type_id status_type_id CHAR(36) DEFAULT NULL COMMENT \'(DC2Type:uuid)\'');
        $this->addSql('ALTER TABLE task RENAME INDEX idx_527edb2570a22ce8 TO idx_task_status_type');
        $this->addSql('ALTER TABLE user ADD table_preferences JSON NOT NULL COMMENT \'(DC2Type:json)\', CHANGE hidden_recent_project_ids hidden_recent_project_ids JSON NOT NULL COMMENT \'(DC2Type:json)\', CHANGE hidden_project_ids hidden_project_ids JSON NOT NULL COMMENT \'(DC2Type:json)\'');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE `user` DROP table_preferences, CHANGE hidden_recent_project_ids hidden_recent_project_ids JSON DEFAULT NULL COMMENT \'(DC2Type:json)\', CHANGE hidden_project_ids hidden_project_ids JSON DEFAULT NULL COMMENT \'(DC2Type:json)\'');
        $this->addSql('ALTER TABLE task CHANGE status_type_id status_type_id CHAR(36) DEFAULT NULL');
        $this->addSql('ALTER TABLE task RENAME INDEX idx_task_status_type TO IDX_527EDB2570A22CE8');
    }
}
