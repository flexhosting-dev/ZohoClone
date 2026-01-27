<?php

namespace App\Enum;

/**
 * Defines all granular permissions available in the system.
 * Permissions follow the pattern: module.action
 */
final class Permission
{
    // Project permissions
    public const PROJECT_VIEW = 'project.view';
    public const PROJECT_CREATE = 'project.create';
    public const PROJECT_EDIT = 'project.edit';
    public const PROJECT_DELETE = 'project.delete';
    public const PROJECT_MANAGE_MEMBERS = 'project.manage_members';
    public const PROJECT_ARCHIVE = 'project.archive';

    // Milestone permissions
    public const MILESTONE_VIEW = 'milestone.view';
    public const MILESTONE_CREATE = 'milestone.create';
    public const MILESTONE_EDIT = 'milestone.edit';
    public const MILESTONE_DELETE = 'milestone.delete';
    public const MILESTONE_COMPLETE = 'milestone.complete';

    // Task permissions
    public const TASK_VIEW = 'task.view';
    public const TASK_CREATE = 'task.create';
    public const TASK_EDIT = 'task.edit';
    public const TASK_DELETE = 'task.delete';
    public const TASK_ASSIGN = 'task.assign';
    public const TASK_CHANGE_STATUS = 'task.change_status';
    public const TASK_CHANGE_PRIORITY = 'task.change_priority';

    // Checklist permissions
    public const CHECKLIST_VIEW = 'checklist.view';
    public const CHECKLIST_CREATE = 'checklist.create';
    public const CHECKLIST_EDIT = 'checklist.edit';
    public const CHECKLIST_DELETE = 'checklist.delete';
    public const CHECKLIST_TOGGLE = 'checklist.toggle';

    // Comment permissions
    public const COMMENT_VIEW = 'comment.view';
    public const COMMENT_CREATE = 'comment.create';
    public const COMMENT_EDIT_OWN = 'comment.edit_own';
    public const COMMENT_EDIT_ANY = 'comment.edit_any';
    public const COMMENT_DELETE_OWN = 'comment.delete_own';
    public const COMMENT_DELETE_ANY = 'comment.delete_any';

    // Tag permissions
    public const TAG_VIEW = 'tag.view';
    public const TAG_CREATE = 'tag.create';
    public const TAG_EDIT = 'tag.edit';
    public const TAG_DELETE = 'tag.delete';
    public const TAG_ASSIGN = 'tag.assign';

    // User management (portal-level only)
    public const USER_VIEW = 'user.view';
    public const USER_CREATE = 'user.create';
    public const USER_EDIT = 'user.edit';
    public const USER_DELETE = 'user.delete';
    public const USER_MANAGE_ROLES = 'user.manage_roles';

    // Role management (portal-level only)
    public const ROLE_VIEW = 'role.view';
    public const ROLE_CREATE = 'role.create';
    public const ROLE_EDIT = 'role.edit';
    public const ROLE_DELETE = 'role.delete';

    /**
     * Get all permissions grouped by module.
     */
    public static function getAll(): array
    {
        return [
            'project' => [
                self::PROJECT_VIEW,
                self::PROJECT_CREATE,
                self::PROJECT_EDIT,
                self::PROJECT_DELETE,
                self::PROJECT_MANAGE_MEMBERS,
                self::PROJECT_ARCHIVE,
            ],
            'milestone' => [
                self::MILESTONE_VIEW,
                self::MILESTONE_CREATE,
                self::MILESTONE_EDIT,
                self::MILESTONE_DELETE,
                self::MILESTONE_COMPLETE,
            ],
            'task' => [
                self::TASK_VIEW,
                self::TASK_CREATE,
                self::TASK_EDIT,
                self::TASK_DELETE,
                self::TASK_ASSIGN,
                self::TASK_CHANGE_STATUS,
                self::TASK_CHANGE_PRIORITY,
            ],
            'checklist' => [
                self::CHECKLIST_VIEW,
                self::CHECKLIST_CREATE,
                self::CHECKLIST_EDIT,
                self::CHECKLIST_DELETE,
                self::CHECKLIST_TOGGLE,
            ],
            'comment' => [
                self::COMMENT_VIEW,
                self::COMMENT_CREATE,
                self::COMMENT_EDIT_OWN,
                self::COMMENT_EDIT_ANY,
                self::COMMENT_DELETE_OWN,
                self::COMMENT_DELETE_ANY,
            ],
            'tag' => [
                self::TAG_VIEW,
                self::TAG_CREATE,
                self::TAG_EDIT,
                self::TAG_DELETE,
                self::TAG_ASSIGN,
            ],
            'user' => [
                self::USER_VIEW,
                self::USER_CREATE,
                self::USER_EDIT,
                self::USER_DELETE,
                self::USER_MANAGE_ROLES,
            ],
            'role' => [
                self::ROLE_VIEW,
                self::ROLE_CREATE,
                self::ROLE_EDIT,
                self::ROLE_DELETE,
            ],
        ];
    }

