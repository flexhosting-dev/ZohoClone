<?php

namespace App\Security\Voter;

use App\Entity\Task;
use App\Entity\TaskChecklist;
use App\Entity\User;
use App\Enum\Permission;
use App\Service\PermissionChecker;
use Symfony\Component\Security\Core\Authentication\Token\TokenInterface;
use Symfony\Component\Security\Core\Authorization\Voter\Voter;

class ChecklistVoter extends Voter
{
    public const VIEW = 'CHECKLIST_VIEW';
    public const CREATE = 'CHECKLIST_CREATE';
    public const EDIT = 'CHECKLIST_EDIT';
    public const DELETE = 'CHECKLIST_DELETE';
    public const TOGGLE = 'CHECKLIST_TOGGLE';

    public function __construct(
        private readonly PermissionChecker $permissionChecker,
    ) {
    }

    protected function supports(string $attribute, mixed $subject): bool
    {
        // For VIEW, CREATE and EDIT, also accept Task as subject (for list/create/reorder operations)
        if (in_array($attribute, [self::VIEW, self::CREATE, self::EDIT]) && $subject instanceof Task) {
            return true;
        }

        return in_array($attribute, [
            self::VIEW,
            self::CREATE,
            self::EDIT,
            self::DELETE,
            self::TOGGLE,
        ]) && $subject instanceof TaskChecklist;
    }

    protected function voteOnAttribute(string $attribute, mixed $subject, TokenInterface $token): bool
    {
        $user = $token->getUser();

        if (!$user instanceof User) {
            return false;
        }

        $permission = $this->mapAttributeToPermission($attribute);

        // Subject can be either TaskChecklist or Task (for create/reorder)
        // PermissionChecker handles both via getProjectFromSubject()
        return $this->permissionChecker->hasPermission($user, $permission, $subject);
    }

    private function mapAttributeToPermission(string $attribute): string
    {
        return match ($attribute) {
            self::VIEW => Permission::CHECKLIST_VIEW,
            self::CREATE => Permission::CHECKLIST_CREATE,
            self::EDIT => Permission::CHECKLIST_EDIT,
            self::DELETE => Permission::CHECKLIST_DELETE,
            self::TOGGLE => Permission::CHECKLIST_TOGGLE,
            default => throw new \InvalidArgumentException("Unknown attribute: $attribute"),
        };
    }
}
