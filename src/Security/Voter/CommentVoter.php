<?php

namespace App\Security\Voter;

use App\Entity\Comment;
use App\Entity\User;
use App\Enum\Permission;
use App\Service\PermissionChecker;
use Symfony\Component\Security\Core\Authentication\Token\TokenInterface;
use Symfony\Component\Security\Core\Authorization\Voter\Voter;

class CommentVoter extends Voter
{
    public const VIEW = 'COMMENT_VIEW';
    public const CREATE = 'COMMENT_CREATE';
    public const EDIT = 'COMMENT_EDIT';
    public const DELETE = 'COMMENT_DELETE';

    public function __construct(
        private readonly PermissionChecker $permissionChecker,
    ) {
    }

    protected function supports(string $attribute, mixed $subject): bool
    {
        return in_array($attribute, [self::VIEW, self::CREATE, self::EDIT, self::DELETE])
            && $subject instanceof Comment;
    }

    protected function voteOnAttribute(string $attribute, mixed $subject, TokenInterface $token): bool
    {
        $user = $token->getUser();

        if (!$user instanceof User) {
            return false;
        }

        /** @var Comment $comment */
        $comment = $subject;

        return match ($attribute) {
            self::VIEW => $this->permissionChecker->hasPermission($user, Permission::COMMENT_VIEW, $comment),
            self::CREATE => $this->permissionChecker->hasPermission($user, Permission::COMMENT_CREATE, $comment),
            self::EDIT => $this->canEdit($user, $comment),
            self::DELETE => $this->canDelete($user, $comment),
            default => false,
        };
    }

    private function canEdit(User $user, Comment $comment): bool
    {
        return $this->permissionChecker->hasOwnResourcePermission(
            $user,
            Permission::COMMENT_EDIT_OWN,
            Permission::COMMENT_EDIT_ANY,
            $comment,
            $comment->getAuthor()
        );
    }

    private function canDelete(User $user, Comment $comment): bool
    {
        return $this->permissionChecker->hasOwnResourcePermission(
            $user,
            Permission::COMMENT_DELETE_OWN,
            Permission::COMMENT_DELETE_ANY,
            $comment,
            $comment->getAuthor()
        );
    }
}