    /**
     * Get human-readable label for a permission.
     */
    public static function getLabel(string $permission): string
    {
        return match ($permission) {
            self::PROJECT_VIEW => 'View Projects',
            self::PROJECT_CREATE => 'Create Projects',
            self::PROJECT_EDIT => 'Edit Projects',
            self::PROJECT_DELETE => 'Delete Projects',
            self::PROJECT_MANAGE_MEMBERS => 'Manage Project Members',
            self::PROJECT_ARCHIVE => 'Archive Projects',

            self::MILESTONE_VIEW => 'View Milestones',
            self::MILESTONE_CREATE => 'Create Milestones',
            self::MILESTONE_EDIT => 'Edit Milestones',
            self::MILESTONE_DELETE => 'Delete Milestones',
            self::MILESTONE_COMPLETE => 'Complete Milestones',

            self::TASK_VIEW => 'View Tasks',
            self::TASK_CREATE => 'Create Tasks',
            self::TASK_EDIT => 'Edit Tasks',
            self::TASK_DELETE => 'Delete Tasks',
            self::TASK_ASSIGN => 'Assign Tasks',
            self::TASK_CHANGE_STATUS => 'Change Task Status',
            self::TASK_CHANGE_PRIORITY => 'Change Task Priority',

            self::CHECKLIST_VIEW => 'View Checklists',
            self::CHECKLIST_CREATE => 'Create Checklists',
            self::CHECKLIST_EDIT => 'Edit Checklists',
            self::CHECKLIST_DELETE => 'Delete Checklists',
            self::CHECKLIST_TOGGLE => 'Toggle Checklist Items',

            self::COMMENT_VIEW => 'View Comments',
            self::COMMENT_CREATE => 'Create Comments',
            self::COMMENT_EDIT_OWN => 'Edit Own Comments',
            self::COMMENT_EDIT_ANY => 'Edit Any Comment',
            self::COMMENT_DELETE_OWN => 'Delete Own Comments',
            self::COMMENT_DELETE_ANY => 'Delete Any Comment',

            self::TAG_VIEW => 'View Tags',
            self::TAG_CREATE => 'Create Tags',
            self::TAG_EDIT => 'Edit Tags',
            self::TAG_DELETE => 'Delete Tags',
            self::TAG_ASSIGN => 'Assign Tags to Tasks',

            self::USER_VIEW => 'View Users',
            self::USER_CREATE => 'Create Users',
            self::USER_EDIT => 'Edit Users',
            self::USER_DELETE => 'Delete Users',
            self::USER_MANAGE_ROLES => 'Manage User Roles',

            self::ROLE_VIEW => 'View Roles',
            self::ROLE_CREATE => 'Create Roles',
            self::ROLE_EDIT => 'Edit Roles',
            self::ROLE_DELETE => 'Delete Roles',

            default => $permission,
        };
    }

    /**
     * Get portal-level permissions (not project-specific).
     */
    public static function getPortalPermissions(): array
    {
        return [
            self::PROJECT_CREATE,
            self::USER_VIEW,
            self::USER_CREATE,
            self::USER_EDIT,
            self::USER_DELETE,
            self::USER_MANAGE_ROLES,
            self::ROLE_VIEW,
            self::ROLE_CREATE,
            self::ROLE_EDIT,
            self::ROLE_DELETE,
        ];
    }

    /**
     * Get project-level permissions.
     */
    public static function getProjectPermissions(): array
    {
        return array_merge(
            self::getAll()['project'],
            self::getAll()['milestone'],
            self::getAll()['task'],
            self::getAll()['checklist'],
            self::getAll()['comment'],
            self::getAll()['tag'],
        );
    }
}
