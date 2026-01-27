<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;
use Ramsey\Uuid\Uuid;

/**
 * Migration to add Role-based permission system.
 * - Creates role table with default system roles
 * - Migrates existing ProjectMember role enum to new Role entity
 * - Adds portal_role to User entity
 */
final class Version20260127174145 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Add Role-based permission system with granular permissions';
    }

    public function up(Schema $schema): void
    {
        // 1. Create role table
        $this->addSql('CREATE TABLE role (
            id CHAR(36) NOT NULL COMMENT \'(DC2Type:uuid)\',
            name VARCHAR(100) NOT NULL,
            slug VARCHAR(100) NOT NULL,
            description LONGTEXT DEFAULT NULL,
            type VARCHAR(255) NOT NULL,
            is_system_role TINYINT(1) NOT NULL,
            permissions JSON NOT NULL COMMENT \'(DC2Type:json)\',
            created_at DATETIME NOT NULL COMMENT \'(DC2Type:datetime_immutable)\',
            updated_at DATETIME NOT NULL COMMENT \'(DC2Type:datetime_immutable)\',
            UNIQUE INDEX UNIQ_ROLE_SLUG (slug),
            PRIMARY KEY(id)
        ) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB');

        // 2. Insert default system roles
        $now = (new \DateTimeImmutable())->format('Y-m-d H:i:s');

        // Portal SuperAdmin
        $superAdminId = Uuid::uuid7()->toString();
        $superAdminPermissions = json_encode([
            'project.view', 'project.create', 'project.edit', 'project.delete', 'project.manage_members', 'project.archive',
            'milestone.view', 'milestone.create', 'milestone.edit', 'milestone.delete', 'milestone.complete',
            'task.view', 'task.create', 'task.edit', 'task.delete', 'task.assign', 'task.change_status', 'task.change_priority',
            'checklist.view', 'checklist.create', 'checklist.edit', 'checklist.delete', 'checklist.toggle',
            'comment.view', 'comment.create', 'comment.edit_own', 'comment.edit_any', 'comment.delete_own', 'comment.delete_any',
            'tag.view', 'tag.create', 'tag.edit', 'tag.delete', 'tag.assign',
            'user.view', 'user.create', 'user.edit', 'user.delete', 'user.manage_roles',
            'role.view', 'role.create', 'role.edit', 'role.delete',
        ]);
        $this->addSql("INSERT INTO role (id, name, slug, description, type, is_system_role, permissions, created_at, updated_at) VALUES ('{$superAdminId}', 'Portal SuperAdmin', 'portal-super-admin', 'Full system access with all permissions', 'portal', 1, '{$superAdminPermissions}', '{$now}', '{$now}')");

        // Portal Admin
        $adminId = Uuid::uuid7()->toString();
        $adminPermissions = json_encode([
            'project.view', 'project.create', 'project.edit', 'project.delete', 'project.manage_members', 'project.archive',
            'milestone.view', 'milestone.create', 'milestone.edit', 'milestone.delete', 'milestone.complete',
            'task.view', 'task.create', 'task.edit', 'task.delete', 'task.assign', 'task.change_status', 'task.change_priority',
            'checklist.view', 'checklist.create', 'checklist.edit', 'checklist.delete', 'checklist.toggle',
            'comment.view', 'comment.create', 'comment.edit_own', 'comment.edit_any', 'comment.delete_own', 'comment.delete_any',
            'tag.view', 'tag.create', 'tag.edit', 'tag.delete', 'tag.assign',
            'user.view', 'user.create', 'user.edit', 'user.manage_roles',
            'role.view',
        ]);
        $this->addSql("INSERT INTO role (id, name, slug, description, type, is_system_role, permissions, created_at, updated_at) VALUES ('{$adminId}', 'Portal Admin', 'portal-admin', 'Manage users and access all projects', 'portal', 1, '{$adminPermissions}', '{$now}', '{$now}')");

        // Project Manager
        $managerId = Uuid::uuid7()->toString();
        $managerPermissions = json_encode([
            'project.view', 'project.edit', 'project.delete', 'project.manage_members', 'project.archive',
            'milestone.view', 'milestone.create', 'milestone.edit', 'milestone.delete', 'milestone.complete',
            'task.view', 'task.create', 'task.edit', 'task.delete', 'task.assign', 'task.change_status', 'task.change_priority',
            'checklist.view', 'checklist.create', 'checklist.edit', 'checklist.delete', 'checklist.toggle',
            'comment.view', 'comment.create', 'comment.edit_own', 'comment.edit_any', 'comment.delete_own', 'comment.delete_any',
            'tag.view', 'tag.create', 'tag.edit', 'tag.delete', 'tag.assign',
        ]);
        $this->addSql("INSERT INTO role (id, name, slug, description, type, is_system_role, permissions, created_at, updated_at) VALUES ('{$managerId}', 'Project Manager', 'project-manager', 'Full control over assigned projects', 'project', 1, '{$managerPermissions}', '{$now}', '{$now}')");

        // Project Member
        $memberId = Uuid::uuid7()->toString();
        $memberPermissions = json_encode([
            'project.view',
            'milestone.view', 'milestone.complete',
            'task.view', 'task.create', 'task.edit', 'task.assign', 'task.change_status', 'task.change_priority',
            'checklist.view', 'checklist.create', 'checklist.edit', 'checklist.delete', 'checklist.toggle',
            'comment.view', 'comment.create', 'comment.edit_own', 'comment.delete_own',
            'tag.view', 'tag.create', 'tag.assign',
        ]);
        $this->addSql("INSERT INTO role (id, name, slug, description, type, is_system_role, permissions, created_at, updated_at) VALUES ('{$memberId}', 'Project Member', 'project-member', 'Work on tasks and collaborate', 'project', 1, '{$memberPermissions}', '{$now}', '{$now}')");

        // Project Viewer
        $viewerId = Uuid::uuid7()->toString();
        $viewerPermissions = json_encode([
            'project.view', 'milestone.view', 'task.view', 'checklist.view', 'comment.view', 'tag.view',
        ]);
        $this->addSql("INSERT INTO role (id, name, slug, description, type, is_system_role, permissions, created_at, updated_at) VALUES ('{$viewerId}', 'Project Viewer', 'project-viewer', 'Read-only access to project', 'project', 1, '{$viewerPermissions}', '{$now}', '{$now}')");

        // 3. Add role_id column to project_member (nullable first for migration)
        $this->addSql('ALTER TABLE project_member ADD role_id CHAR(36) DEFAULT NULL COMMENT \'(DC2Type:uuid)\'');

        // 4. Migrate existing role enum values to new role IDs
        $this->addSql("UPDATE project_member SET role_id = '{$managerId}' WHERE role = 'admin'");
        $this->addSql("UPDATE project_member SET role_id = '{$memberId}' WHERE role = 'member'");
        $this->addSql("UPDATE project_member SET role_id = '{$viewerId}' WHERE role = 'viewer'");

        // 5. Make role_id NOT NULL and add foreign key
        $this->addSql('ALTER TABLE project_member MODIFY role_id CHAR(36) NOT NULL COMMENT \'(DC2Type:uuid)\'');
        $this->addSql('ALTER TABLE project_member ADD CONSTRAINT FK_67401132D60322AC FOREIGN KEY (role_id) REFERENCES role (id)');
        $this->addSql('CREATE INDEX IDX_67401132D60322AC ON project_member (role_id)');

        // 6. Drop old role column
        $this->addSql('ALTER TABLE project_member DROP role');

        // 7. Add portal_role_id to user
        $this->addSql('ALTER TABLE user ADD portal_role_id CHAR(36) DEFAULT NULL COMMENT \'(DC2Type:uuid)\'');
        $this->addSql('ALTER TABLE user ADD CONSTRAINT FK_8D93D649D7C6FAB5 FOREIGN KEY (portal_role_id) REFERENCES role (id)');
        $this->addSql('CREATE INDEX IDX_8D93D649D7C6FAB5 ON user (portal_role_id)');
    }

    public function down(Schema $schema): void
    {
        // Drop user portal_role
        $this->addSql('ALTER TABLE `user` DROP FOREIGN KEY FK_8D93D649D7C6FAB5');
        $this->addSql('DROP INDEX IDX_8D93D649D7C6FAB5 ON `user`');
        $this->addSql('ALTER TABLE `user` DROP portal_role_id');

        // Restore project_member role enum
        $this->addSql('ALTER TABLE project_member DROP FOREIGN KEY FK_67401132D60322AC');
        $this->addSql('DROP INDEX IDX_67401132D60322AC ON project_member');
        $this->addSql('ALTER TABLE project_member ADD role VARCHAR(255) NOT NULL DEFAULT \'member\'');

        // Migrate role_id back to enum values
        $this->addSql("UPDATE project_member pm JOIN role r ON pm.role_id = r.id SET pm.role = CASE r.slug WHEN 'project-manager' THEN 'admin' WHEN 'project-member' THEN 'member' WHEN 'project-viewer' THEN 'viewer' ELSE 'member' END");

        $this->addSql('ALTER TABLE project_member DROP role_id');

        // Drop role table
        $this->addSql('DROP TABLE role');
    }
}
