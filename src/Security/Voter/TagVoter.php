<?php

namespace App\Security\Voter;

use App\Entity\Project;
use App\Entity\Tag;
use App\Entity\User;
use App\Enum\Permission;
use App\Service\PermissionChecker;
use Symfony\Component\Security\Core\Authentication\Token\TokenInterface;
use Symfony\Component\Security\Core\Authorization\Voter\Voter;

/**
 * Tag voter that checks permissions in project context.
 * Tags are global but actions on them are checked against a project context.
 */
class TagVoter extends Voter
{
    public const VIEW = 'TAG_VIEW';
    public const CREATE = 'TAG_CREATE';
    public const EDIT = 'TAG_EDIT';
    public const DELETE = 'TAG_DELETE';
    public const ASSIGN = 'TAG_ASSIGN';

    public function __construct(
        private readonly PermissionChecker $permissionChecker,
    ) {
    }

    protected function supports(string $attribute, mixed $subject): bool
    {
        // Support both Tag entity and Project (for context-based checks)
        return in_array($attribute, [
            self::VIEW,
            self::CREATE,
            self::EDIT,
            self::DELETE,
            self::ASSIGN,
        ]) && ($subject instanceof Tag || $subject instanceof Project);
    }

    protected function voteOnAttribute(string $attribute, mixed $subject, TokenInterface $token): bool
    {
        $user = $token->getUser();

        if (!$user instanceof User) {
            return false;
        }

        $permission = $this->mapAttributeToPermission($attribute);

        // If subject is a Project, check permission in that context
        if ($subject instanceof Project) {
            return $this->permissionChecker->hasPermission($user, $permission, $subject);
        }

        // For Tag entity, we need a project context which may not be available
        // In this case, check if user has the permission in any of their projects
        // or is a portal admin
        if ($user->isPortalAdmin()) {
            return true;
        }

        // For tag operations without project context, check if user created it (for edit/delete)
        if ($subject instanceof Tag && in_array($attribute, [self::EDIT, self::DELETE])) {
            $creator = $subject->getCreatedBy();
            if ($creator && $creator->getId()->equals($user->getId())) {
                return true;
            }
        }

        return false;
    }

    private function mapAttributeToPermission(string $attribute): string
    {
        return match ($attribute) {
            self::VIEW => Permission::TAG_VIEW,
            self::CREATE => Permission::TAG_CREATE,
            self::EDIT => Permission::TAG_EDIT,
            self::DELETE => Permission::TAG_DELETE,
            self::ASSIGN => Permission::TAG_ASSIGN,
            default => throw new \InvalidArgumentException("Unknown attribute: $attribute"),
        };
    }
}
