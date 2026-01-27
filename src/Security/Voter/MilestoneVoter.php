<?php

namespace App\Security\Voter;

use App\Entity\Milestone;
use App\Entity\User;
use App\Enum\Permission;
use App\Service\PermissionChecker;
use Symfony\Component\Security\Core\Authentication\Token\TokenInterface;
use Symfony\Component\Security\Core\Authorization\Voter\Voter;

class MilestoneVoter extends Voter
{
    public const VIEW = 'MILESTONE_VIEW';
    public const CREATE = 'MILESTONE_CREATE';
    public const EDIT = 'MILESTONE_EDIT';
    public const DELETE = 'MILESTONE_DELETE';
    public const COMPLETE = 'MILESTONE_COMPLETE';

    public function __construct(
        private readonly PermissionChecker $permissionChecker,
    ) {
    }

    protected function supports(string $attribute, mixed $subject): bool
    {
        return in_array($attribute, [
            self::VIEW,
            self::CREATE,
            self::EDIT,
            self::DELETE,
            self::COMPLETE,
        ]) && $subject instanceof Milestone;
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
            self::VIEW => Permission::MILESTONE_VIEW,
            self::CREATE => Permission::MILESTONE_CREATE,
            self::EDIT => Permission::MILESTONE_EDIT,
            self::DELETE => Permission::MILESTONE_DELETE,
            self::COMPLETE => Permission::MILESTONE_COMPLETE,
            default => throw new \InvalidArgumentException("Unknown attribute: $attribute"),
        };
    }
}
