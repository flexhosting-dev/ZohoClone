<?php

namespace App\DataFixtures;

use App\Entity\Role;
use App\Enum\Permission;
use App\Enum\RoleType;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Bundle\FixturesBundle\FixtureGroupInterface;
use Doctrine\Persistence\ObjectManager;

class RoleFixtures extends Fixture implements FixtureGroupInterface
{
    public const PORTAL_SUPER_ADMIN = 'role-portal-super-admin';
    public const PORTAL_ADMIN = 'role-portal-admin';
    public const PROJECT_MANAGER = 'role-project-manager';
    public const PROJECT_MEMBER = 'role-project-member';
    public const PROJECT_VIEWER = 'role-project-viewer';

    public static function getGroups(): array
    {
        return ['roles', 'default'];
    }

    public function load(ObjectManager $manager): void
    {
        // Portal SuperAdmin - Full system access
        $superAdmin = new Role();
        $superAdmin->setName('Portal SuperAdmin');
        $superAdmin->setSlug('portal-super-admin');
        $superAdmin->setDescription('Full system access with all permissions');
        $superAdmin->setType(RoleType::PORTAL);
        $superAdmin->setIsSystemRole(true);
        $superAdmin->setPermissions($this->getAllPermissions());
        $manager->persist($superAdmin);
        $this->addReference(self::PORTAL_SUPER_ADMIN, $superAdmin);

        // Portal Admin - User and project management
        $admin = new Role();
        $admin->setName('Portal Admin');
        $admin->setSlug('portal-admin');
        $admin->setDescription('Manage users and access all projects');
        $admin->setType(RoleType::PORTAL);
        $admin->setIsSystemRole(true);
        $admin->setPermissions([
            // User management
            Permission::USER_VIEW,
            Permission::USER_CREATE,
            Permission::USER_EDIT,
            Permission::USER_MANAGE_ROLES,
            // Role viewing
            Permission::ROLE_VIEW,
            // Project management
            Permission::PROJECT_VIEW,
            Permission::PROJECT_CREATE,
            Permission::PROJECT_EDIT,
            Permission::PROJECT_DELETE,
            Permission::PROJECT_MANAGE_MEMBERS,
            Permission::PROJECT_ARCHIVE,
            // Full project-level access
            ...Permission::getProjectPermissions(),
        ]);
        $manager->persist($admin);
        $this->addReference(self::PORTAL_ADMIN, $admin);

        // Project Manager - Full project control
        $projectManager = new Role();
        $projectManager->setName('Project Manager');
        $projectManager->setSlug('project-manager');
        $projectManager->setDescription('Full control over assigned projects');
        $projectManager->setType(RoleType::PROJECT);
        $projectManager->setIsSystemRole(true);
        $projectManager->setPermissions([
            // Project
            Permission::PROJECT_VIEW,
            Permission::PROJECT_EDIT,
            Permission::PROJECT_DELETE,
            Permission::PROJECT_MANAGE_MEMBERS,
            Permission::PROJECT_ARCHIVE,
            // Milestone
            Permission::MILESTONE_VIEW,
            Permission::MILESTONE_CREATE,
            Permission::MILESTONE_EDIT,
            Permission::MILESTONE_DELETE,
            Permission::MILESTONE_COMPLETE,
            // Task
            Permission::TASK_VIEW,
            Permission::TASK_CREATE,
            Permission::TASK_EDIT,
            Permission::TASK_DELETE,
            Permission::TASK_ASSIGN,
            Permission::TASK_CHANGE_STATUS,
            Permission::TASK_CHANGE_PRIORITY,
            // Checklist
            Permission::CHECKLIST_VIEW,
            Permission::CHECKLIST_CREATE,
            Permission::CHECKLIST_EDIT,
            Permission::CHECKLIST_DELETE,
            Permission::CHECKLIST_TOGGLE,
            // Comment
            Permission::COMMENT_VIEW,
            Permission::COMMENT_CREATE,
            Permission::COMMENT_EDIT_OWN,
            Permission::COMMENT_EDIT_ANY,
            Permission::COMMENT_DELETE_OWN,
            Permission::COMMENT_DELETE_ANY,
            // Tag
            Permission::TAG_VIEW,
            Permission::TAG_CREATE,
            Permission::TAG_EDIT,
            Permission::TAG_DELETE,
            Permission::TAG_ASSIGN,
        ]);
        $manager->persist($projectManager);
        $this->addReference(self::PROJECT_MANAGER, $projectManager);

        // Project Member - Work on tasks
        $projectMember = new Role();
        $projectMember->setName('Project Member');
        $projectMember->setSlug('project-member');
        $projectMember->setDescription('Work on tasks and collaborate');
        $projectMember->setType(RoleType::PROJECT);
        $projectMember->setIsSystemRole(true);
        $projectMember->setPermissions([
            // Project
            Permission::PROJECT_VIEW,
            // Milestone
            Permission::MILESTONE_VIEW,
            Permission::MILESTONE_COMPLETE,
            // Task
            Permission::TASK_VIEW,
            Permission::TASK_CREATE,
            Permission::TASK_EDIT,
            Permission::TASK_ASSIGN,
            Permission::TASK_CHANGE_STATUS,
            Permission::TASK_CHANGE_PRIORITY,
            // Checklist
            Permission::CHECKLIST_VIEW,
            Permission::CHECKLIST_CREATE,
            Permission::CHECKLIST_EDIT,
            Permission::CHECKLIST_DELETE,
            Permission::CHECKLIST_TOGGLE,
            // Comment
            Permission::COMMENT_VIEW,
            Permission::COMMENT_CREATE,
            Permission::COMMENT_EDIT_OWN,
            Permission::COMMENT_DELETE_OWN,
            // Tag
            Permission::TAG_VIEW,
            Permission::TAG_CREATE,
            Permission::TAG_ASSIGN,
        ]);
        $manager->persist($projectMember);
        $this->addReference(self::PROJECT_MEMBER, $projectMember);

        // Project Viewer - Read-only access
        $projectViewer = new Role();
        $projectViewer->setName('Project Viewer');
        $projectViewer->setSlug('project-viewer');
        $projectViewer->setDescription('Read-only access to project');
        $projectViewer->setType(RoleType::PROJECT);
        $projectViewer->setIsSystemRole(true);
        $projectViewer->setPermissions([
            Permission::PROJECT_VIEW,
            Permission::MILESTONE_VIEW,
            Permission::TASK_VIEW,
            Permission::CHECKLIST_VIEW,
            Permission::COMMENT_VIEW,
            Permission::TAG_VIEW,
        ]);
        $manager->persist($projectViewer);
        $this->addReference(self::PROJECT_VIEWER, $projectViewer);

        $manager->flush();
    }

    private function getAllPermissions(): array
    {
        $all = [];
        foreach (Permission::getAll() as $permissions) {
            $all = array_merge($all, $permissions);
        }
        return array_unique($all);
    }
}
