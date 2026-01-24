<?php

namespace App\Security\Voter;

use App\Entity\Task;
use App\Entity\User;
use App\Repository\ProjectMemberRepository;
use Symfony\Component\Security\Core\Authentication\Token\TokenInterface;
use Symfony\Component\Security\Core\Authorization\Voter\Voter;

class TaskVoter extends Voter
{
    public const VIEW = 'TASK_VIEW';
    public const EDIT = 'TASK_EDIT';
    public const DELETE = 'TASK_DELETE';

    public function __construct(
        private readonly ProjectMemberRepository $projectMemberRepository,
    ) {
    }

    protected function supports(string $attribute, mixed $subject): bool
    {
        return in_array($attribute, [self::VIEW, self::EDIT, self::DELETE])
            && $subject instanceof Task;
    }

    protected function voteOnAttribute(string $attribute, mixed $subject, TokenInterface $token): bool
    {
        $user = $token->getUser();

        if (!$user instanceof User) {
            return false;
        }

        /** @var Task $task */
        $task = $subject;
        $project = $task->getMilestone()->getProject();

        // Check if user is project owner
        if ($project->getOwner()->getId()->equals($user->getId())) {
            return true;
        }

        // Check membership
        $membership = $this->projectMemberRepository->findByProjectAndUser($project, $user);

        if (!$membership) {
            return false;
        }

        $role = $membership->getRole();

        return match ($attribute) {
            self::VIEW => true, // All members can view
            self::EDIT, self::DELETE => $role->canEdit(),
            default => false,
        };
    }
}
