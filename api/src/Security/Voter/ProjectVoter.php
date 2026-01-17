<?php

namespace App\Security\Voter;

use App\Entity\Project;
use App\Entity\User;
use App\Enum\ProjectRole;
use App\Repository\ProjectMemberRepository;
use Symfony\Component\Security\Core\Authentication\Token\TokenInterface;
use Symfony\Component\Security\Core\Authorization\Voter\Voter;

class ProjectVoter extends Voter
{
    public const VIEW = 'PROJECT_VIEW';
    public const EDIT = 'PROJECT_EDIT';
    public const DELETE = 'PROJECT_DELETE';
    public const MANAGE_MEMBERS = 'PROJECT_MANAGE_MEMBERS';

    public function __construct(
        private readonly ProjectMemberRepository $projectMemberRepository,
    ) {
    }

    protected function supports(string $attribute, mixed $subject): bool
    {
        return in_array($attribute, [self::VIEW, self::EDIT, self::DELETE, self::MANAGE_MEMBERS])
            && $subject instanceof Project;
    }

    protected function voteOnAttribute(string $attribute, mixed $subject, TokenInterface $token): bool
    {
        $user = $token->getUser();

        if (!$user instanceof User) {
            return false;
        }

        /** @var Project $project */
        $project = $subject;

        // Owner has full access
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
            self::EDIT => $role->canEdit(),
            self::DELETE => $role->canDelete(),
            self::MANAGE_MEMBERS => $role->canManageMembers(),
            default => false,
        };
    }
}
