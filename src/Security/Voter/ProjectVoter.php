<?php

namespace App\Security\Voter;

use App\Entity\Project;
use App\Entity\User;
use App\Enum\Permission;
use App\Service\PermissionChecker;
use Symfony\Component\Security\Core\Authentication\Token\TokenInterface;
use Symfony\Component\Security\Core\Authorization\Voter\Voter;

class ProjectVoter extends Voter
{
    public const VIEW = 'PROJECT_VIEW';
    public const EDIT = 'PROJECT_EDIT';
    public const DELETE = 'PROJECT_DELETE';
    public const MANAGE_MEMBERS = 'PROJECT_MANAGE_MEMBERS';
    public const ARCHIVE = 'PROJECT_ARCHIVE';

    public function __construct(
        private readonly PermissionChecker $permissionChecker,
    ) {
    }

    protected function supports(string $attribute, mixed $subject): bool
    {
        return in_array($attribute, [self::VIEW, self::EDIT, self::DELETE, self::MANAGE_MEMBERS, self::ARCHIVE])
            && $subject instanceof Project;
    }

    protected function voteOnAttribute(string $attribute, mixed $subject, TokenInterface $token): bool
    {
        $user = $token->getUser();

        if (!$user instanceof User) {
            return false;
        }

        $permission = $this->mapAttributeToPermission($attribute);

        return $this->permissionChecker->hasPermission($user, $permission, $subject);
    }

    private function mapAttributeToPermission(string $attribute): string
    {
        return match ($attribute) {
            self::VIEW => Permission::PROJECT_VIEW,
            self::EDIT => Permission::PROJECT_EDIT,
            self::DELETE => Permission::PROJECT_DELETE,
            self::MANAGE_MEMBERS => Permission::PROJECT_MANAGE_MEMBERS,
            self::ARCHIVE => Permission::PROJECT_ARCHIVE,
            default => throw new \InvalidArgumentException("Unknown attribute: $attribute"),
        };
    }
}
