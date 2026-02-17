<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20260217051328 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Fix JSON columns to have default values and update existing NULL/empty values';
    }

    public function up(Schema $schema): void
    {
        // First, fix any NULL or empty values in existing data
        $this->addSql("UPDATE user SET ui_preferences = '[]' WHERE ui_preferences IS NULL OR ui_preferences = ''");
        $this->addSql("UPDATE user SET notification_preferences = '[]' WHERE notification_preferences IS NULL OR notification_preferences = ''");

        // Then alter the columns to have defaults and be NOT NULL
        $this->addSql('ALTER TABLE user CHANGE notification_preferences notification_preferences JSON DEFAULT \'[]\' NOT NULL COMMENT \'(DC2Type:json)\', CHANGE ui_preferences ui_preferences JSON DEFAULT \'[]\' NOT NULL COMMENT \'(DC2Type:json)\'');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE `user` CHANGE notification_preferences notification_preferences JSON NOT NULL COMMENT \'(DC2Type:json)\', CHANGE ui_preferences ui_preferences JSON NOT NULL COMMENT \'(DC2Type:json)\'');
    }
}
