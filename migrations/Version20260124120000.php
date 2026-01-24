<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Migration to add task_checklist table for checklist items on tasks.
 */
final class Version20260124120000 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Add task_checklist table for checklist items';
    }

    public function up(Schema $schema): void
    {
        $this->addSql('CREATE TABLE task_checklist (id CHAR(36) NOT NULL COMMENT \'(DC2Type:uuid)\', task_id CHAR(36) NOT NULL COMMENT \'(DC2Type:uuid)\', title VARCHAR(500) NOT NULL, is_completed TINYINT(1) NOT NULL, position INT NOT NULL, created_at DATETIME NOT NULL COMMENT \'(DC2Type:datetime_immutable)\', INDEX IDX_TASK_CHECKLIST_TASK (task_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB');
        $this->addSql('ALTER TABLE task_checklist ADD CONSTRAINT FK_TASK_CHECKLIST_TASK FOREIGN KEY (task_id) REFERENCES task (id) ON DELETE CASCADE');
    }

    public function down(Schema $schema): void
    {
        $this->addSql('ALTER TABLE task_checklist DROP FOREIGN KEY FK_TASK_CHECKLIST_TASK');
        $this->addSql('DROP TABLE task_checklist');
    }
}
