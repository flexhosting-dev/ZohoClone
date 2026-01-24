<?php

namespace App\Security\Voter;

use App\Entity\Comment;
use App\Entity\User;
use App\Repository\ProjectMemberRepository;
use Symfony\Component\Security\Core\Authentication\Token\TokenInterface;
use Symfony\Component\Security\Core\Authorization\Voter\Voter;

class CommentVoter extends Voter
{
    public const EDIT = 'COMMENT_EDIT';
    public const DELETE = 'COMMENT_DELETE';

    public function __construct(
        private readonly ProjectMemberRepository $projectMemberRepository,
    ) {
    }

    protected function supports(string $attribute, mixed $subject): bool
    {
        return in_array($attribute, [self::EDIT, self::DELETE])
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

        // Comment author can always edit/delete their own comments
        if ($comment->getAuthor()->getId()->equals($user->getId())) {
            return true;
        }

        $project = $comment->getTask()->getMilestone()->getProject();

        // Project owner can delete any comment
        if ($attribute === self::DELETE && $project->getOwner()->getId()->equals($user->getId())) {
            return true;
        }

        // Project admins can delete any comment
        if ($attribute === self::DELETE) {
            $membership = $this->projectMemberRepository->findByProjectAndUser($project, $user);
            if ($membership && $membership->getRole()->canManageMembers()) {
                return true;
            }
        }

        return false;
    }
}
