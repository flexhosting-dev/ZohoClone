<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20260131123653 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TABLE milestone_target (id CHAR(36) NOT NULL COMMENT \'(DC2Type:uuid)\', milestone_id CHAR(36) NOT NULL COMMENT \'(DC2Type:uuid)\', description LONGTEXT NOT NULL, position INT NOT NULL, completed TINYINT(1) NOT NULL, INDEX IDX_4E516F2E4B3E2EDA (milestone_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB');
        $this->addSql('ALTER TABLE milestone_target ADD CONSTRAINT FK_4E516F2E4B3E2EDA FOREIGN KEY (milestone_id) REFERENCES milestone (id) ON DELETE CASCADE');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE milestone_target DROP FOREIGN KEY FK_4E516F2E4B3E2EDA');
        $this->addSql('DROP TABLE milestone_target');
    }
}
